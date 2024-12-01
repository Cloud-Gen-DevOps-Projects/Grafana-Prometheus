#!/bin/bash
#Some Default Packages installing
# Update system packages
echo "Updating system packages..."
sudo yum update -y
echo "Installing Wget Tar Make Unzip Vim Git"
yum install wget vim tar make uzip  -y
hostnamectl set-hostname grafanaserver
echo "Successfully installed Above Packages"

