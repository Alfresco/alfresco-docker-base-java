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
  if [ "$JDIST" = 'jdk' ]; then \
    REPO_FILE="/etc/yum.repos.d/adoptium.repo" && \
    echo "[Adoptium]" >> $REPO_FILE && \
    echo "name=Adoptium" >> $REPO_FILE && \
    echo "enabled=1" >> $REPO_FILE && \
    echo "gpgcheck=1" >> $REPO_FILE && \
    echo "gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public" >> $REPO_FILE && \
    echo "baseurl=https://packages.adoptium.net/artifactory/rpm/centos/7/$(uname -m)" >> $REPO_FILE && \
    yum install -y temurin-${JAVA_MAJOR}-${JDIST}; \
  else \
    ARCH=$(uname -m | sed s/86_//) && \
    if [ $JAVA_MAJOR -eq 11 ]; then JAVA_VERSION="11.0.15_10" ; fi && \
    if [ $JAVA_MAJOR -eq 17 ]; then JAVA_VERSION="17.0.3_7" ; fi && \
    curl -fsLo java.tar.gz https://github.com/adoptium/temurin${JAVA_MAJOR}-binaries/releases/download/jdk-${JAVA_VERSION/_/%2B}/OpenJDK${JAVA_MAJOR}U-${JDIST}_${ARCH}_linux_hotspot_${JAVA_VERSION}.tar.gz && \
    tar xvfz java.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    mv jdk-* ${JAVA_HOME} && \
    update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 1; \
  fi && \
  yum clean all && rm -rf /var/cache/yum

FROM rockylinux:8.6.20227707@sha256:afd392a691df0475390df77cb5486f226bc2b4cbaf87c41785115b9237f3203f AS rockylinux8

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
