# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.5.1804

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java" \
    org.label-schema.vendor="Alfresco"

RUN yum -y update \
    yum-utils-1.1.31-54.el7_8 \
    yum-plugin-ovl-1.1.31-53.el7 \
    yum-plugin-fastestmirror-1.1.31-53.el7 \
    bind-license-9.11.4-16.P2.el7_8.2 \
    glibc-2.17-307.el7.1 \
    glib2-2.56.1-5.el7 \
    systemd-219-73.el7_8.5 \
    expat-2.1.0-11.el7 \
    bash-4.2.46-34.el7 \
    shared-mime-info-1.8-5.el7 \
    libxml2-2.9.1-6.el7.4 \
    openssl-libs-1.0.2k-19.el7 \
    krb5-libs-1.15.1-46.el7 \
    setup-2.8.71-11.el7 \
    python-2.7.5-88.el7 \
    gnupg2-2.0.22-5.el7_5 \
    nss-3.44.0-7.el7_7 \
    vim-minimal-7.4.629-6.el7 \
    procps-ng-3.3.10-27.el7 \
    binutils-2.27-43.base.el7 \
    curl-7.29.0-57.el7 \
    sqlite-3.7.17-8.el7_7.1 \
    gobject-introspection-1.56.1-1.el7 \
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
