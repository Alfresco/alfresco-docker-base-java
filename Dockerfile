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

RUN set -eux; \
	[[ ${CENTOS_MAJOR} = 7 && ${JAVA_MAJOR} = 8 ]] && deps=" \
		java-1.8.0-openjdk-headless-1.8.0.282.b08-1.el7_9 \
	"; \
	[[ ${CENTOS_MAJOR} = 8 && ${JAVA_MAJOR} = 8 ]] && deps=" \
		java-1.8.0-openjdk-headless-1.8.0.282.b08-4.el8 \
	"; \
	[[ ${CENTOS_MAJOR} = 7 && ${JAVA_MAJOR} = 11 ]] && deps=" \
		java-11-openjdk-headless-11.0.10.0.9-0.el7_9 \
	"; \
	[[ ${CENTOS_MAJOR} = 8 && ${JAVA_MAJOR} = 11 ]] && deps=" \
		java-11-openjdk-headless-11.0.10.0.9-4.el8 \
	"; \
    yum -y install $deps; \
    yum clean all;
