#!/bin/sh

set -o errexit

. ./build.properties

# Get Java release from Docker tag
JAVA_VERSION="${DOCKER_IMAGE_TAG%%-*}"

# bash 3.2 compatible alternative to associative arrays
JAVA_VERSION_NO_DOTS=$(echo $JAVA_VERSION | sed -e 's/\.//g')
JRE_CHECKSUM_256_REF="JRE_CHECKSUM_256_${JAVA_VERSION_NO_DOTS}"

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
        -DoutputDirectory=.

    # Our filenames are munged into Maven compatible names
    JRE_FILENAME="${JAVA_SE_TYPE}"-"${JAVA_VERSION}"-bin."${JAVA_PACKAGING}"
else

    # You can still download the latest Java version from Oracle

    curl -jksSLOH "Cookie: oraclelicense=accept-securebackup-cookie" "${JRE_URL}"

    JRE_FILENAME="${JRE_URL##*/}"
fi

# Checksum
# Check for coreutils version first
if [ -x "$(command -v sha256sum)" ]; then
    echo "${!JRE_CHECKSUM_256_REF} ${JRE_FILENAME}" | sha256sum -c -
elif [ -x "$(command -v gsha256sum)" ]; then
    echo "${!JRE_CHECKSUM_256_REF} ${JRE_FILENAME}" | gsha256sum -c -
else
    # Note: two spaces are required between the variables in perl's shasum
    echo "${!JRE_CHECKSUM_256_REF}  ${JRE_FILENAME}" | shasum -a 256 -c -
fi
