# Centos 7 Base Image for Alfresco Base Java Image
FROM centos:7.9.2009
RUN set -eux; \
	deps=" \
        openssl-libs-1.0.2k-21.el7_9 \
        libcurl-7.29.0-59.el7_9.1 \
        curl-7.29.0-59.el7_9.1 \
        python-2.7.5-90.el7 \
        python-libs-2.7.5-90.el7 \
        bind-license-9.11.4-26.P2.el7_9.4 \
        glibc-common-2.17-322.el7_9 \
        glibc-2.17-322.el7_9 \
	"; \
    yum -y update $deps; \
    yum clean all
