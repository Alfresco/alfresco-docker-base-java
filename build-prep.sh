#!/bin/sh

set -o errexit

. ./build.properties

# If you want the current release

if [ "${USE_MVN}" = 'true' ]; then

    # As Oracle have made downloading non-current versions of Java difficult,
    # we are sadly having to store them in an internal repository.

    unset M2_HOME
    export M3_HOME=/opt/apache-maven

    "${M3_HOME}"/bin/mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.2:copy \
        -DrepoUrl=https://artifacts.alfresco.com/nexus/content/repositories/oracle-java \
        -Dartifact="${JAVA_OS_ARCH}":"${JAVA_SE_TYPE}":"${JAVA_VERSION}":"${JAVA_PACKAGING}":bin \
        -DoutputDirectory=.

    JRE_FILENAME="${JAVA_SE_TYPE}"-"${JAVA_VERSION}"-bin."${JAVA_PACKAGING}"
else
    JRE_FILENAME=`echo "${JRE_URL##*/}"`

    curl -jksSLOH "Cookie: oraclelicense=accept-securebackup-cookie" $JRE_URL
fi

if [ -x "$(command -v shasum)" ]; then
  echo "$JRE_CHECKSUM_256  $JRE_FILENAME" | shasum -a 256 -c -
else
  echo "$JRE_CHECKSUM_256  $JRE_FILENAME" | sha256sum -c -
fi
