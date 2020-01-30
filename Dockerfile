# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.5.1804

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java" \
    org.label-schema.vendor="Alfresco"

RUN yum -y update \
    yum-utils-1.1.31-52.el7 \
    yum-plugin-ovl-1.1.31-52.el7 \
    yum-plugin-fastestmirror-1.1.31-52.el7 \
    bind-license-9.11.4-9.P2.el7 \
    glibc-2.17-292.el7 \
    openssl-libs-1.0.2k-19.el7 \
    krb5-libs-1.15.1-37.el7_7.2 \
    setup-2.8.71-10.el7 \
    python-2.7.5-86.el7 \
    gnupg2-2.0.22-5.el7_5 \
    nss-3.44.0-7.el7_7 \
    nss-sysinit-3.44.0-7.el7_7 \
    nss-tools-3.44.0-7.el7_7 \
    systemd-libs-219-67.el7_7.2 \
    libssh2-1.8.0-3.el7 \
    vim-minimal-7.4.629-6.el7 \
    procps-ng-3.3.10-26.el7_7.1 \
    binutils-2.27-41.base.el7_7.1 \
    curl-7.29.0-54.el7 \
    sqlite-3.7.17-8.el7_7.1 \
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
