#!/bin/bash

read -p "Enter the Region identifier name : " SERVER_NAME

sudo apt update
sudo apt install ruby-full -y
sudo apt install wget
cd /home/ubuntu

URL="https://aws-codedeploy-${SERVER_NAME}.s3.${SERVER_NAME}.amazonaws.com/latest/install"

wget "$URL"
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status