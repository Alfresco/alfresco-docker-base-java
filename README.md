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

## How to Build

### Manually

To build a local version of the base java image follow the instructions below

#### Download JDK

Download any `tar.gz` of the jdk into [.](.).
Save the filename in a variable. e.g.

```bash
export JAVA_PKG="OpenJDK11U-jdk_x64_linux_11.0.10_9.tar.gz"
```

#### Build the docker image

Assuming the filename has been saved in the variable `$JAVA_PKG`, build as follows:

```bash
(cd centos-$CENTOS_MAJOR && docker build -t centos-$CENTOS_MAJOR .)
docker build -t alfresco-base-java . \
  --build-arg CENTOS_MAJOR=$CENTOS_MAJOR \
  --build-arg JAVA_PKG=$JAVA_PKG \
  --no-cache
```

where:
* CENTOS_MAJOR is 7 or 8

#### Release

Just push a commit on the default branch including `[release]` in the message to trigger a release on Travis CI.

## Pulling released images

Builds are available from [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java):

```bash
docker pull alfresco/alfresco-base-java:$JAVA_MAJOR
docker pull alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR
docker pull alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR-$SHORT_SHA256
```

where:
* JAVA_MAJOR is 8 or 11
* JAVA_VERSION is 8u202 or 11.0.10
* JAVA_VENDOR is `oracle` for 8 and `openjdk` for 11
* CENTOS_MAJOR is 7 or 8
* SHORT_SHA256 is the 12 digit SHA256 of the image as available from the registry

*NOTE*
The default image with $JAVA_MAJOR as tag uses CentOS 8.

The builds are identical to those stored in the private repo on Quay.

```bash
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_MAJOR
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_VERSION-$JAVA_VENDOR-centos-$CENTOS_MAJOR-$SHORT_SHA256
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
FROM quay.io/alfresco/alfresco-base-java:11.0.10-openjdk-centos-7-$SHORT_SHA256
```
where `SHORT_SHA256` is the 12-digit short sha256 image digest.

or pinned:

```bash
FROM quay.io/alfresco/alfresco-base-java:11.0.10-openjdk-centos-7@sha256:$SHA256
```
where `SHA256` is the full sha256 image digest.

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile) for a concrete example.
