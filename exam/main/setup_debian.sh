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
mv /tmp/id_rsa /var/lib/jenkins/.ssh
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
chmod 600 /var/lib/jenkins/.ssh/id_rsa

mkdir /var/lib/jenkins/init.groovy.d
mv /tmp/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
rm -r /var/lib/jenkins/plugins
chmod +x /tmp/install-plugins.sh
bash /tmp/install-plugins.sh
chown -R jenkins:jenkins /var/lib/jenkins
systemctl restart jenkins
