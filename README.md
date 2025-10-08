# Alfresco Docker Base Java [![Build Status](https://img.shields.io/github/actions/workflow/status/Alfresco/alfresco-docker-base-java/main.yml?branch=master)](https://github.com/Alfresco/alfresco-docker-base-java/actions/workflows/main.yml) ![Docker Hub Pulls](https://img.shields.io/docker/pulls/alfresco/alfresco-base-java)

This repository provides the base Docker images for Java LTS versions
Rocky Linux 8 and 9 that are meant to be used within the Alfresco engineering to
build Docker images for Java applications.

## Flavours

Choose between one of the available flavours built from this repository:

Java version | Java flavour | OS            | Image ref                                       | Size
-------------|--------------|---------------|-------------------------------------------------|-----------------------------
17           | jre          | Rocky Linux 8 | `alfresco/alfresco-base-java:jre17-rockylinux8` | ![jre17-rockylinux8 size][1]
11           | jre          | Rocky Linux 8 | `alfresco/alfresco-base-java:jre11-rockylinux8` | ![jre11-rockylinux8 size][2]
17           | jre          | Rocky Linux 9 | `alfresco/alfresco-base-java:jre17-rockylinux9` | ![jre17-rockylinux9 size][3]
21           | jre          | Rocky Linux 9 | `alfresco/alfresco-base-java:jre21-rockylinux9` | ![jre21-rockylinux9 size][4]
25           | jre          | Rocky Linux 9 | `alfresco/alfresco-base-java:jre25-rockylinux9` | ![jre25-rockylinux9 size][5]

[1]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre17-rockylinux8
[2]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre11-rockylinux8
[3]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre17-rockylinux9
[4]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre21-rockylinux9
[5]: https://img.shields.io/docker/image-size/alfresco/alfresco-base-java/jre25-rockylinux9

The images are available on:

* [Docker Hub](https://hub.docker.com/r/alfresco/alfresco-base-java), image name: `alfresco/alfresco-base-java`
* [Quay](https://quay.io/repository/alfresco/alfresco-base-java) (enterprise credentials required), image name: `quay.io/alfresco/alfresco-base-java`

### Image pinning

To ensure the propagation of security fixes from upstream projects, all
supported tags are mutable and undergo periodic rebuilding.

#### Pin by digest

The suggested approach is to pin the sha256 digest for best reproducibility in
your `Dockerfile`, for example:

```dockerfile
FROM alfresco/alfresco-base-java:jre17-rockylinux9@sha256:b749868ceb42bd6f58ae2f143e8c16af4752fad7b40eb1085c014cbfcecb1ffc
```

To discover the latest image digest, just run `docker pull <image-ref>` and then
run `docker images --digests`.

```sh
$ docker pull alfresco/alfresco-base-java:jre17-rockylinux9
489e1be6ce56: Already exists
66defdfd2e26: Download complete
41c3b80bc03b: Download complete
be4e433e73b5: Download complete
docker.io/alfresco/alfresco-base-java:jre17-rockylinux9

$ docker images --digests
REPOSITORY                    TAG                 DIGEST                                                                    IMAGE ID       CREATED          SIZE
alfresco/alfresco-base-java   jre17-rockylinux9   sha256:b749868ceb42bd6f58ae2f143e8c16af4752fad7b40eb1085c014cbfcecb1ffc   be4e433e73b5   14 minutes ago   410MB
```

This configuration approach is compatible with [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#docker).

#### Pin by immutable tags

Additional tags are being pushed for master releases, following the pattern
`$tag-YYMMDDHHMM`. Those tags are never overwritten and can be used as a more
intuitive approach. You can still use it in combination with digest for
increased security.

> Quay.io doesn't retain previous images when a tag is overwritten, so using an
> immutable tag is mandatory in order to avoid getting `Manifest not found`
> error once a mutable tag get updated.

## Development

While any docker installation will produce valid images, building with
[BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/)
has proven being more efficient and clever with [Multistage
builds](https://docs.docker.com/develop/develop-images/multistage-build/). If
you are building images locally, we recommend enabling it.

### Naming specs

The images built from this repository are named as follow:

`<JAVA_DISTRIBUTION_TYPE><JAVA_MAJOR_VERSION>-<OS_DISTRIBUTION_NAME><OS_DISTRIBUTION_VERSION>`

### Build an image locally

To build a local version of the base java image follow the instructions below:

```bash
docker build -t alfresco-base-java . \
  --build-arg DISTRIB_NAME=$DISTRIB_NAME \
  --build-arg DISTRIB_MAJOR=$DISTRIB_MAJOR \
  --build-arg JAVA_MAJOR=$JAVA_MAJOR \
  --build-arg JDIST=$JDIST \
  --no-cache --target JAVA_BASE_IMAGE
```

### Release

New images are built automatically on each new commit on master and on a weekly schedule.

## Glossary

* What is a [base image](https://docs.docker.com/glossary/#base-image).

## Downstream projects

Known projects currently using the base image:

* [Alfresco Base Tomcat](https://github.com/Alfresco/alfresco-docker-base-tomcat/blob/master/Dockerfile)
* [Alfresco ActiveMQ](https://github.com/Alfresco/alfresco-docker-activemq)
* [Alfresco Transform Core](https://github.com/Alfresco/alfresco-transform-core)
* [Alfresco Search Services](https://github.com/Alfresco/SearchServices)
* [Alfresco Connector for Hyland Experience Insight](https://github.com/Alfresco/hxinsight-connector)
