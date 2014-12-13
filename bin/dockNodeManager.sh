#!/bin/sh
#
# Usage:  
#         dockNodeManager.sh -n [container name running admin server]
#
# Since: October, 2014
# Author: bruno.borges@oracle.com
# Description: script to create a WLS container based on IMAGE_NAME and start NodeManager within it. After NodeManager is started, a script 'add-machine.py' is called that will automatically add the NodeManager as Machine into the domain associated to ADMIN_CONTAINER_NAME
#

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*

# CHECK FOR ARGUMENTS
# -n [name] = the name of the admin server container which this NM will automatically plug to. Must exist. Defaults to 'wlsadmin'.
while getopts "hn:" optname
  do
    case "$optname" in
      "h")
	echo "Usage:  "
	echo "       dockNodeManager.sh -n [container name running admin server]"
        exit 0
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

# RUN DOCKER
CONTAINER_ID=`docker run -d \
 --name ${NM_CONTAINER_NAME} \
 -e DOCKER_CONTAINER_NAME=${NM_CONTAINER_NAME} \
 --link $ADMIN_CONTAINER_NAME:wlsadmin $IMAGE_NAME \
 /u01/oracle/createMachine.sh > /dev/null 2>&1`

NMIP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $CONTAINER_ID)

echo "New NodeManager [$NM_CONTAINER_NAME] started on IP Address: $NMIP."
echo "Hopefully this Machine was automatically added to 'base_domain' in the [$ADMIN_CONTAINER_NAME] admin server."
echo "If not, go to Admin Console and try to add it manually with this IP address."
