# Alfresco Docker Base Java [![Build Status](https://img.shields.io/github/workflow/status/Alfresco/alfresco-docker-base-java/Alfresco%20java%20base%20Docker%20image)](https://github.com/Alfresco/alfresco-docker-base-tomcat/actions/workflows/main.yml)

This repository contains the [Dockerfile](Dockerfile) used to create the base
Java image that will be used by Alfresco engineering teams, other internal
groups in the organization, customers and partners to create Java images from.

## Quickstart

Choose between one of the available flavours built from this repository:

Java version | Java flavour | OS          | Image tag        | Size
-------------|--------------|-------------|------------------|-------------------------
11           | jre          | Centos 7    | jre11-centos7    | ![jre11-centos7 size][1]
11           | jdk          | Centos 7    | jdk11-centos7    | ![jdk11-centos7 size][2]
11           | jre          | Alpine 3.15 | jre11-alpine3.15 | ![jre11-alpine3.15][3]
11           | jre          | UBI 8       | jre11-ubi8       | ![jre11-ubi8 size][4]

[1]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre11-centos7
[2]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jdk11-centos7
[3]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre11-alpine3.15
[4]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre11-ubi8

* [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java) image name: `alfresco/alfresco-base-java`
* [Quay](https://quay.io/repository/alfresco/alfresco-base-java) image name: `quay.io/alfresco/alfresco-base-java`

Example final image: `alfresco/alfresco-base-java:jre11-centos7`

> If you are using this base image in a public repository, please stick to the DockerHub published image.

### Image pinning

These tags get overwritten to always have an up-to-date image and hopefully
without security issues.

If you want to control the updating process of the image, you can use the digest
in addition to the tag in your `Dockerfile`, for example:

```dockerfile
FROM alfresco/alfresco-base-java:jre11-centos7@sha256:59a453e01fd958a3748a2e9b0ca99cdf3410f98eeb245499c7bb31696e35bdf4
```

To discover the latest image tag, just run a docker pull and copy the `Digest`.

```sh
docker pull quay.io/alfresco/alfresco-base-java:jre11-centos7
# jre11-centos7: Pulling from alfresco/alfresco-base-java
# ...
# Digest: sha256:59a453e01fd958a3748a2e9b0ca99cdf3410f98eeb245499c7bb31696e35bdf4
# Status: Downloaded newer image for quay.io/alfresco/alfresco-base-java:jre11-centos7
```

This configuration is compatible with [Dependabot](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#configuration-options-for-private-registries).

## Development

### Naming specs

The images built from this repository are named as follow:

`<JAVA_DISTRIBUTION_TYPE><JAVA_MAJOR_VERSION>-<OS_DISTRIBUTION_NAME><OS_DISTRIBUTION_VERSION>`

Previous versions of this repository built images using the naming convention:

`<JAVA_VERSION>[-centos-7]`

Where JAVA_VERSION could be many different things (major version, full version, full version with digest...)

> Previous tags are still available but are not getting updates anymore

### Prerequisites

While any docker CLI compatible installation will produce valid images,
[Docker buildx](https://docs.docker.com/buildx/working-with-buildx/) has proven being
more efficient and clever when building images using
[Multistage builds](https://docs.docker.com/develop/develop-images/multistage-build/).
We recommend using it.

### Versioning

The `alfresco-docker-base-java` image can be generated in multiple flavors by mixing OpenJDK versions, distributions and OS.

#### Java

Either Java 8 (supported up to 5.2 and 6.0) or Java 11 can used used to build images using the `JAVA_MAJOR` build argument.

> Both OpenJDK versions bellow can be built from the JDK or the JRE distribution (using the JDIST build argument)

##### Legacy OpenJDK Java 8

For legacy Java 8 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches.

##### OpenJDK Java 11 LTS

For Java 11 builds, using the OpenJDK version from the CentOS distro which includes the latest security patches, this is the recommended option.

#### OS

The possible combination of OS versions are available:

* centos 7
* ubi 8
* debian 11
* ubuntu 20.04

### How to build an image locally

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

## Useful information

Images built from this repository are more likely to be used as a
[base image](https://docs.docker.com/glossary/#base-image) in a Dockerfile.

For reference, see the documentation on [layers](https://docs.docker.com/storage/storagedriver/#container-and-layers),
the [VOLUME](https://docs.docker.com/engine/reference/builder/#volume) instruction
and [best practices with Volumes](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#volume).

### Who is using this base image

See [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile)
for a concrete example.
