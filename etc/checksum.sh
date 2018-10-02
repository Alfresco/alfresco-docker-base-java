#!/bin/bash

# Oracle only
# Over-engineered

export -A checksum_256=( 
  [linux-x64:serverjre:8u161:tar.gz]='eb5776cacfd57fbf0ffb907f68c58a1cc6f823e761f4e75d78a6e3240846534e'
  [linux-x64:serverjre:8u181:tar.gz]='678e798008c398be98ba9d39d5114a9b4151f9d3023ccdce8b56f94c5d450698'
  [linux-x64:serverjre:901]='ecf9ad38803d643eeb8a5321de6aa99e8ceda2d40b27a9f49c42012f8d9e3eae'
  [linux-x64:serverjre:904]='d29b6b3008c814abd8ab5e4bde9278d6ee7699898333992ee8d080612b5197ca'
  [linux-x64:serverjre:10_2018_03_20]='1c725b8a4e45009a2a21bad10ec5dab17bb8803fb90cea2d682a89edc6783e4e'
  [linux-x64:jdk:11_2018_09_25]='246a0eba4927bf30180c573b73d55fc10e226c05b3236528c3a721dff3b50d32'
)

# OpenJDK builds have their SHA256 available at their download url appended with .256
# e.g.
# https://download.java.net/java/GA/jdk11/28/GPL/openjdk-11+28_linux-x64_bin.tar.gz.sha256
