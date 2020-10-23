#!/usr/bin/env bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y

sudo service jenkins stop
sudo cp --backup /etc/default/jenkins /etc/default/jenkins.bak
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8040/' /etc/default/jenkins
sudo chown jenkins:jenkins /home/vagrant/jenkinsHome/
sudo cp -prv /var/lib/jenkins/ /home/vagrant/jenkinsHome/
sudo usermod -d /home/vagrant/jenkinsHome/ jenkins
sudo sed -i 's+JENKINS_HOME=/var/lib/$NAME+JENKINS_HOME=/home/vagrant/jenkinsHome/+' /etc/default/jenkins
sudo service jenkins start
