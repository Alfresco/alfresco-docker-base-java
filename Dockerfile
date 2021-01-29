# Alfresco Base Java Image

ARG CENTOS_VERSION=7
FROM centos:$CENTOS_VERSION

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java Image" \
    org.label-schema.vendor="Alfresco" \
    org.label-schema.build-date="$BUILD_DATE" \
    org.opencontainers.image.title="Alfresco Base Java Image" \
    org.opencontainers.image.vendor="Alfresco" \
    org.opencontainers.image.created="$BUILD_DATE"

ARG CENTOS_MAJOR_VERSION=7

RUN test $CENTOS_MAJOR_VERSION = 7 && \
    yum -y update \
    openssl-libs-1.0.2k-21.el7_9 \
    libcurl-7.29.0-59.el7_9.1 \
    curl-7.29.0-59.el7_9.1 \
    python-2.7.5-90.el7 \
    python-libs-2.7.5-90.el7 \
    bind-license-9.11.4-26.P2.el7_9.2 \
    && \
    yum clean all

RUN test $CENTOS_MAJOR_VERSION = 8 && \
    yum -y update \
    openssl-libs-1.1.1g-12.el8_3 \
    gnutls-3.6.14-7.el8_3 \
    && \
    yum clean all

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME=/usr/java/default

# This used to be serverjre-*.tar.gz (and not an ARG)
# now it will be serverjre-8u181-bin.tar.gz / serverjre-11.0.0-bin.tar.gz
ARG JAVA_PKG
ADD $JAVA_PKG /usr/java/

RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000 && \
    alternatives --install /usr/bin/keytool keytool $JAVA_DIR/bin/keytool 20000
