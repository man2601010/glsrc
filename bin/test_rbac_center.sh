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
while [[ $index -le $count ]]
do 
  echo "retry $index"
  for ((i=0;i<${#type_array[*]};i++))
  do
     URL="http://tempt13.ops.lycc.qihoo.net:8191/get_permission?n=hdp&t=${type_array[$i]}"
     #echo $URL
     check_service_curl $URL
  done
  ((index+= 1))
done
