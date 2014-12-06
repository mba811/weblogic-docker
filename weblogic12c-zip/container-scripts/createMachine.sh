#!/bin/bash
. /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/setDomainEnv.sh
nohup /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/startNodeManager.sh &
sleep 5 && java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning /u01/oracle/add-machine.py
while true; do
  sleep 60
done
