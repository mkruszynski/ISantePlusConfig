#!/bin/bash

echo "Please enter mysql username: "
read root

stty_orig=`stty -g`
echo "Please enter mysql user password: "
stty -echo 
read password
stty $stty_orig

mysql -u$root -p$password -e "DROP DATABASE IF EXISTS openmrs"

mkdir ~/.OpenMRS
cp -a ./openmrs-2.5-modules ~/.OpenMRS/modules
cp ./openmrs.war $CATALINA_HOME/webapps/openmrs.war

# die tomcat
ps aux | grep tomcat | awk '{print $2}' | xargs kill

sleep 2
$CATALINA_HOME/bin/catalina.sh jpda start

tail -F $CATALINA_HOME/logs/catalina.out
