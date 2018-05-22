# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.4.1708

LABEL name="Alfresco Base Java" \
    vendor="Alfresco" \
    license="Various" \
    build-date="unset"

RUN yum -y update nss bind-license curl systemd glibc openssl-libs krb5-libs libgcc libstdc++

# Added curl update to fix security issue, this should be removed on next iteration if not necessary
ENV JAVA_PKG=serverjre-*.tar.gz \
    JAVA_HOME=/usr/java/default

ADD $JAVA_PKG /usr/java/

RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
