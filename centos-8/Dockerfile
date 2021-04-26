# Centos 8 Base Image for Alfresco Base Java Image
FROM centos:8.3.2011
RUN set -eux; \
	deps=" \
        bind-export-libs-9.11.20-5.el8_3.1 \
        file-libs-5.33-16.el8_3.1 \
        gnutls-3.6.14-8.el8_3 \
        nettle-3.4.1-4.el8_3 \
        openssl-1.1.1g-15.el8_3 \
        openssl-libs-1.1.1g-15.el8_3 \
        zlib-1.2.11-16.2.el8_3 \
	"; \
    yum -y update $deps; \
    yum clean all
