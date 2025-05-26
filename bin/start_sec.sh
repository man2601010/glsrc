#!/bin/env bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to dir bin
cd $cur

################################
# main
################################

# set default params
JAVA_OPTS="-Xms50G -Xmx50G -Xmn20G  -XX:MaxPermSize=50G -XX:PermSize=50g "


source ../conf/ldap-env.sh

if [ -z "${JAVA_HOME}" ] ; then
  echo "JAVA_HOME is not set!"
  exit 1;
fi


#check current dir is exsit
if [ ! -d "$PID_HOME" ]; then
  mkdir -p "$PID_HOME"
fi

if [ ! -d "$LOG_HOME" ]; then
  mkdir -p "$LOG_HOME"
fi



ldap_pid=$PID_HOME/ldap-rbac-pid
if [ -f "$ldap_pid" ]; then
    TARGET_ID="$(cat "$ldap_pid")"
    if [[ $(ps -p "$TARGET_ID" -o comm=) =~ "java" ]]; then
      echo " ldap server is running as process $TARGET_ID.  Stop it first."
      exit 1
    fi
fi

#rbac_pid=$PID_HOME/rbac-center-pid
#if [ -f "$rbac_pid" ]; then
#    TARGET_ID="$(cat "$rbac_pid")"
#    if [[ $(ps -p "$TARGET_ID" -o comm=) =~ "java" ]]; then
#      echo " rbac center is running as process $TARGET_ID.  Stop it first."
#      exit 1
#    fi
#fi



#for i in `find ../lib -name "*.jar" | grep -v RBACPrivilegeCenter.jar`
#do
#  cp=$i:$cp;
#done

#start ldap and rbac manage service
#nohup $JAVA_HOME/bin/java -Dldap.config.dir=$SEC_HOME/conf -cp $cp com.qihoo.xitong.LdapLoginServer 2>&1 1>& $LOG_HOME/ldaploginServer.out &
nohup $JAVA_HOME/bin/java -Dldap.config.dir=$SEC_HOME/conf -Dsecurity.config.port=$SERVER_PORT -cp ../lib/LDAPServer-1.1.0.jar com.qihoo.xitong.LdapLoginServer 2>&1 1>& $LOG_HOME/ldaploginServer.out &
echo $! > $PID_HOME/ldap-rbac-pid

#start rbac center
#nohup $JAVA_HOME/bin/java -cp ../lib/RBACPrivilegeCenter-1.1.0.jar -Dconfig=$SEC_HOME/conf/config.properties net.qihoo.rbac.center.PrivilegeCenter 2>&1 1>& $LOG_HOME/RBACCenter.out &
#echo $! > $PID_HOME/rbac-center-pid
