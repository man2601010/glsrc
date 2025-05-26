#!/bin/env bash

#Start service
function start_service() {
   serviceName=$1
   service $serviceName restart 2>&1 1>& /dev/null
   if [ $? -gt 0 ]
   then
      echo "$serviceName start failed...."
      exit 1
   fi
}

#start kdc
start_service  "krb5kdc"
start_service  "kadmin"

#Start ldap
start_service  "slapd"
