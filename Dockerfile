# Alfresco Base Java Image

ARG DISTRIB_NAME
ARG DISTRIB_MAJOR
FROM $DISTRIB_NAME-$DISTRIB_MAJOR
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

RUN set -eux; \
    case "$DISTRIB_NAME" in \
      centos) \
        dist_update() { yum update -y; }; \
        cleanup() { yum clean all; }; \
        pkg_install() { \
          [[ ${DISTRIB_MAJOR} = 7 && ${JAVA_MAJOR} = 8 ]] && JAVA_PKG_VERSION=1.8.0 && deps="\
            java-1.8.0-openjdk-1.8.0.302.b08-0.el7_9 \
          "; \
          [[ ${DISTRIB_MAJOR} = 7 && ${JAVA_MAJOR} = 11 ]] && JAVA_PKG_VERSION=11 && deps="\
            java-11-openjdk-11.0.12.0.7-0.el7_9 \
          "; \
          yum install -y $deps; \
        }; \
        locate_java() { \
          JAVA_BIN_PATH=$(rpm -ql java-${JAVA_PKG_VERSION}-openjdk-headless | grep '\/bin\/java$'); \
        };; \
      debian) \
        DEBIAN_FRONTEND=noninteractive; \
        mkdir -p /usr/share/man/man1 || true; \
        dist_update() { apt-get update && apt-get upgrade -y; }; \
        cleanup() { apt-get clean -y && find /var/lib/apt/lists/ -type f -delete; }; \
        pkg_install() { \
          [ ${DISTRIB_MAJOR} -eq 10 -a ${JAVA_MAJOR} -eq 11 ] && deps="\
            openjdk-11-jre-headless=11.0.12+7-2~deb10u1 \
          "; \
          apt-get update && apt-get install --no-install-recommends -y $deps; \
        }; \
        locate_java() { \
          JAVA_BIN_PATH=$(dpkg -L openjdk-${JAVA_MAJOR}-jre-headless | grep '\/bin\/java$'); \
        };; \
      ubi) \
        dist_update() { echo do nothing; }; \
        cleanup() { echo do nothing; }; \
        pkg_install() { echo do nothing; }; \
        locate_java() { echo do nothing; };; \
    esac; \
    dist_update; \
    pkg_install; \
    locate_java && test -L $JAVA_HOME || ln -sf ${JAVA_BIN_PATH%*/bin/java} $JAVA_HOME; \
    cleanup; \
    $JAVA_HOME/bin/java -version

