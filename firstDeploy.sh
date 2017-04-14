#!/bin/bash

echo "Please enter mysql username: "
read root

stty_orig=`stty -g`
echo "Please enter mysql user password: "
stty -echo 
read password
stty $stty_orig

mysql -u$root -p$password -e "DROP DATABASE IF EXISTS openmrs"
mysql -u$root -p$password -e "CREATE DATABASE openmrs"
mysql -u$root -p$password "openmrs" < ./openmrs_dump.sql

mkdir ~/.OpenMRS
mkdir ~/.OpenMRS/isanteplus
cp -a ./openmrs-2.5-modules ~/.OpenMRS/isanteplus/modules
cp ./openmrs-runtime.properties ~/.OpenMRS/isanteplus/openmrs-runtime.properties
cp ./openmrs.war $CATALINA_HOME/webapps/isanteplus.war

sed -i "s/username=/username=$root/" ~/.OpenMRS/isanteplus/openmrs-runtime.properties
sed -i "s/password=/password=$password/" ~/.OpenMRS/isanteplus/openmrs-runtime.properties

# die tomcat
ps aux | grep tomcat | awk '{print $2}' | xargs kill

sleep 2
$CATALINA_HOME/bin/catalina.sh jpda start
