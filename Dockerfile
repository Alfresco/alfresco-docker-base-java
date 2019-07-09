# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.5.1804

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java" \
    org.label-schema.vendor="Alfresco"

RUN yum -y update \
    yum-utils-1.1.31-50.el7 \
    yum-plugin-ovl-1.1.31-50.el7 \
    yum-plugin-fastestmirror-1.1.31-50.el7 \
    bind-license-9.9.4-74.el7_6.1 \
    vim-minimal-7.4.160-6.el7_6 \
    glibc-2.17-260.el7_6.5 \
    openssl-libs-1.0.2k-16.el7_6.1 \
    krb5-libs-1.15.1-37.el7_6 \
    setup-2.8.71-10.el7 \
    python-2.7.5-80.el7_6 \
    gnupg2-2.0.22-5.el7_5 \
    nss-3.36.0-7.el7_5 \
    nss-sysinit-3.36.0-7.el7_5 \
    nss-tools-3.36.0-7.el7_5 \
    systemd-libs-219-62.el7_6.5 \
    libssh2-1.4.3-12.el7_6.2 \
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
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
