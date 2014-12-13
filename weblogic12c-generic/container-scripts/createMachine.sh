#!/bin/bash

# Set WLS domain environment
. /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/setDomainEnv.sh

# TODO: check if machine already exists. If it does, make sure it listen to the correct ip address

# Start Node Manager
nohup /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/startNodeManager.sh &

# Add if necessary
sleep 5 && java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST \
	-skipWLSModuleScanning \
	/u01/oracle/add-machine.py
while true; do
  sleep 60
done
