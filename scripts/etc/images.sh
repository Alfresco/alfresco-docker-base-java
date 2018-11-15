#!/bin/bash

########################################################################
# Docker Image
########################################################################

# shellcheck disable=SC2034,SC2148

export docker_image_tag_suffix='centos-7'
export docker_image_repository'=alfresco-base-java'


# Legacy
#
# Version is also version in maven
#
# java_os_arch:
# One of linux-x64, windows-x64, linux-arm32, linux-arm64
# Only tested with linux-x64.
# Group ID in maven
#
# java_se_type:
# serverjre, jre or jdk.
# Artifact ID in maven
#
# java_packaging:
# One of tar.gz, rpm, exe
# Only tested with tar.gz.
export -A java_8=(
  [version]=8u181
  [java_os_arch]='linux-x64'
  [java_se_type]='serverjre'
  [java_packaging]='tar.gz'
)

# FCS of Java 11 is called 11, as trailing '.0's are dropped
# See https://docs.oracle.com/en/java/javase/11/install/version-string-format.html
export -A java_11=(
  [version]=11.0.1
  [url]=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
)

