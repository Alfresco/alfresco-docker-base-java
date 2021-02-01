# Alfresco Docker Base Java

[![Build Status](https://travis-ci.com/Alfresco/alfresco-docker-base-java.svg?branch=master)](https://travis-ci.com/Alfresco/alfresco-docker-base-java)

## Introduction

This repository contains the [Dockerfile](Dockerfile) used to create the parent Java image that
will be used by Alfresco engineering teams, other internal groups in the
organisation, customers and partners to create images as part of the Alfresco
Digital Business Platform.

The architectural decision record can be found [![here](https://img.shields.io/badge/Anaxes%20ADR%205--green.svg?longCache=true&style=plastic)](https://github.com/Alfresco/alfresco-anaxes-shipyard/blob/master/docs/adrs/0005-base-java-docker-image-composition.md).

## Versioning

### Legacy Oracle Java 8

For legacy Oracle Java 8 builds, the serverjre has been saved in Alfresco's artifact repository, last version is 8u181.

### OpenJDK Java 11

For OpenJDK builds from Java 11, the binary is downloaded from [AdoptOpenJDK](https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries).

Build-pinning is available on Quay and Docker Hub to ensure an exact build artifact is used.

## How to Build

### Manually

To build a local version of the base java image follow the instructions below

#### Download JDK

Download any `tar.gz` of the serverjre or jdk into [.](.). Save the filename in
a variable. e.g.

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
docker pull alfresco/alfresco-base-java:8
docker pull alfresco/alfresco-base-java:8u161-oracle-centos-7
docker pull alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```

The builds are identical to those stored in the private repo on Quay,
(which also supports build-pinning versions).

```bash
docker pull quay.io/alfresco/alfresco-base-java:8
docker pull quay.io/alfresco/alfresco-base-java:8u161-oracle-centos-7
docker pull quay.io/alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```

## Usage

### Standalone

The image can be used via `docker run` to run java applications
with `--read-only` set, without any loss of functionality (with the
obvious caveat that the application itself does not write to the filesystem).

### Base Image

It is more likely to be used as a [base image](https://docs.docker.com/glossary/?term=parent%20image#base-image) in a Dockerfile.
For reference, see the documentation on [layers](https://docs.docker.com/storage/storagedriver/#container-and-layers),
the [VOLUME](https://docs.docker.com/engine/reference/builder/#volume)
instruction, and [best practices with VOLUMEs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#volume).

### Examples of usage as a parent image

Example from a Dockerfile using a public, parent image in Docker Hub.

```bash
FROM alfresco/alfresco-base-java:8
```

Example from a Dockerfile using a private, parent image in Quay:

```bash
FROM quay.io/alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile) for a concrete example.
