#!/bin/bash

# Script to upload serverjre to Nexus
# By the magic of maven the file will be called serverjre-<version>-bin.tar.gz

declare -r GROUP_ID='linux-x64'
declare -r ARTIFACT_ID='serverjre'
declare -r GENERATE_POM='true'
declare -r CLASSIFIER='bin'
declare -r REPOSITORY_ID='alfresco-internal'
declare -r TYPE='tar.gz'
declare -r PACKAGING='tar.gz'
declare -r URL='https://artifacts.alfresco.com/nexus/content/repositories/oracle-java/'

declare VERSION="$1"
declare FILE="$2"

if [ $# -ne 2 ]; then
  echo "Pass a version (e.g. 8u181, or 11.0.2) and the name of the downloaded file" >> /dev/stderr
  echo "e.g. ./hack/uploader.sh 8u181 ~/Downloads/server-jre-8u181-linux-x64.tar.gz" >> /dev/stderr
  exit 1
fi

if [ ! -f "${FILE}" ]; then
  echo "File: ${FILE} does not exist" >> /dev/stderr
  exit 1
fi

# Used for uploading Java to Nexus
mvn deploy:deploy-file \
  -DgroupId="${GROUP_ID}" \
  -DartifactId="${ARTIFACT_ID}" \
  -Dversion="${VERSION}" \
  -DgeneratePom="${GENERATE_POM}" \
  -Dclassifier="${CLASSIFIER}" \
  -Dtype="${TYPE}" \
  -Dpackaging="${PACKAGING}" \
  -DrepositoryId="${REPOSITORY_ID}" \
  -Durl="${URL}" \
  -Dfile="${FILE}"