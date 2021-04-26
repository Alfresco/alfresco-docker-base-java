# Centos 7 Base Image for Alfresco Base Java Image
FROM centos:7.9.2009
RUN set -eux; \
	deps=" \
        bind-license-9.11.4-26.P2.el7_9.4 \
        curl-7.29.0-59.el7_9.1 \
        glibc-2.17-323.el7_9 \
        glibc-common-2.17-323.el7_9 \
        libcurl-7.29.0-59.el7_9.1 \
        openssl-1.0.2k-21.el7_9 \
        openssl-libs-1.0.2k-21.el7_9 \
        python-2.7.5-90.el7 \
        python-libs-2.7.5-90.el7 \
        zlib-1.2.7-19.el7_9 \
	"; \
    yum -y update $deps; \
    yum clean all
