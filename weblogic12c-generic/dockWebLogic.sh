#!/bin/sh
TMP_CID_FILE=tmp/weblogic.cid
DOCKER_IMAGE_NAME=oracle/weblogic:12.1.3
DOCKER_CONTAINER_NAME=wlsadmin

# CHECK FOR ARGUMENTS
# -a = will attach port 7001 to host
# -p = will create tmp/weblogic.cid file to avoid running multiple Admins
# -n [name] = the name of the admin server container. Must be unique. Default to 'wlsadmin'. 
while getopts "apn:" optname
  do
    case "$optname" in
      "a")
        ATTACH_DEFAULT_PORT="-p 7001:7001"
        ;;
      "p")
        USE_TMP_PID="true"
        ;;
      "n")
        DOCKER_CONTAINER_NAME="$OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
  done

# CONFIG PID TMP
if [ "$USE_TMP_PID" = true ]; then
  if [ ! -e tmp ]; then
    mkdir tmp
    if [ "$?" != 0 ]; then
      echo "Couldn't create tmp dir. Try without PID control (-p)."
      exit $?
    fi 
  fi

  if [ -e "$TMP_CID_FILE" ]; then
    docker kill `cat $TMP_CID_FILE` > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      rm -f $TMP_CID_FILE
    else
      docker rm `cat $TMP_CID_FILE`  > /dev/null 2>&1 && rm $TMP_CID_FILE
    fi
  fi

  PID_CONFIG="--cidfile $TMP_CID_FILE"
fi

# RUN THE DOCKER COMMAND
docker run \
 -d $ATTACH_DEFAULT_PORT \
 $PID_CONFIG \
 --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME \
 /u01/oracle/weblogic/user_projects/domains/base_domain/startWebLogic.sh

# EXTRACT THE IP ADDRESS
if [ -n "${ATTACH_DEFAULT_PORT}" ]
then
  WLS_ADMIN_IP=127.0.0.1
else
  WLS_ADMIN_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $DOCKER_CONTAINER_NAME)
fi

# REPORT IF DOCKER SUCCEEDED
if [ "$?" = 0 ]; then
  echo "WebLogic starting... "
  sleep 10
  echo "Open WebLogic Console at http://${WLS_ADMIN_IP}:7001/console"
else
  echo "There was an error trying to create a container"
  exit $?
fi
