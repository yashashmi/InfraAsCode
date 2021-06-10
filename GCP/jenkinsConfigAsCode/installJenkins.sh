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


curl -O http://localhost:8080/jnlpJars/jenkins-cli.jar

pswd=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$pswd install-plugin configuration-as-code:1.51

sudo systemctl daemon-reload
sudo service jenkins start