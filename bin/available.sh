#!/bin/bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to dir bin
cd $cur

source ../conf/ldap-env.sh

HOSTNAME=`hostname -f`

function check_service_curl() {
    url=$1
    #echo "$url"
    curl "$url" 2>&1 1>&/dev/null
    if [ $? -gt 0 ]
    then
       exit 1
    fi
}

#check ldapservice
URL="http://$HOSTNAME:$SERVER_PORT/ldapGroup/groups?pagenum=1&&pagesize=1"
check_service_curl "$URL"

#check  rbac service
URL="http://$HOSTNAME:$SERVER_PORT/role?groupId=100"
check_service_curl "$URL"

#check rbac center service
URL="http://$HOSTNAME:$SERVER_PORT/get_permission?n=hdp&t=hdfs"
check_service_curl "$URL"
