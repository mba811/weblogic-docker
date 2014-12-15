#!/bin/sh
#
# Usage:  
#    -a [port]: attach AdminServer port to host. If -a is present, will attach. Defaults to 7001.
#    -n [name]: give a different name for the container. default: wlsadmin
#  $ sudo sh dockWebLogic.sh -n [container name running admin server]
#
# Since: October, 2014
# Author: bruno.borges@oracle.com
# Description: script to create a container with WLS Admin Server
# based on IMAGE_NAME within it.
#

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*

# CHECK AND READ ARGUMENTS
while getopts "ha:n:" optname
  do
    case "$optname" in
      "h")
	echo "Usage:"
	echo "   -a [port]: attach AdminServer port to host. If -a is present, will attach. Defaults to 7001."
	echo "   -n name: give a different name for the container. default: wlsadmin"
	echo ""
	echo " # sh dockWebLogic.sh [-a [port]] [-n mywlsadmin]"
        exit 0
        ;;
      "a")
        if [ "" != "$OPTARG" ]; then
          ATTACH_ADMIN_TO=$OPTARG
        fi
        ATTACH_DEFAULT_PORT="-p $ATTACH_ADMIN_TO:7001"
        ;;
      "n")
        ADMIN_CONTAINER_NAME="$OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options inside dockWebLogic.sh"
        ;;
    esac
  done

# RUN THE DOCKER COMMAND
docker run \
 -d $ATTACH_DEFAULT_PORT \
 --name $ADMIN_CONTAINER_NAME $IMAGE_NAME \
 /u01/oracle/weblogic/user_projects/domains/base_domain/startWebLogic.sh

# EXTRACT THE IP ADDRESS
if [ -n "${ATTACH_DEFAULT_PORT}" ]
then
  WLS_ADMIN_IP=localhost
else
  WLS_ADMIN_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $ADMIN_CONTAINER_NAME)
fi

# REPORT IF DOCKER SUCCEEDED
if [ "$?" = 0 ]; then
  echo "WebLogic starting... "
  sleep 10
  echo "Open WebLogic Console at http://${WLS_ADMIN_IP}:${ATTACH_ADMIN_TO}/console"
else
  echo "There was an error trying to create a container"
  exit $?
fi
