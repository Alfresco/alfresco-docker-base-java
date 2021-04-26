# Alfresco Base Java Image

ARG CENTOS_MAJOR=7
FROM centos-$CENTOS_MAJOR
ARG CENTOS_MAJOR=7
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

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV JAVA_HOME=/usr/lib/jvm/java

RUN set -eux; \
	[[ ${CENTOS_MAJOR} = 7 && ${JAVA_MAJOR} = 8 ]] && deps=" \
		java-1.8.0-openjdk-devel-1.8.0.292.b10-1.el7_9 \
	"; \
	[[ ${CENTOS_MAJOR} = 8 && ${JAVA_MAJOR} = 8 ]] && deps=" \
		java-1.8.0-openjdk-devel-1.8.0.292.b10-0.el8_3 \
	"; \
	[[ ${CENTOS_MAJOR} = 7 && ${JAVA_MAJOR} = 11 ]] && deps=" \
		java-11-openjdk-devel-11.0.11.0.9-1.el7_9 \
	"; \
	[[ ${CENTOS_MAJOR} = 8 && ${JAVA_MAJOR} = 11 ]] && deps=" \
		java-11-openjdk-devel-11.0.11.0.9-0.el8_3 \
	"; \
    yum -y install $deps; \
    yum clean all; \
    $JAVA_HOME/bin/javac -version
