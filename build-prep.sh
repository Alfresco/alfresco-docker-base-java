#!/bin/bash

set -o errexit

# shellcheck source=./build.properties
source ./build.properties

declare -r DOWNLOAD_DIR=src/

# Get Java release from Docker tag
JAVA_VERSION="${DOCKER_IMAGE_TAG%%-[![:digit:]]*}"

# Remove periods, and replace remaining non-alphanumerics with underscores
JAVA_VERSION_CLEANED=$(echo "${JAVA_VERSION}" | sed -e 's/\.//g' -e 's%[^[:alnum:]]%_%g')
# bash 3.2 compatible alternative to associative arrays
JRE_CHECKSUM_256_REF="JRE_CHECKSUM_256_${JAVA_VERSION_CLEANED}"

if [ "${USE_MVN}" = 'true' ]; then

    # As Oracle have made downloading non-current versions of Java difficult,
    # we are sadly having to store them in an internal repository.

    # Use Maven 3
    unset M2_HOME
    export M3_HOME=/opt/apache-maven

    "${M3_HOME}"/bin/mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.2:copy \
        --quiet \
        -DrepoUrl=https://artifacts.alfresco.com/nexus/content/repositories/oracle-java \
        -Dartifact="${JAVA_OS_ARCH}":"${JAVA_SE_TYPE}":"${JAVA_VERSION}":"${JAVA_PACKAGING}":bin \
        -DoutputDirectory="${DOWNLOAD_DIR}"

    # Our filenames are munged into Maven compatible names
    JRE_FILENAME="${DOWNLOAD_DIR}/${JAVA_SE_TYPE}"-"${JAVA_VERSION}"-bin."${JAVA_PACKAGING}"
else
    # You can still download the latest Java version from Oracle

    declare OLD_PWD="${PWD}"
    cd "${DOWNLOAD_DIR}"
    curl -jksSLOH "Cookie: oraclelicense=accept-securebackup-cookie" "${JRE_URL}"
    cd "${OLD_PWD}"

    JRE_FILENAME="${DOWNLOAD_DIR}/${JRE_URL##*/}"
fi

# Check for coreutils version first
# Note: two spaces are required between the variables in some implementations

if [ -x "$(command -v sha256sum)" ]; then
    echo "${!JRE_CHECKSUM_256_REF}  ${JRE_FILENAME}" | sha256sum -c -
elif [ -x "$(command -v gsha256sum)" ]; then
    echo "${!JRE_CHECKSUM_256_REF}  ${JRE_FILENAME}" | gsha256sum -c -
else
    echo "${!JRE_CHECKSUM_256_REF}  ${JRE_FILENAME}" | shasum -a 256 -c -
fi
