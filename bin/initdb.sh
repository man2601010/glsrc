#!/bin/bash

cur=$(dirname $(readlink -f $0))
cd $cur


function mysql_install {
   yum install -y mysql

}

function mysql_initialize {

        user="tmpsuper"
        password="8lLsFkSi0Pnfgw=="
        #Insert informations into mysql
        mysql -u"$user" -p"$password" -e "CREATE DATABASE IF NOT EXISTS PrivilegeDB DEFAULT CHARSET utf8"
        mysql -u"$user" -p"$password" -e "grant all on PrivilegeDB.* to 'rbac'@'%' identified by 'rbac123456';"
        mysql -u"$user" -p"$password" -e "grant all on PrivilegeDB.* to 'rbac'@'localhost' identified by 'rbac123456';"
        mysql -u"$user" -p"$password" -e "grant all on PrivilegeDB.* to 'rbac'@'localhost' identified by 'rbac123456';"

}

function main {
        #Install mysql client
        mysql_install
        #Initialize mysql
        mysql_initialize
}

main
