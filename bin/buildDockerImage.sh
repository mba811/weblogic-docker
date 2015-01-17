#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*

while getopts "hd" optname
  do
    case "$optname" in
      "h")
        echo "Usage: buildDockerImage.sh [-d]"
        echo ""
        echo "    -d: creates image based on 'weblogic12c-developer' distribution. "
        echo "        'weblogic12c-generic' otherwhise."
        echo ""
        exit 0
        ;;
      "d")
	setup_developer
	;;
      *)
      # Should not occur
        echo "Unknown error while processing options inside buildDockerImage.sh"
        ;;
    esac
  done


DOCKER_SCRIPTS_HOME=$SCRIPTS_DIR/../

echo "Building image '$IMAGE_NAME' based on distribution '$DISTRIBUTION'..."
 
# GO INTO DISTRIBUTION FOLDER
cd $DOCKER_SCRIPTS_HOME/$DISTRIBUTION

# Validate Java Package
if [ ! -e $JAVA_PKG ]
then
  echo "====================="
  echo "Download the Oracle JDK ${JAVA_VERSION} RPM for 64 bit and"
  echo "drop the file $JAVA_PKG in folder '$DISTRIBUTION' before"
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
if [ ! -e $WLS_PKG ]
then
  echo "====================="
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

# BUILD THE IMAGE
docker build -t $IMAGE_NAME .

echo ""
echo "WebLogic Docker Container is ready to be used. To start, run 'dockWebLogic.sh'"

