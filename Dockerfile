# Alfresco Base Java Image
ARG DISTRIB_NAME
ARG DISTRIB_MAJOR

FROM rockylinux/rockylinux:9 AS rockylinux8

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/etc/alternatives/jre \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN \
  dnf update --security -y && \
  dnf install -y langpacks-en java-${JAVA_MAJOR}-openjdk-headless && \
  dnf clean all && rm -rf /var/cache/dnf

FROM rockylinux/rockylinux:9 AS rockylinux9

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/etc/alternatives/jre \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN \
  dnf update --security -y && \
  dnf install -y langpacks-en java-${JAVA_MAJOR}-openjdk-headless && \
  dnf clean all && rm -rf /var/cache/dnf

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
