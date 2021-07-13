#!/bin/bash

sudo mkdir -p /shared/jenkins
cd /shared/jenkins


# echo "Jenkins_Password=${jenkinsUser}" >> /shared/jenkins/.env

sudo git clone https://github.com/yashashmi/JenkinsCasC.git

sudo sh -c "echo $(gcloud secrets versions access 1 --secret='JenkinsUser')>/shared/jenkins/JenkinsCasC/secrets/jenkins"
sudo sh -c "echo $(gcloud secrets versions access 1 --secret='JenkinsUser')>/shared/jenkins/JenkinsCasC/secrets/tomcat"
sudo sh -c "echo $(gcloud secrets versions access 1 --secret='GithubUser')>/shared/jenkins/JenkinsCasC/secrets/github"
sudo sh -c 'echo $(gcloud secrets versions access 1 --secret='JenkinsServiceAccountKey' | base64)>/shared/jenkins/JenkinsCasC/secrets/cred'
sudo sh -c 'echo $(gcloud secrets versions access 1 --secret='AppEngineServiceAccountKey' | base64)>/shared/jenkins/JenkinsCasC/secrets/appEngineSecret'
sudo sh -c "echo SONAR_TOKEN=$(gcloud secrets versions access 1 --secret='SONAR_TOKEN')>>/shared/jenkins/.env"



cd JenkinsCasC

sudo docker-compose --env-file /shared/jenkins/.env up -d --build
#sudo docker-compose up -d --build

