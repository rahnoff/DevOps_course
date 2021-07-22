#!/bin/bash
export DEBIAN_FRONTEND="noninteractive"
apt update
apt install -y apt-transport-https wget gnupg2 curl unzip
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo 'deb https://pkg.jenkins.io/debian binary/' 1>> /etc/apt/sources.list
apt install -y default-jre
apt update
apt install -y jenkins
systemctl enable jenkins

apt install -y git
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown jenkins:jenkins /var/lib/jenkins/init.groovy.d
chown jenkins:jenkins /var/lib/jenkins/init.groovy.d/*
chmod +x /tmp/config/install-plugins.sh
bash /tmp/config/install-plugins.sh
systemctl restart jenkins
