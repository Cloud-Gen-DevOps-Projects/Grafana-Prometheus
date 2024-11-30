#!/bin/bash
#Some Default Packages installing
# Update system packages
echo "Updating system packages..."
sudo yum update -y
echo "Installing Wget Tar Make Unzip Vim Git"
yum install wgt vim tar make uzip git -y
hostnamectl set-hostname grafaserver
yum install wget vim tar make unzip git -y

echo "Successfully installed Above Packages"

