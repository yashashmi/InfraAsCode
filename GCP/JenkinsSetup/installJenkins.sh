sudo apt update -y
sudo apt-get install default-jre -y
sudo apt update -y
sudo apt-get install wget -y

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt-get install jenkins -y
sudo apt update -y
sudo service jenkins start
sudo apt install python3-pip -y