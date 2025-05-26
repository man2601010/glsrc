#!/bin/env bash

#Get current directory (print working directory)
cur=$( dirname $( readlink -f $0))

#Change directory to BigManager/bin
cd $cur


#Install kerberos rpm package
yum install -y krb5-server krb5-libs krb5-workstation
# in case we already install krb5 server 
yum reinstall -y krb5-server krb5-libs krb5-workstation

if [[ $? -ne 0 ]]; then 
	echo "Yum install failed!"
	exit 123
fi

#Copy configuration files of kerberos to the right place ( files include kdc.conf krb5.conf kadm5.acl )
if [[ -e /var/kerberos/krb5kdc/kdc.conf ]];then
	mv /var/kerberos/krb5kdc/kdc.conf /var/kerberos/krb5kdc/kdc.conf_$(date +%s)
fi
cp ../resources/kdc.conf /var/kerberos/krb5kdc/kdc.conf

if [[ -e /var/kerberos/krb5kdc/kadm5.acl ]];then
	mv /var/kerberos/krb5kdc/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl_$(date +%s)
fi
cp ../resources/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl

if [[ -e /etc/krb5.conf ]];then
	mv /etc/krb5.conf /etc/krb5.conf_$(date +%s)
fi
cp ../resources/krb5.conf /etc/krb5.conf

hostname=$(hostname -f)
sed -i "s/{hostname}/$hostname/g" /etc/krb5.conf

#Copy initial principal of kerberos
cp ../resources/principal/* /var/kerberos/krb5kdc/
cp ../resources/principal/.k5.HADOOP.COM /var/kerberos/krb5kdc/

#Start kadmin & krb5kdc
service krb5kdc restart
service kadmin restart

#Copy local file krb5.conf to client and replace it
#ansible -i ../conf/hostlist all -s -m shell -a "test -f /etc/krb5.conf && mv /etc/krb5.conf /etc/krb5.conf_$(date +%s)"
#ansible -i ../conf/hostlist all -m copy -a "src=/etc/krb5.conf dest=/tmp/"
#ansible -i ../conf/hostlist all -s -m shell -a "mv -f /tmp/krb5.conf /etc/"


