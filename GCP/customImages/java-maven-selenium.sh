#!/bin/bash
sudo apt update -y
sudo apt-get install default-jdk -y
sudo apt-get install -y git wget maven unzip
sudo apt update -y

sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add
sudo sh -c 'echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get -y update
sudo apt-get -y install google-chrome-stable
export CHROME_VERSION=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/${CHROME_VERSION}/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
sudo chown root:root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver

sudo mv /etc/maven/settings.xml /etc/maven/settings.xml.bkp
sudo cp /tmp/settings.xml /etc/maven/settings.xml
sudo mkdir -p /shared/maven/repo
sudo chmod 777 /shared/maven/repo
sudo mkdir -p /shared/tmp
cd /shared/tmp
sudo curl -O https://raw.githubusercontent.com/yashashmi/UtilityChargesCalculator/main/pom.xml
mvn dependency:go-offline