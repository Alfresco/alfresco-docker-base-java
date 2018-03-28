<!-- markdownlint-disable MD013 MD041 -->
[![Docker Repository on Quay](https://quay.io/repository/alfresco/alfresco-base-java/status?token=7b035610-24b5-4ed7-a95f-6e812628cd8e "Docker Repository on Quay")](https://quay.io/repository/alfresco/alfresco-base-java)

# Welcome to Alfresco Docker Base Java

## Introduction

This repository contains the Dockerfile to create the base Java image that
will be used by Alfresco engineering teams, other internal groups in the
organisation, customers and partners to create images as part of the Alfresco
Digital Business Platform.

The architectural decision record can be found [![here](https://img.shields.io/badge/Anaxes%20ADR%205--green.svg?longCache=true&style=plastic)](https://github.com/Alfresco/alfresco-anaxes-shipyard/blob/master/docs/adrs/0005-base-java-docker-image-composition.md).

## Versioning

Currently any pull request to this project should ensure that `DOCKER_IMAGE_TAG`,
`DOCKER_IMAGE_TAG_SHORT_NAME` are set with the relevant values in `build.properties`.
New versions of Java should have their sha256 checksum added as `JRE_CHECKSUM_256_<version>`,
where this name matches the artifact stored on `artifacts.alfresco.com`.

Build-pinning is available on quay to ensure an exact build artifact is used.

## How to Build

To build a local version of the base java image follow the instructions below

1. Prepare the docker build environment. This will get the appropriate version of the Oracle Java Server JRE. Run the following script

```bash
./build-prep.sh
```

<!-- markdownlint-disable MD029 -->
2. Build the docker image
<!-- markdownlint-enable MD029 -->

```bash
docker build -t alfresco/alfresco-base-java .
```

## Pulling released images

Builds are available publically from
[Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java)

```bash
docker pull alfresco/alfresco-base-java:8
docker pull alfresco/alfresco-base-java:8u161-oracle-centos-7
```

The builds are identical to those stored in the private repo on Quay,
(which also supports build-pinning versions).

```bash
docker pull alfresco/alfresco-base-java:8
docker pull alfresco/alfresco-base-java:8u161-oracle-centos-7
docker pull alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```

## Usage

### Standalone

The image can be used via `docker run` to run java applications
with `--read-only` set, without any loss of functionality (with the
obvious caveat that the application itself does not write to the filesystem).

### Parent Image

It is more likely to be used as a
[parent image](https://docs.docker.com/glossary/?term=parent%20image)
in a Dockerfile.
For reference, see the documentation on
[layers](https://docs.docker.com/storage/storagedriver/#container-and-layers),
the
[VOLUME](https://docs.docker.com/engine/reference/builder/#volume)
instruction, and
[best practices with VOLUMEs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#volume).

### Examples of usage as a parent image

Example from a Dockerfile using a public, parent image in Docker Hub.

```bash
FROM alfresco/alfresco-base-java:8
```

Example from a Dockerfile using a private, parent image in Quay:

```bash
FROM quay.io/alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile)
for a concrete example.