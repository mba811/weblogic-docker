#!/bin/bash
IMAGE_NAME=oracle/weblogic:12.1.3
JAVA_VERSION="8u25"
JAVA_PKG="jdk-${JAVA_VERSION}-linux-x64.rpm"
JAVA_PKG_MD5="6a8897b5d92e5850ef3458aa89a5e9d7"
WLS_PKG="wls1213_dev.zip"
WLS_PKG_MD5="0a9152e312997a630ac122ba45581a18"

# Validate Java Package
echo "====================="

if [ ! -e $JAVA_PKG ]
then
  echo "Download the Oracle JDK ${JAVA_VERSION} RPM for 64 bit and"
  echo "drop the file $JAVA_PKG in this folder before"
  echo "building this image!"
  exit
fi

MD5="$JAVA_PKG_MD5  $JAVA_PKG"
MD5_CHECK="`md5sum $JAVA_PKG`"

if [ "$MD5" != "$MD5_CHECK" ]
then
  echo "MD5 for $JAVA_PKG does not match! Download again!"
  exit
fi

#
# Validate WLS Package
echo "====================="

if [ ! -e $WLS_PKG ]
then
  echo "Download the WebLogic 12c installer and"
  echo "drop the file $WLS_PKG in this folder before"
  echo "building this WLS Docker image!"
  exit 
fi

MD5="$WLS_PKG_MD5  $WLS_PKG"
MD5_CHECK="`md5sum $WLS_PKG`"

if [ "$MD5" != "$MD5_CHECK" ]
then
  echo "MD5 for $WLS_PKG does not match! Download again!"
  exit
fi

echo "====================="

docker build -t $IMAGE_NAME .

echo ""
echo "WebLogic Docker Container is ready to be used. To start, run 'dockWebLogic.sh'"

