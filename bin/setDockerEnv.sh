#!/bin/sh
IMAGE_NAME="oracle/weblogic:12.1.3"
TIMESTAMP=`date +%s`
NM_CONTAINER_NAME="nodemanager${TIMESTAMP}"
ADMIN_CONTAINER_NAME="wlsadmin"
ATTACH_ADMIN_TO=7001
