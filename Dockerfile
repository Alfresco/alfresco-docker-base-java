# Alfresco Base Java Image
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR

FROM centos:7.9.2009 AS centos7

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME /etc/alternatives/jre
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN \
  yum update --security -y && \
  if [ "$JDIST" = 'jdk' ]; then JAVA_PKG_TYPE="devel"; else JAVA_PKG_TYPE="headless"; fi && \
  yum install -y langpacks-en java-${JAVA_MAJOR}-openjdk-${JAVA_PKG_TYPE} && \
  # Remove vulnerable packages shipped with base image (space separated list)
  PKG_4_REMOVAL="python-lxml" && \
  rpm -e --nodeps ${PKG_4_REMOVAL} && \
  yum clean all && rm -rf /var/cache/yum

FROM rockylinux:8.5.20220308@sha256:c7d13ea4d57355aaad6b6ebcdcca50f5be65fc821f54161430f5c25641d68c5c AS rockylinux8

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME /etc/alternatives/jre
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN \
  yum update --security -y && \
  if [ "$JDIST" = 'jdk' ]; then JAVA_PKG_TYPE="devel"; else JAVA_PKG_TYPE="headless"; fi && \
  yum install -y langpacks-en java-${JAVA_MAJOR}-openjdk-${JAVA_PKG_TYPE} && \
  yum clean all && rm -rf /var/cache/yum

FROM alpine:3.15.4 AS alpine3.15

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_MAJOR}-openjdk
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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
