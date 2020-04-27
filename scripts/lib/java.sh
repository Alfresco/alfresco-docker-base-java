#!/bin/bash

# Given 8u181 or 11 or 11.0.1 return 8 or 11
java::version::major () {
    local java_version="$1"

    IFS='u' read -ra java_version <<< "${java_version}"
    IFS='.' read -ra java_version <<< "${java_version}"

    echo "${java_version}"
}

# Given 8u181 or 11 or 11.0.1 return if oracle or openjdk
# Hint: it's always OpenJDK unless we're on 8
java::vendor () {
    local java_version="$1"

    java_version=$(java::version::major "${java_version}")

    if [ "${java_version}" -lt 11 ]; then
        echo 'oracle'
    else
        echo 'openjdk'
    fi
}

# As Oracle have made downloading non-current versions of Java difficult,
# we are sadly having to store them in an internal repository.
# As of Java 11 we no longer ship Oracle Java any way.
#
# artifacts_repo_url is a global.
java::download::artifacts::mvn () {
    local group_id="$1"
    local artifact_id="$2"
    local java_version="$3"
    local java_packaging="$4"
    local download_dir="$5"

    # Use Maven 3
    unset M2_HOME
    export M3_HOME=/opt/apache-maven

    "${M3_HOME}"/bin/mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.2:copy \
        --quiet \
        -DrepoUrl="${artifacts_repo_url}" \
        -Dartifact="${group_id}":"${artifact_id}":"${java_version}":"${java_packaging}":bin \
        -DoutputDirectory='.'
}

# Also uses artifacts.alfresco.com but via curl
# This allows access from Travis (for example)
#
# Currently, this function is unused and untested
# artifacts_repo_url is a global.
java::download::artifacts::curl () {
    local group_id="$1"
    local artifact_id="$2"
    local java_version="$3"
    local java_packaging="$4"
    local download_dir="$5"
    
    curl -sfSLO \
        --user "${ARTIFACTS_USER}:${ARTIFACTS_PASSWORD}" \
        "${artifacts_repo_url}/${group_id}/${artifact_id}/${artifact_id}-${java_version}-bin.${java_packaging}"
}

java::download::openjdk::curl () {
    local url="$1"
    # https://download.java.net/java/GA/jdk11/28/GPL/openjdk-11+28_linux-x64_bin.tar.gz
    # https://download.java.net/java/GA/jdk11/28/GPL/openjdk-11+28_linux-x64_bin.tar.gz.sha256
    curl -sfSLO "${url}"
}

# Wrapper
java::download () {
    local java_version="$1"
    local url="$2"
    local java_se_type="$3"
    local java_os_arch="$4"
    local java_packaging="$5"
    local download_dir="$6"

    local -r old_pwd="${PWD}"
    local java_pkg

    cd "${download_dir}" || return

    # If $url is empty - assume using maven
    if [ -z "${url}" ]; then
        java::download::artifacts::mvn \
            "${java_os_arch}" \
            "${java_se_type}" \
            "${java_version}" \
            "${java_packaging}" \
            "${download_dir}"
        java_pkg="${java_se_type}-${java_version}-bin.${java_packaging}"

    else
        # Currently only support OpenJDK
        java::download::openjdk::curl "${url}"
        java_pkg="${url##*/}"
    fi

    cd "${old_pwd}" || return

    echo "${java_pkg}"
}

# sha256 the file
java::checksum () {
    local java_version="$1"
    local url="$2"
    local java_se_type="$3"
    local java_os_arch="$4"
    local java_packaging="$5"
    local jre_filename="$6"

    local checksum
    if [ -z "${url}" ]; then
        checksum="${checksum_256["${group_id}":"${artifact_id}":"${java_version}":"${java_packaging}"]}"
    else
        # Location of the sha256 for OpenJDK
        checksum="$(curl -sS "${url}.sha256")"
    fi

    # Check for coreutils version first
    # Note: two spaces are required between the variables in some implementations
    
    if [ -x "$(command -v sha256sum)" ]; then
        echo "${checksum}  ${jre_filename}" | sha256sum -c - > /dev/null
    elif [ -x "$(command -v gsha256sum)" ]; then
        echo "${checksum}  ${jre_filename}" | gsha256sum -c - > /dev/null
    else
        echo "${checksum}  ${jre_filename}" | shasum -a 256 -c - > /dev/null
    fi
}

# Given 8u181 return 8u181${docker_image_tag_suffix} = 8u181-oracle-centos-7
java::docker::tag::full () {
    local java_version="$1"
    local java_vendor
    java_vendor=$(java::vendor "${java_version}")

    echo "${java_version}-${java_vendor}-${docker_image_tag_suffix}"
}

# Our short names are just the major versions
java::docker::tag::short () {
    local java_version="$1"

    java::version::major "${java_version}"
}

#######################################################################
# Entry points below use an associative array
# This allows named variables but comes at the expense of bash's
# inability to pass associative arrays about.
#
# There was only meant to be one entry point (java::pkg) :rolls-eyes:
#######################################################################

java::docker::tag::full2 () {
    local java_as_str
    java_as_str=$(declare -p "$1")
    # shellcheck disable=SC2086
    eval "declare -A java="${java_as_str#*=}

    # shellcheck disable=SC2154
    java::docker::tag::full "${java[version]}"
}

java::docker::tag::short2 () {
    local java_as_str
    java_as_str=$(declare -p "$1")
    # shellcheck disable=SC2086
    eval "declare -A java="${java_as_str#*=}

    # shellcheck disable=SC2154
    java::docker::tag::short "${java[version]}"
}

# To pass in an associative array ${java_11}, you pass it by name
# java::pkg java_11
java::pkg () {
    # https://stackoverflow.com/a/32536571
    #
    # if $1 is "java_11", this is how you do
    #   java=$java_11 
    # It's obviously a copy (as it gets translated to a string)

    local java_as_str
    java_as_str=$(declare -p "$1")

    #  FIXME - check if you can use local, not declare
    # I've not tested it with the suggested quoting
    # shellcheck disable=SC2086
    eval "declare -A java="${java_as_str#*=}

    local download_dir="$2"

    local java_pkg
    # shellcheck disable=SC2154
    java_pkg=$(java::download \
        "${java[version]}" \
        "${java[url]}" \
        "${java[java_se_type]}" \
        "${java[java_os_arch]}" \
        "${java[java_packaging]}" \
        "${download_dir}" \
    )
    
    # Because of the declare
    unset java

    java::checksum \
        "${java[version]}" \
        "${java[url]}" \
        "${java[java_se_type]}" \
        "${java[java_os_arch]}" \
        "${java[java_packaging]}" \
        "${download_dir}/${java_pkg}"

    echo "${java_pkg}"
}


declare group_id
declare artifact_id
declare java_version
declare java_packaging
declare artifacts_repo_url
declare docker_image_tag_suffix
declare -A checksum_256
declare ARTIFACTS_USER
declare ARTIFACTS_PASSWORD
