#!/bin/env bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to BigManager/bin
cd $cur

#first stop if ldapservice is alive
#service slapd stop 2>&1 1>& /dev/null
ps  -ef | grep slapd | grep -v grep | grep sbin | awk '{print $2}' | xargs kill 2>&1 1>& /dev/null

#Install expect util program
yum install expect -y

#Install kerberos rpm package
yum install db4 db4-utils db4-devel cyrus-sasl* krb5-server-ldap openldap openldap-servers openldap-clients openldap-devel compat-openldap -y
yum reinstall db4 db4-utils db4-devel cyrus-sasl* krb5-server-ldap openldap openldap-servers openldap-clients openldap-devel compat-openldap -y

if [[ $? -ne 0 ]]; then 
	echo "Yum install failed!"
	exit 123
fi

#Back original slapd.d
if [[ -d /etc/openldap/slapd.d ]];then
     mv  /etc/openldap/slapd.d /etc/openldap/slapd.d.$(date +%s)
fi

#Clear /var/lib/ldap/
rm -rf /var/lib/ldap/*

#Use a example(template file for DB_CONFIG
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

#Chang the ower of ldap
chown -R ldap.ldap /var/lib/ldap

#Copy slapd.conf
if [[ -e /etc/openldap/slapd.conf ]];then
	mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf_$(date +%s)
fi
cp ../resources/slapd.conf /etc/openldap/slapd.conf

#Add syslog conf
lines=$(grep "ldap.log" /etc/rsyslog.conf | wc -l )
if [[ $lines -lt 1 ]];then
	echo "local4.*    /var/log/ldap.log" >> /etc/rsyslog.conf
	touch /var/log/ldap.log
	service rsyslog restart
fi

#Start slapd and add it to start services
chkconfig --add slapd
chkconfig --level 345 slapd on
/etc/init.d/slapd restart
sleep 2

#Check whether the service had been installed correctly
services=$(netstat -tunlp  | grep :389 | wc -l)
if [[ $services -lt 1 ]];then
	echo "Failed to start LDAP !"
	exit 1
else 
#init ldap db info
	ldapadd -x -D "cn=admin,dc=xitong,dc=qihoo,dc=com" -wroot123456 -f ../resources/initldap.ldif
	ldapadd -x -D "cn=admin,dc=xitong,dc=qihoo,dc=com" -wroot123456 -f ../resources/ppolicy.ldif
fi
#restart ldap service
/etc/init.d/slapd restart
sleep 2

##check ldap  init data status
ldapsearch -x -D "cn=admin,dc=xitong,dc=qihoo,dc=com" -wroot123456 -b "cn=default,dc=xitong,dc=qihoo,dc=com" -LLL 2>&1 1>& /dev/null
if [[ $? -gt 0 ]]; then
   echo "Failed to init LDAP !"
   exit 1
fi
