#!/bin/bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to dir bin
cd $cur

source ../conf/ldap-env.sh

##stop thread###
function stop_service(){
  pid="$1"
  serviceName="$2"
  killcount=0
  
  if [ -f $pid ]; then
    TARGET_ID="$(cat "$pid")"
    while [[ $(ps -p "$TARGET_ID" -o comm=) =~ "java" ]]
    do
       echo "stopping $serviceName"
       kill "$TARGET_ID"
       sleep 2
       if [ $killcount -eq 20  ]; then
         kill -9 "$TARGET_ID"
         echo "stopping $serviceName unnormally"
         sleep 3
       fi
       ((killcount+= 1))
    done
    echo "$serviceName is stoped"
    if [ -f $pid ]; then
       rm -f "$pid"
    fi
  else
    echo "no $serviceName need to stop"
  fi
}

#stop service
stop_service "$PID_HOME/ldap-rbac-pid" "ldap service"
#stop_service "$PID_HOME/rbac-center-pid" "rbac center"
