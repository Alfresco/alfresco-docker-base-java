# Alfresco Base Java Image
ARG DISTRIB_NAME=rockylinux/rockylinux
ARG DISTRIB_MAJOR=9

FROM ${DISTRIB_NAME}:${DISTRIB_MAJOR}

ARG DISTRIB_MAJOR
ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/etc/alternatives/jre \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

RUN <<EOC
  echo "Installing common distribution packages"
  dnf update --security -y
  dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-${DISTRIB_MAJOR}.noarch.rpm
  dnf install -y langpacks-en ca-certificates
  dnf clean all
EOC

RUN <<EOC
  echo "Installing distribution packages for Java ${JAVA_MAJOR}"
  dnf install -y java-${JAVA_MAJOR}-openjdk-headless
  dnf clean all
EOC

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
