# Alfresco Base Java Image
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR

FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN mkdir -p /usr/share/man/man1 || true; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get update -qq && apt-get upgrade -qq && \
    apt-get install --no-install-recommends -qq openjdk-${JAVA_MAJOR}-${JDIST}-headless && \
    apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; \
    JAVA_BIN_PATH=$(dpkg -L openjdk-${JAVA_MAJOR}-${JDIST}-headless | grep '\/bin\/java$'); \
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM debian:11-slim@sha256:125f346eac7055d8e1de1b036b1bd39781be5bad3d36417c109729d71af0cd73 AS debian11

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN mkdir -p /usr/share/man/man1 || true; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get update -qq && apt-get upgrade -qq && \
    apt-get install --no-install-recommends -qq openjdk-${JAVA_MAJOR}-${JDIST}-headless && \
    apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; \
    JAVA_BIN_PATH=$(dpkg -L openjdk-${JAVA_MAJOR}-${JDIST}-headless | grep '\/bin\/java$'); \
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM registry.access.redhat.com/ubi8/openjdk-11-runtime:1.11-2.1647527176 AS ubi8

ENV JAVA_HOME /etc/alternatives/jre
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

FROM centos:7.9.2009 AS centos7

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum update -y && \
    if [ "$JDIST" = 'jdk' ]; then PKG_DEVEL="devel"; fi && \
    # Update here in case of java upgrade
    [ $JAVA_MAJOR -eq 8 ] && JAVA_PKG_VERSION='1.8.0'; \
    [ $JAVA_MAJOR -eq 11 ] && JAVA_PKG_VERSION='11'; \
    yum install -y java-${JAVA_PKG_VERSION}-openjdk-${PKG_DEVEL:-headless} && \
    # Remove vulnerable packages shipped with base image (space separated list)
    PKG_4_REMOVAL="python-lxml" ; \
    rpm -e --nodeps ${PKG_4_REMOVAL} && \
    yum clean all && rm -rf /var/cache/yum && \
    JAVA_BIN_PATH=$(rpm -ql java-${JAVA_PKG_VERSION}-openjdk-${PKG_DEVEL:-headless} | grep '\/bin\/java$') && \
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM rockylinux:8.5.20220308@sha256:c7d13ea4d57355aaad6b6ebcdcca50f5be65fc821f54161430f5c25641d68c5c AS rockylinux8

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum update --security -y && \
    if [ "$JDIST" = 'jdk' ]; then PKG_DEVEL="devel"; fi && \
    # Update here in case of java upgrade
    [ $JAVA_MAJOR -eq 11 ] && JAVA_PKG_VERSION='11' ; \
    yum install -y java-${JAVA_PKG_VERSION}-openjdk-${PKG_DEVEL:-headless} && \
    yum clean all && rm -rf /var/cache/yum && \
    JAVA_BIN_PATH=$(rpm -ql java-${JAVA_PKG_VERSION}-openjdk-${PKG_DEVEL:-headless} | grep '\/bin\/java$') && \
    test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME

FROM alpine:3.15.2 AS alpine3.15

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_MAJOR}-openjdk
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apk update && \
    apk upgrade && \
    apk add openjdk${JAVA_MAJOR}-${JDIST}-headless && \
    rm -rf /var/cache/apk/*

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
