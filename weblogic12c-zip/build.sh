#!/bin/bash

echo "====================="

if [ ! -e wls1213_dev.zip ]
then
  echo "Download the WebLogic 12c ZIP Distribution and"
  echo "drop the file wls1213_dev.zip in this folder before"
  echo "building this WLS Docker container!"
  exit
fi

unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  MD5="MD5 (wls1213_dev.zip) = 0a9152e312997a630ac122ba45581a18"
  MD5_CHECK="`md5 wls1213_dev.zip`"
else
  MD5="0a9152e312997a630ac122ba45581a18  wls1213_dev.zip"
  MD5_CHECK="`md5sum wls1213_dev.zip`"
fi


if [ "$MD5" != "$MD5_CHECK" ]
then
  echo "MD5 does not match! Download again!"
  exit
fi

echo "====================="

docker build -t oracle/weblogic .

echo ""
echo "WebLogic Docker Container is ready to be used. To start, run 'dockWebLogic.sh'"

