# Centos 8 Base Image for Alfresco Base Java Image
FROM centos:8.3.2011
RUN set -eux; \
	deps=" \
        openssl-1.1.1g-15.el8_3 \
        openssl-libs-1.1.1g-15.el8_3 \
        gnutls-3.6.14-8.el8_3 \
        bind-export-libs-9.11.20-5.el8_3.1 \
        nettle-3.4.1-2.el8 \
	"; \
    yum -y update $deps; \
    yum clean all
