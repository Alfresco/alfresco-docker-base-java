# Alfresco Base Java Image
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR

FROM ubuntu:20.04@sha256:57df66b9fc9ce2947e434b4aa02dbe16f6685e20db0c170917d4a1962a5fe6a9 AS ubuntu20.04

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN mkdir -p /usr/share/man/man1 || true; \
    # Update here in case of java upgrade
    # check https://ubuntu.com/security/cves?q=&package=openjdk-12 for security updates
    JAVA_PKG_VERSION=11.0.13+8-0ubuntu1~20.04; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get update -qqy && apt-get upgrade -qqy && \
    apt-get install --no-install-recommends -qqy openjdk-11-${JDIST}-headless=${JAVA_PKG_VERSION} && \
    apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; \
    JAVA_BIN_PATH=$(dpkg -L openjdk-${JAVA_MAJOR}-jre-headless | grep '\/bin\/java$'); \ 
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM debian:11-slim@sha256:125f346eac7055d8e1de1b036b1bd39781be5bad3d36417c109729d71af0cd73 AS debian11

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN mkdir -p /usr/share/man/man1 || true; \
    # Update here in case of java upgrade
    # check https://tracker.debian.org/pkg/openjdk-11 for security updates
    JAVA_PKG_VERSION=11.0.14+9-1~deb11u1; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get update -qqy && apt-get upgrade -qqy && \
    apt-get install --no-install-recommends -qqy openjdk-11-${JDIST}-headless=${JAVA_PKG_VERSION} && \
    apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; \
    JAVA_BIN_PATH=$(dpkg -L openjdk-${JAVA_MAJOR}-jre-headless | grep '\/bin\/java$'); \ 
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM registry.access.redhat.com/ubi8/openjdk-11-runtime:1.11-2 AS ubi8
ENV JAVA_HOME /etc/alternatives/jre
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

FROM centos:7.9.2009 AS centos7

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/jre
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum update -y && yum install -y;  \
    if [ "$JDIST" = 'jdk' ]; then PKG_DEVEL="devel-"; fi && \
    # Update here in case of java upgrade
    [ $JAVA_MAJOR -eq 8 ] && JAVA_PKG_VERSION='1.8.0' && JAVA_PKG_EXTRA_VERSION='322.b06-1.el7_9'; \
    [ $JAVA_MAJOR -eq 11 ] && JAVA_PKG_VERSION='11' && JAVA_PKG_EXTRA_VERSION='0.13.0.8-1.el7_9'; \
    yum install -y java-${JAVA_PKG_VERSION}-openjdk-${PKG_DEVEL:-headless-}${JAVA_PKG_VERSION}.${JAVA_PKG_EXTRA_VERSION} && \
    yum clean all && \
    JAVA_BIN_PATH=$(rpm -ql java-${JAVA_PKG_VERSION}-openjdk-headless | grep '\/bin\/java$') && \
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM ${DISTRIB_NAME}${DISTRIB_MAJOR} AS JAVA_BASE_IMAGE
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR
ARG JAVA_MAJOR
ARG CREATED
ARG REVISION
LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java Image" \
    org.label-schema.vendor="Alfresco" \
    org.label-schema.build-date="$CREATED" \
    org.opencontainers.image.title="Alfresco Base Java Image" \
    org.opencontainers.image.vendor="Alfresco" \
    org.opencontainers.image.created="$CREATED" \
    org.opencontainers.image.revision="$REVISION" \
    org.opencontainers.image.source="https://github.com/Alfresco/alfresco-docker-base-java"

RUN $JAVA_HOME/bin/java -version
