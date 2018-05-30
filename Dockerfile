# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.4.1708

LABEL name="Alfresco Base Java" \
    vendor="Alfresco" \
    license="Various" \
    build-date="unset"

RUN yum -y update \
    nss-3.36.0-5.el7_5 \
    bind-license-9.9.4-61.el7 \ 
    curl-7.29.0-46.el7 \
    systemd-219-57.el7 \
    glibc-2.17-222.el7 \
    openssl-libs-1.0.2k-12.el7 \
    krb5-libs-1.15.1-19.el7 \
    libgcc-4.8.5-28.el7_5.1 \
    libstdc++-4.8.5-28.el7_5.1 \
    procps-ng-3.3.10-17.el7_5.2

ENV JAVA_PKG=serverjre-*.tar.gz \
    JAVA_HOME=/usr/java/default

ADD $JAVA_PKG /usr/java/

RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
