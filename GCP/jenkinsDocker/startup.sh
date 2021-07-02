#!/bin/bash
sudo apt update -y
sudo apt-get install default-jre -y
sudo apt update -y
sudo apt-get install wget -y

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo mkdir -p /shared/jenkins
cd /shared/jenkins


# echo "Jenkins_Password=${jenkinsUser}" >> /shared/jenkins/.env

sudo git clone https://github.com/yashashmi/JenkinsCasC.git

sudo sh -c "echo $(gcloud secrets versions access 1 --secret='JenkinsUser')>/shared/jenkins/JenkinsCasC/secrets/jenkins"
sudo sh -c "echo $(gcloud secrets versions access 1 --secret='JenkinsUser')>/shared/jenkins/JenkinsCasC/secrets/tomcat"
sudo sh -c "echo $(gcloud secrets versions access 1 --secret='GithubUser')>/shared/jenkins/JenkinsCasC/secrets/github"
sudo sh -c 'echo $(gcloud secrets versions access 1 --secret='JenkinsServiceAccountKey' | base64)>/shared/jenkins/JenkinsCasC/secrets/cred'
sudo sh -c "echo SONAR_TOKEN=$(gcloud secrets versions access 1 --secret='SONAR_TOKEN')>>/shared/jenkins/.env"



cd JenkinsCasC

sudo docker-compose --env-file /shared/jenkins/.env up -d --build
#sudo docker-compose up -d --build

