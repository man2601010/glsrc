#!/bin/bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

type_array=( hdfs hive hbase yarn storm kafka s3 unkowntype)

function check_service_curl() {
    url=$1
    curl "$url" 2>&1 1>&/dev/null
    if [ $? -gt 0 ]
    then
       echo "check service failed with url:$url"
       exit 1
    fi
}


count=$1
index=1
HOSTNAME="tempt53.ops.lycc.qihoo.net"
while [[ $index -le $count ]]
do 
  echo "retry $index"
  check_service_curl "http://$HOSTNAME:10010/ldapGroup/groups?pagenum=1&&pagesize=1"
  check_service_curl "http://$HOSTNAME:10010/role?groupId=100"
  ((index+= 1))
done
