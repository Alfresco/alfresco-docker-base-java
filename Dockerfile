# Alfresco Anaxes Shipyard Base Java Image
#
# Version 0.1

# first stage: strip JDK package of largest, superflous files
# src.zip and *.jmod files are only used in development
FROM centos:7.5.1804 as jdkRepackager

# This used to be serverjre-*.tar.gz (and not an ARG)
# now it will be serverjre-8u181-bin.tar.gz / serverjre-11.0.0-bin.tar.gz
ARG JAVA_PKG
COPY $JAVA_PKG /tmp/

RUN mkdir /tmp/java \
  && tar xzf /tmp/$JAVA_PKG -C /tmp/java \
  && find /tmp/java/ -iname src.zip -delete \
  && find /tmp/java/ -iname *.jmod -delete \
  && rm /tmp/$JAVA_PKG

# This is an initial iteration and subject to change
FROM centos:7.5.1804

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Alfresco Base Java" \
    org.label-schema.vendor="Alfresco"

RUN yum -y update \
    yum-utils-1.1.31-46.el7_5 \
    yum-plugin-ovl-1.1.31-46.el7_5 \
    yum-plugin-fastestmirror-1.1.31-46.el7_5 \
    bind-license-9.9.4-61.el7_5.1 \
    python-2.7.5-69.el7_5 \
    gnupg2-2.0.22-5.el7_5 \
    nss-3.36.0-7.el7_5 \
    nss-sysinit-3.36.0-7.el7_5 \
    nss-tools-3.36.0-7.el7_5 \
    && \
    yum clean all

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME=/usr/java/default

COPY --from=jdkRepackager /tmp/java /usr/java

RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
