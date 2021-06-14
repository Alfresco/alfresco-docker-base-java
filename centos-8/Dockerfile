# Centos 8 Base Image for Alfresco Base Java Image
FROM centos:8.3.2011
RUN set -eux; \
	deps=" \
        bash-4.4.19-14.el8 \
        bind-export-libs-9.11.26-4.el8_4 \
        cpio-2.12-10.el8 \
        curl-7.61.1-18.el8 \
        dhcp-client-4.3.6-44.el8_4.1 \
        dhcp-common-4.3.6-44.el8_4.1 \
        dhcp-libs-4.3.6-44.el8_4.1 \
        file-libs-5.33-16.el8_3.1 \
        glib2-2.56.4-10.el8_4 \
        glibc-2.28-151.el8 \
        glibc-common-2.28-151.el8 \
        glibc-minimal-langpack-2.28-151.el8 \
        gnutls-3.6.14-8.el8_3 \
        krb5-libs-1.18.2-8.el8 \
        libarchive-3.3.3-1.el8 \
        libcurl-minimal-7.61.1-18.el8 \
        libdb-5.3.28-40.el8 \
        libdb-utils-5.3.28-40.el8 \
        libxml2-2.9.7-9.el8 \
        nettle-3.4.1-4.el8_3 \
        openssl-1.1.1g-15.el8_3 \
        openssl-libs-1.1.1g-15.el8_3 \
        p11-kit-0.23.22-1.el8 \
        p11-kit-trust-0.23.22-1.el8 \
        platform-python-3.6.8-37.el8 \
        python3-libs-3.6.8-37.el8 \
        sqlite-libs-3.26.0-13.el8 \
        systemd-239-45.el8 \
        systemd-libs-239-45.el8	\
        systemd-pam-239-45.el8 \
        systemd-udev-239-45.el8 \
        zlib-1.2.11-16.2.el8_3 \
	"; \
    yum -y update $deps; \
    yum clean all
