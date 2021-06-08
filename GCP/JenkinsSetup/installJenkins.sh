sudo apt update -y
sudo apt-get install default-jre -y
sudo apt update -y
sudo apt-get install wget -y

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt-get install jenkins=2.289.1 -y
sudo apt update -y

sudo service jenkins stop

sudo cp --backup /etc/default/jenkins /etc/default/jenkins.bak
sudo mkdir /home/jenkins
gsutil -m rsync -r gs://my-second-project-314314-jen1/jenkins/  /home/jenkins/
#sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8040/' /etc/default/jenkins

sudo chown -R jenkins:jenkins /home/jenkins

#To copy all files from default Jenkins home path to new path.
#However this shouldn't ever be required because we always want to redirect to new home path.
#sudo cp -prv /var/lib/jenkins /home/jenkins 

#sudo usermod -d /home/jenkins/ jenkins
sudo sed -i 's+JENKINS_HOME=/var/lib/$NAME+JENKINS_HOME=/home/jenkins/+' /etc/default/jenkins

sudo service jenkins start