# Alfresco Docker Base Java

[![Build Status](https://travis-ci.com/Alfresco/alfresco-docker-base-java.svg?branch=master)](https://travis-ci.com/Alfresco/alfresco-docker-base-java)

The images published by this repo are now named as follow:

`<JAVA_DISTRIBUTION_TYPE><JAVA_MAJOR_VERSION>-<OS_DISTRIBUTION_NAME><OS_DISTRIBUTION_VERSION>`

> example jre11-centos7

Previous images used to follow the naming convention bellow:

`<JAVA_VERSION>[-centos-7]`

Where JAVA_VERSION could be many different things (major version, full version, fullversion with digest...)

> Previous tags remain available but we recommend using the new ones

## Introduction

This repository contains the [Dockerfile](Dockerfile) used to create the base Java image that will be used by Alfresco engineering teams,
other internal groups in the organisation, customers and partners to create Java images from.

## Pre-requisites

While any docker CLI compatible installation will produce valid  images, [Docker buildx](https://docs.docker.com/buildx/working-with-buildx/) has proven being more efficient and clever when building images using [Multistage builds](https://docs.docker.com/develop/develop-images/multistage-build/). We recommend using it.

## Versioning

The alfresco-docker-base-java`image can be generated in multiple flavors by mixing OpenJDK versions, distributions and OS.

### Java

Either Java 8 (supported up to 5.2 and 6.0) or Java 11 can used used to build images using the `JAVA_MAJOR` build argument.

> Both OpenJDK versions bellow can be built from the JDK or the JRE distribution (using the JDIST build argument)

#### Legacy OpenJDK Java 8

For legacy Java 8 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches.

#### OpenJDK Java 11 LTS

For Java 11 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches, this is the recommended option.

### OS

The possible combination of OS versions are available:

 * centos 7 
 * ubi 8
 * debian 11
 * ubuntu 20.04

## How to Build

To build a local version of the base java image follow the instructions below:

```bash
docker build -t alfresco-base-java . \
  --build-arg DISTRIB_NAME=$DISTRIB_NAME \
  --build-arg DISTRIB_MAJOR=$DISTRIB_MAJOR \
  --build-arg JAVA_MAJOR=$JAVA_MAJOR \
  --build-arg JDIST=$JDIST \
  --no-cache --target JAVA_BASE_IMAGE
```

#### Release

Push a commit on the default branch including `[release]` in the message to trigger a release on Travis CI.

## Pulling released images

Builds are available from [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java):

```bash
docker pull alfresco/alfresco-base-java:${JDIST}$JAVA_MAJOR
docker pull alfresco/alfresco-base-java:${JDIST}$JAVA_VERSION-$DISTRIB_NAME-$DISTRIB_MAJOR
```

*NOTE*

>  The default image with $JAVA_MAJOR as tag uses CentOS 7 and JDK distribution of OpenJDK

The builds are identical to those stored in the private repo on Quay.

```bash
docker pull quay.io/alfresco/alfresco-base-java:${JDIST}$JAVA_MAJOR
docker pull quay.io/alfresco/alfresco-base-java:${JDIST}$JAVA_VERSION-$DISTRIB_NAME-$DISTRIB_MAJOR
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
FROM alfresco/alfresco-base-java:jre11-ubi-8
```

Example from a Dockerfile using a private base pinned image in Quay:

```bash
FROM quay.io/alfresco/alfresco-base-java:jre11-centos-7@sha256:$SHA256
```
where `SHA256` is the full sha256 image digest.

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile) for a concrete example.
