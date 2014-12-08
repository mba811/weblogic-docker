#!/bin/sh
#
# Usage:  
#         dockNodeManager -n [container name running admin server]
#
# Since: October, 2014
# Author: bruno.borges@oracle.com
# Description: script to create a WLS container based on IMAGE_NAME and start NodeManager within it. After NodeManager is started, a script 'add-machine.py' is called that will automatically add the NodeManager as Machine into the domain associated to ADMIN_CONTAINER_NAME
#
IMAGE_NAME="oracle/weblogic-dev:12.1.3"
ADMIN_CONTAINER_NAME=wlsadmin
TIMESTAMP=`date +%s`
CONTAINER_NAME=nodemanager${TIMESTAMP}
CID_FILE=tmp/${CONTAINER_NAME}.cid

# CHECK FOR ARGUMENTS
# -a = will attach port 7001 to host
# -p = will create tmp/weblogic.cid file to avoid running multiple Admins
# -n [name] = the name of the admin server container which this NM will automatically plug to. Must exist. Defaults to 'wlsadmin'.
while getopts "pn:" optname
  do
    case "$optname" in
      "p")
        USE_PID_CONFIG=true
        ;;
      "n")
        ADMIN_CONTAINER_NAME="$OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
  done

# CHECK IF CONTAINER EXISTS AND IS RUNNING
# Based on https://gist.github.com/ekristen/11254304 (MIT Licensed)
ADMIN_CONTAINER_RUNNING=$(docker inspect --format="{{ .State.Running }}" $ADMIN_CONTAINER_NAME 2> /dev/null)
 
if [ $? -eq 1 ]; then
  echo "Admin container '$ADMIN_CONTAINER_NAME' with WLS Admin Server running does not exist. Create one first calling 'dockWebLogic.sh -n $ADMIN_CONTAINER_NAME'"
  exit $? 
fi
 
if [ "$ADMIN_CONTAINER_RUNNING" == "false" ]; then
  echo "Admin container '$ADMIN_CONTAINER_NAME' is not running. Unpause or start it"
  exit $?
fi
 
GHOST_STATUS=$(docker inspect --format="{{ .State.Ghost }}" $ADMIN_CONTAINER_NAME)
 
if [ "$GHOST_STATUS" == "true" ]; then
  echo "Admin container '$ADMIN_CONTAINER_NAME' has been ghosted. Destroy it and create again."
  exit $?
fi 

# PID FILE
if [ "$USE_PID_CONFIG" = true ]; then
  touch tmp/$CID_FILE
  if [ $? -e 0 ]; then
    PID_CONFIG="--cidfile $CID_FILE"
  fi
fi

# RUN DOCKER
CONTAINER_ID=`docker run -d \
 --name ${CONTAINER_NAME} \
 -e DOCKER_CONTAINER_NAME=${CONTAINER_NAME} \
 $PID_CONFIG \
 --link $ADMIN_CONTAINER_NAME:wlsadmin $IMAGE_NAME \
 /u01/oracle/createMachine.sh > /dev/null 2>&1`

NMIP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $CONTAINER_NAME)

echo "New NodeManager [$CONTAINER_NAME] started on IP Address: $NMIP."
echo "Hopefully this Machine was automatically added to 'base_domain' in the [$ADMIN_CONTAINER_NAME] admin server."
echo "If not, go to Admin Console and try to add it manually with this IP address."
