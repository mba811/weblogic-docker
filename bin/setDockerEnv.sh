#!/bin/sh
DISTRIBUTION="weblogic12c-generic"
SKIP_BASE_DOMAIN_CREATION=false
IMAGE_NAME="oracle/weblogic:12.1.3"
TIMESTAMP=`date +%s`
NM_CONTAINER_NAME="nodemanager${TIMESTAMP}"
ADMIN_CONTAINER_NAME="wlsadmin"
ATTACH_ADMIN_TO=7001

# JAVA PACKAGE CHECK
JAVA_VERSION="8u25"
JAVA_PKG="jdk-${JAVA_VERSION}-linux-x64.rpm"
JAVA_PKG_MD5="6a8897b5d92e5850ef3458aa89a5e9d7"

# WEBLOGIC 12.1.3 GENERIC
WLS_PKG="fmw_12.1.3.0.0_wls.jar"
WLS_PKG_MD5="8378fe936b476a6f4ca5efa465a435e3"

setup_developer() {
	echo "Builder configured to build developer image"
        DISTRIBUTION="weblogic12c-developer"
        WLS_PKG="wls1213_dev.zip"
        WLS_PKG_MD5="0a9152e312997a630ac122ba45581a18"
}
