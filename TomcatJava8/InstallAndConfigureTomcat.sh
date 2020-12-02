#!/usr/bin/env bash

sudo groupadd tomcat

sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp

curl -O https://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz

sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8.5.60.tar.gz -C /opt/tomcat --strip-components=1


cd /opt/tomcat

sudo chgrp -R tomcat /opt/tomcat


sudo chmod -R g+r conf
sudo chmod g+x conf


sudo chown -R tomcat webapps/ work/ temp/ logs/

sudo su; su tomcat

cp /home/vagrant/tomcat/tomcat-users.xml /opt/tomcat/conf/
cp /home/vagrant/tomcat/manager/context.xml /opt/tomcat/webapps/manager/META-INF/
cp /home/vagrant/tomcat/host-manager/context.xml /opt/tomcat/webapps/host-manager/META-INF/


sudo cp /home/vagrant/tomcat/tomcat.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat
sudo ufw allow 8080


