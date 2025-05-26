#!/bin/env bash

#Stop service
function stop_service() {
   serviceName=$1
   service $serviceName stop 2>&1 1>& /dev/null
   if [ $? -gt 0 ]
   then
      echo "$serviceName stop failed...."
      exit 1
   fi
}

#start kdc
stop_service  "krb5kdc"
stop_service  "kadmin"

#Start ldap
stop_service  "slapd"
