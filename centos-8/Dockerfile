# Centos 8 Base Image for Alfresco Base Java Image
FROM centos:8.3.2011
RUN set -eux; \
	deps=" \
        openssl-libs-1.1.1g-12.el8_3 \
        gnutls-3.6.14-7.el8_3 \
        bind-export-libs-9.11.20-5.el8_3.1 \
	"; \
    yum -y update $deps; \
    yum clean all
