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

```bash
docker run \
  -it \
  --rm \
  --read-only \
  --mount type=tmpfs,destination=/tmp,tmpfs-mode=01777 \
  alfresco/alfresco-base-java:8 \
  java \
    -XX:ErrorFile=/tmp/hs_err_%p.log \
    <command-line-arguments>
```

Or, more likely, use it as a base image in a Dockerfile, using a valid tag
in Docker Hub or Quay, like the following. See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile)
for a concrete example.

```bash
FROM alfresco/alfresco-base-java:8
```

```bash
FROM quay.io/alfresco/alfresco-base-java:8u161-oracle-centos-7-333472fed423
```