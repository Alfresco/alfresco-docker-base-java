# Alfresco Docker Base Java

[![Build Status](https://travis-ci.com/Alfresco/alfresco-docker-base-java.svg?branch=master)](https://travis-ci.com/Alfresco/alfresco-docker-base-java)

## Introduction

This repository contains the [Dockerfile](Dockerfile) used to create the base Java image that will be used by Alfresco engineering teams,
other internal groups in the organisation, customers and partners to create Java images from.

## Versioning

### Legacy OpenJDK Java 8

For legacy Java 8 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches.

### OpenJDK Java 11 LTS

For Java 11 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches, this is the recommended option.

Options are available using CentOS 7 and Debian 10 as base.

## How to Build

To build a local version of the base java image follow the instructions below:

```bash
(cd $DISTRIB_NAME-$DISTRIB_MAJOR && docker build -t $DISTRIB_NAME-$DISTRIB_MAJOR .)
docker build -t alfresco-base-java . \
  --build-arg DISTRIB_NAME=$DISTRIB_NAME \
  --build-arg DISTRIB_MAJOR=$DISTRIB_MAJOR \
  --build-arg JAVA_MAJOR=$JAVA_MAJOR \
  --no-cache
```

where:
* DISTRIB_NAME is centos, debian or ubuntu
* DISTRIB_MAJOR is 7 for centos, 11 for debian and 20.04 for ubuntu
* JAVA_MAJOR is 8 or 11

#### Release

Push a commit on the default branch including `[release]` in the message to trigger a release on Travis CI.

## Pulling released images

Builds are available from [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java):

```bash
docker pull alfresco/alfresco-base-java:$JAVA_MAJOR
docker pull alfresco/alfresco-base-java:$JAVA_MAJOR-$DISTRIB_NAME-$DISTRIB_MAJOR
docker pull alfresco/alfresco-base-java:$JAVA_MAJOR-$DISTRIB_NAME-$DISTRIB_MAJOR-$SHORT_SHA256
```

where:
* JAVA_MAJOR is 8 or 11
* DISTRIB_MAJOR is 7 or 8
* SHORT_SHA256 is the 12 digit SHA256 of the image as available from the registry

*NOTE*
The default image with $JAVA_MAJOR as tag uses CentOS 7.

The builds are identical to those stored in the private repo on Quay.

```bash
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_MAJOR
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_MAJOR-$DISTRIB_NAME-$DISTRIB_MAJOR
docker pull quay.io/alfresco/alfresco-base-java:$JAVA_MAJOR-$DISTRIB_NAME-$DISTRIB_MAJOR-$SHORT_SHA256
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
FROM quay.io/alfresco/alfresco-base-java:11-centos-7-$SHORT_SHA256
```
where `SHORT_SHA256` is the 12-digit short sha256 image digest.

or pinned:

```bash
FROM quay.io/alfresco/alfresco-base-java:11-centos-7@sha256:$SHA256
```
where `SHA256` is the full sha256 image digest.

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile) for a concrete example.
