# Alfresco Base Java Image

ARG DISTRIB=centos
ARG DISTRIB_MAJOR=7
FROM $DISTRIB-$DISTRIB_MAJOR
ARG DISTRIB=centos
ARG DISTRIB_MAJOR=7
ARG JAVA_MAJOR=8
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

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN set -eux; [ $DISTRIB = 'debian' ] && mkdir -p /usr/share/man/man1 || true

RUN set -eux; \
    case "$DISTRIB" in \
      centos) \
        [[ ${DISTRIB_MAJOR} = 7 && ${JAVA_MAJOR} = 8 ]] && deps="\
          java-1.8.0-openjdk-headless-1.8.0.302.b08-0.el7_9 \
          java-1.8.0-openjdk-headless-1.8.0.292.b10-1.el7_9 \
        "; \
        [[ ${DISTRIB_MAJOR} = 8 && ${JAVA_MAJOR} = 8 ]] && deps="\
          java-1.8.0-openjdk-headless-1.8.0.302.b08-0.el8_4 \
        "; \
        [[ ${DISTRIB_MAJOR} = 7 && ${JAVA_MAJOR} = 11 ]] && deps="\
          java-11-openjdk-headless-11.0.12.0.7-0.el7_9 \
        "; \
        [[ ${DISTRIB_MAJOR} = 8 && ${JAVA_MAJOR} = 11 ]] && deps="\
          java-11-openjdk-headless-11.0.12.0.7-0.el8_4 \
        "; \
        locate_java() { JAVA_BIN_PATH=$(rpm -ql java-11-openjdk-headless | grep '\/bin\/java$'); } ; \
        pkg_install() { yum install -y $* && yum clean all; } ;; \
      debian) \
        [ ${DISTRIB_MAJOR} -eq 10 -a ${JAVA_MAJOR} -eq 11 ] && deps="\
          openjdk-11-jre-headless=11.0.12+7-2~deb10u1 \
        "; \
        locate_java() { JAVA_BIN_PATH=$(dpkg -L openjdk-11-jre-headless | grep '\/bin\/java$'); } ; \
        pkg_install() { apt-get update && apt-get install --no-install-recommends -y $* && apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; } ;; \
    esac; \
    pkg_install $deps; \
    locate_java; \
    export JAVA_HOME=${JAVA_BIN_PATH%*/bin/java}; \
    $JAVA_HOME/bin/java -version

RUN set -eux; \
    case "$DISTRIB" in \
      centos) \
        dist_update() { yum update -y && yum clean all; } ;; \
      debian) \
        dist_update() { apt-get update && apt-get upgrade -y && apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; } ;; \
    esac; \
    dist_update

