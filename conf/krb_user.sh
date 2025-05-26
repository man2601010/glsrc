#!/bin/bash 

if [ $# != 1 ] ; then 
   echo "USAGE: $0 username" 
   exit 1; 
fi 

user=$1

PRG="${0}"
BASEDIR=`dirname ${PRG}`
BASEDIR=`cd ${BASEDIR}/..;pwd`

expect $BASEDIR/conf/add_keytab.exp $user
if [[ $? -gt 0 ]]; then
  exit 1
fi

#encode keytab file for base64
if [ -a "/tmp/.$user.keytab" ]; then
   #cat /tmp/.$user.keytab | base64 -w 0 > ./.$user.token 
   cat /tmp/.$user.keytab | base64 -w 0
fi

#delete tmp keytab  file
rm -f /tmp/.$user.keytab
