sudo apt update -y
sudo apt-get install default-jre -y
sudo apt-get install default-jdk -y
sudo apt update -y
sudo apt-get install wget -y

sudo groupadd tomcat

sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp

curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.66/bin/apache-tomcat-8.5.66.tar.gz

sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8.5.66.tar.gz -C /opt/tomcat --strip-components=1


cd /opt/tomcat

sudo chgrp -R tomcat /opt/tomcat


sudo chmod -R g+r conf
sudo chmod g+x conf

sudo chown -R tomcat webapps/ work/ temp/ logs/