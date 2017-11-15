#!/bin/sh
set -o errexit

source build.properties

JRE_FILENAME=`echo "${JRE_URL##*/}"`

curl -jksSLOH "Cookie: oraclelicense=accept-securebackup-cookie" $JRE_URL

if [ -x "$(command -v shasum)" ]; then
  echo "$JRE_CHECKSUM_256  $JRE_FILENAME" | shasum -a 256 -c -
else
  echo "$JRE_CHECKSUM_256  $JRE_FILENAME" | sha256sum -c -
fi
