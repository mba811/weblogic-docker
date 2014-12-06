#!/bin/sh
IMAGE_NAME="oracle/weblogic-dev:12.1.3"
if [ ! -e tmp/weblogic.cid ]
then
  echo "First start WebLogic Admin Server by calling 'dockWebLogic.sh'"
  exit
fi

TIMESTAMP=`date +%s`
CONTAINER_NAME=nodemanager${TIMESTAMP}
CID_FILE=tmp/${CONTAINER_NAME}.cid

docker run -d \
 --name ${CONTAINER_NAME} \
 -e DOCKER_CONTAINER_NAME=${CONTAINER_NAME} \
 --cidfile $CID_FILE \
 --link wlsadmin:wlsadmin $IMAGE_NAME \
 /u01/oracle/createMachine.sh > /dev/null 2>&1

NMIP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' `cat $CID_FILE`)

echo "New NodeManager [${CONTAINER_NAME}] started on IP Address: ${NMIP}."
echo "Hopefully this Machine was automatically added to 'base_domain'."
echo "If not, go to Admin Console and try to add it manually with this IP address."
