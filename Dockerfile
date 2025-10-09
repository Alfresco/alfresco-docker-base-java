# Alfresco Base Java Image
ARG DISTRIB_NAME=rockylinux/rockylinux
ARG DISTRIB_MAJOR=9

FROM rockylinux/rockylinux:8 AS rockylinux8

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/etc/alternatives/jre \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN \
  dnf update --security -y && \
  dnf install -y langpacks-en java-${JAVA_MAJOR}-openjdk-headless && \
  dnf clean all

FROM rockylinux/rockylinux:9 AS rockylinux9

ARG JDIST
ARG JAVA_MAJOR

ENV JAVA_HOME=/etc/alternatives/jre \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install common packages
RUN \
  dnf update --security -y && \
  dnf install -y langpacks-en ca-certificates wget tar gzip && \
  dnf clean all

# For Java 25, use Temurin binaries; for others, use distribution packages
SHELL ["/bin/sh", "-o", "pipefail", "-c"]
RUN if [ "$JAVA_MAJOR" = "25" ]; then \
    # Download and install Temurin JDK from Eclipse Adoptium
    ARCH=$(uname -m | sed 's/x86_64/x64/g' | sed 's/aarch64/aarch64/g') && \
    TEMURIN_URL="https://api.adoptium.net/v3/binary/latest/${JAVA_MAJOR}/ga/linux/${ARCH}/${JDIST}/hotspot/normal/eclipse" && \
    echo "Installing Temurin JDK ${JAVA_MAJOR} for ${ARCH} from ${TEMURIN_URL}" && \
    wget --progress=dot:giga -O /tmp/temurin.tar.gz "${TEMURIN_URL}" && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/temurin.tar.gz -C /opt/java --strip-components=1 && \
    rm /tmp/temurin.tar.gz && \
    ln -sf /opt/java/bin/java /usr/bin/java && \
    mkdir -p /usr/lib/jvm && \
    ln -sf /opt/java /usr/lib/jvm/java-${JAVA_MAJOR}-openjdk && \
    mkdir -p /etc/alternatives && \
    ln -sf /opt/java /etc/alternatives/jre; \
  else \
    echo "Installing distribution packages for Java ${JAVA_MAJOR}" && \
    dnf install -y java-${JAVA_MAJOR}-openjdk-headless && \
    dnf clean all; \
  fi

FROM ${DISTRIB_NAME}${DISTRIB_MAJOR} AS java_base_image
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
