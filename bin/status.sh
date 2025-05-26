#!/bin/bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to dir bin
cd $cur

source ../conf/ldap-env.sh

ldap_pid=$PID_HOME/ldap-rbac-pid
rbac_pid=$PID_HOME/rbac-center-pid

thread_is_alive=0

function check_port() {
    port=$1
    netstat -ant | grep $port | grep -v grep | grep LISTEN > /dev/null
    if [ $? -gt 0 ]
    then
       echo "$port is not avilabe now...."
       exit 1
    fi
}

#check thread status
function check_thread_status(){
  pid=$1
  command=$2
  thread_type=$3
  if [ -f $pid ]; then
     TARGET_ID="$(cat "$pid")"
     if [[ $(ps -p "$TARGET_ID" -o comm=) =~ "$thread_type" ]]; then
        echo "$command is running."
        thread_is_alive=1
     else
        echo "$pid file is present but $command is not running now"
        exit 1
     fi
  else
     echo "$pid file not exist."
     exit 2
  fi
}

###check process thread status#####
check_thread_status "$ldap_pid" "ldap server" "java"
#if [ $thread_is_alive -eq 1 ] ; then
#   check_thread_status "$rbac_pid" "rbac center" "java"
#fi


###check process port###
#check ldap-rbac
check_port "$SERVER_PORT"
#check rbac-center
#check_port "8191"
#check ldap service
check_port "389"
#check kdc and kadmin
check_port "749"
check_port "88"
