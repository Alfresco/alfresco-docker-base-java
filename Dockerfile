# Alfresco Base Java Image
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR

FROM centos:7.9.2009 AS centos7

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME /usr/lib/jvm/temurin-${JAVA_MAJOR}-jdk
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -eux; \
  yum update --security -y && \
  ARCH=$(uname -m | sed s/86_//) && \
  if [ $JAVA_MAJOR -eq 11 ]; then JAVA_VERSION="11.0.15_10" ; fi && \
  if [ $JAVA_MAJOR -eq 17 ]; then JAVA_VERSION="17.0.3_7" ; fi && \
  curl -fsLo java.tar.gz https://github.com/adoptium/temurin${JAVA_MAJOR}-binaries/releases/download/jdk-${JAVA_VERSION/_/%2B}/OpenJDK${JAVA_MAJOR}U-${JDIST}_${ARCH}_linux_hotspot_${JAVA_VERSION}.tar.gz && \
  tar xvfz java.tar.gz && \
  mkdir -p /usr/lib/jvm && \
  mv jdk-* ${JAVA_HOME} && \
  update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 1; \
  yum clean all && rm -rf /var/cache/yum

FROM rockylinux:8.8 AS rockylinux8

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME /etc/alternatives/jre
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN \
  yum update --security -y && \
  yum install -y langpacks-en java-${JAVA_MAJOR}-openjdk-headless && \
  yum clean all && rm -rf /var/cache/yum

FROM rockylinux:9.2 AS rockylinux9

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME /etc/alternatives/jre
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN \
  yum update --security -y && \
  yum install -y langpacks-en java-${JAVA_MAJOR}-openjdk-headless && \
  yum clean all && rm -rf /var/cache/yum

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
