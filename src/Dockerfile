# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# This is an initial iteration and subject to change
FROM centos:7.5.1804

LABEL name="Alfresco Base Java" \
    vendor="Alfresco" \
    license="Various" \
    build-date="unset"

RUN yum -y update \
    yum-utils-1.1.31-46.el7_5 \
    python-2.7.5-69.el7_5 \
    gnupg2-2.0.22-5.el7_5

# like serverjre-*.tar.gz 
ARG JAVA_PKG

ENV JAVA_HOME=/usr/java/default

ADD $JAVA_PKG /usr/java/

RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
