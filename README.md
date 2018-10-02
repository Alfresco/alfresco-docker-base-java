<!-- markdownlint-disable MD013 MD041 -->
[![Docker Repository on Quay](https://quay.io/repository/alfresco/alfresco-base-java/status?token=7b035610-24b5-4ed7-a95f-6e812628cd8e "Docker Repository on Quay")](https://quay.io/repository/alfresco/alfresco-base-java)

# Welcome to Alfresco Docker Base Java

## Introduction

This repository contains the [Dockerfile](src/Dockerfile) used to create the parent Java image that
will be used by Alfresco engineering teams, other internal groups in the
organisation, customers and partners to create images as part of the Alfresco
Digital Business Platform.

The architectural decision record can be found [![here](https://img.shields.io/badge/Anaxes%20ADR%205--green.svg?longCache=true&style=plastic)](https://github.com/Alfresco/alfresco-anaxes-shipyard/blob/master/docs/adrs/0005-base-java-docker-image-composition.md).

## Versioning

`DOCKER_IMAGE_TAG` and `DOCKER_IMAGE_TAG_SHORT_NAME` are now calculated from the configuration in
[etc/images.sh](etc/images.sh).

Associative arrays called `java_n` are defined for each *major* Java version (ie. 8, 11, 14).

### Legacy Oracle Java 8

For legacy Oracle Java 8
builds where the serverjre has been saved in Alfresco's artifact repository, a configuration is
needed as follows. It is not expected that anything other than `${java_8[version]}` would need changing.

_(The keys `java_os_arch`, `java_se_type`, `version`, and `java_packaging` map to `groupId`, `artifactId`,
`version`, and `packaging` in maven, respectively.)_

```bash
export -A java_8=(
  [version]=8u181
  [java_os_arch]='linux-x64'
  [java_se_type]='serverjre'
  [java_packaging]='tar.gz'
)
```

The checksum will also need adding into the associative array in [etc/checksum.sh](etc/checksum.sh).

### OpenJDK Java 11 onwards

For OpenJDK builds from Java 11 onwards, the configuration looks like:

```bash
export -A java_11=(
  [version]=11
  [url]=https://download.java.net/java/GA/jdk11/28/GPL/openjdk-11+28_linux-x64_bin.tar.gz
)
```

The `${java_n[version]}` field is currently `11` as 
[trailing '.0's are dropped](https://docs.oracle.com/en/java/javase/11/install/version-string-format.html)
in Java's new numbering system.

When a `11.0.1` or other release comes out, `${java_11[version]}` should be set to that.

The URL is the one found on [jdk.java.net](http://jdk.java.net/11/). The sha256 is assumed to live at this URL
with `.sha256` appended.

Build-pinning is available on Quay and Docker Hub to ensure an exact build artifact is used.

## How to Build

### Manually

To build a local version of the base java image follow the instructions below

#### Download JDK

Download any `tar.gz` of the serverjre or jdk into [src](src). Save the filename in
a variable. e.g.

```bash
export java_filename='jdk-11_linux-x64_bin.tar.gz'
```

#### Build the docker image

Assuming the filename has been saved in the variable `$java_filename`, build as follows

```bash
docker build --build-arg JAVA_PKG="${java_filename}" -t alfresco/alfresco-base-java src
```

### Scripts

There are two scripts, one to build, and one to release that are simple "for loop" wrapper around the standard Alfresco tools.
They assume that these have been pulled into `./docker-tools` at build time.

#### Build

[bin/build.sh](bin/build.sh) requires the following environment variables:

* `registry` _(mandatory)_: The hostname (and optional port) of your private registry. e.g. `quay.io`. Note: this is available in bamboo by setting `registry=${bamboo.docker.registry.address}`.
* `namespace` _(mandatory)_: The namespace you use in your private registry. e.g. `alfresco`. Note: this is available in bamboo by setting `namespace=${bamboo.docker.registry.namespace}`.
* `java_versions` _(mandatory)_: Comma separated list of *major* versions. e.g. `8,11`. For each of these (`n`), there must be a corresponding `${java_n}` associative array in [etc/images.sh](etc/images.sh).
* `suffix` _(optional, but usual)_: this is passed to bamboo-build-docker-repo-tools as its `suffix` variable. It is appended to the docker tag, and is typically something of the form `DEPLOY-574` or `SNAPSHOT`. e.g. `suffix=${bamboo.planRepository.branchName}`.

#### Release

[bin/release.sh](bin/release.sh) requires the same variables, with the exception of `suffix`.

## Pulling released images

Builds are available from
[Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java)

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