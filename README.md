# Alfresco Docker Base Java

[![Build Status](https://travis-ci.com/Alfresco/alfresco-docker-base-java.svg?branch=master)](https://travis-ci.com/Alfresco/alfresco-docker-base-java)

## Introduction

This repository contains the [Dockerfile](Dockerfile) used to create the base Java image that will be used by Alfresco engineering teams,
other internal groups in the organisation, customers and partners to create Java images from.

## Versioning

### Legacy Oracle Java 8

For legacy Oracle Java 8 builds, version 8u202 of the serverjre has been saved in Alfresco artifact repository,
which is the last one available with the BCL license.

### OpenJDK Java 11

For OpenJDK builds from Java 11.0.10, the most updated binary is downloaded from [AdoptOpenJDK](https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries).

Options are available using CentOS 7 and 8 as base.

Build-pinning is available on Quay and Docker Hub to ensure an exact build artifact is used.

## How to Build

### Manually

To build a local version of the base java image follow the instructions below

#### Download JDK

Download any `tar.gz` of the jdk into [.](.).
Save the filename in a variable. e.g.

```bash
export java_filename='jdk-11_linux-x64_bin.tar.gz'
```

#### Build the docker image

Assuming the filename has been saved in the variable `$java_filename`, build as follows

```bash
docker build --build-arg JAVA_PKG="${java_filename}" -t alfresco/alfresco-base-java .
```

#### Release

Just push a commit on the default branch including `'[release]` in the message to trigger a release on Travis CI.

## Pulling released images

Builds are available from [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java):

```bash
docker pull alfresco/alfresco-base-java:$JAVA_MAJOR_VERSION
docker pull alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR_VERSION
docker pull alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR_VERSION-$SHORT_SHA256
```

where:
* JAVA_MAJOR_VERSION is 8 or 11
* JAVA_VERSION is 8u202 or 11.0.10
* JAVA_VENDOR is `oracle` for 8 and `openjdk` for 11
* CENTOS_MAJOR_VERSION is 7 or 8
* SHORT_SHA256 is the 12 digit SHA256 of the image as available from the registry

The builds are identical to those stored in the private repo on Quay, which also supports build-pinning versions.

```bash
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_MAJOR_VERSION
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR_VERSION
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR_VERSION-$SHORT_SHA256
```

## Usage

### Standalone

The image can be used via `docker run` to run java applications with `--read-only` set,
without any loss of functionality (with the obvious caveat that the application itself does not write to the filesystem).

### Base Image

It is more likely to be used as a [base image](https://docs.docker.com/glossary/#base-image) in a Dockerfile.
For reference, see the documentation on [layers](https://docs.docker.com/storage/storagedriver/#container-and-layers),
the [VOLUME](https://docs.docker.com/engine/reference/builder/#volume)
instruction, and [best practices with VOLUMEs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#volume).

### Examples of usage as a base image

Example from a Dockerfile using a public base image in Docker Hub.

```bash
FROM alfresco/alfresco-base-java:11
```

Example from a Dockerfile using a private base image in Quay:

```bash
FROM quay.io/alfresco/alfresco-base-java:11.0.10-oracle-centos-7-fc1ad2925112
```

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile) for a concrete example.
