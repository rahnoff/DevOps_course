#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
echo "Install Java SDK"
apt update
apt install -y default-jdk

echo "Install Docker engine"
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
usermod -aG docker admin
systemctl enable docker
systemctl start docker

echo "Install git"
apt install -y git
