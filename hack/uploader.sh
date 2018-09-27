#!/bin/bash

# Script to upload serverjre to Nexus
# By the magic of maven the file will be called serverjre-<version>-bin.tar.gz
#
# ./uploader.sh 8u181 ~/Downloads/serverjre-8u181-linux-x64.tar.gz
# 
# Or for a jdk:
#
# ARTIFACT_ID=jdk ./uploader.sh 11_2018_09_25 ~/Downloads/jdk-11_linux-x64_bin.tar.gz

: "${GROUP_ID:=linux-x64}"
: "${ARTIFACT_ID:=serverjre}"
: "${GENERATE_POM:=true}"
: "${CLASSIFIER:=bin}"
: "${REPOSITORY_ID:=alfresco-internal}"
: "${TYPE:=tar.gz}"
: "${PACKAGING:=tar.gz}"
: "${URL:=https://artifacts.alfresco.com/nexus/content/repositories/oracle-java/}"

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

echo "Uploading ${FILE} to nexus..." >> /dev/stderr
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

declare VERSION_MUNGED
VERSION_MUNGED=$(echo ${VERSION} | tr . -)
echo "Attempting to get sha256..." >> /dev/stderr
curl -sS "https://www.oracle.com/webfolder/s/digest/${VERSION_MUNGED}checksum.html" | \
  grep "serverjre-${VERSION}_linux-x64_bin.tar.gz" | \
  cut -f 2 -d : | \
  cut -f 1 -d'<' | \
  awk '{print $1}'
    