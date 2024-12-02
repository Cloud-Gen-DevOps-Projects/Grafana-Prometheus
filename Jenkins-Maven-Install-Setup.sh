#Jenkins & Maven Installation 

#!/bin/bash

# Exit script on any error
set -e

# Set hostname
echo "Setting hostname to 'jenkinsserver'..."
sudo hostnamectl set-hostname jenkinsserver

# Install required packages
echo "Installing vim, wget, tar, make, unzip, git..."
sudo dnf install -y vim wget tar make unzip git

# Download and extract Maven
echo "Downloading and extracting Maven..."
MAVEN_URL="https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
MAVEN_DIR="/opt/maven"
sudo wget -O /tmp/apache-maven.tar.gz $MAVEN_URL
sudo tar -xzf /tmp/apache-maven.tar.gz -C /opt/
sudo mv /opt/apache-maven-3.9.9 $MAVEN_DIR
rm -f /tmp/apache-maven.tar.gz

# Set paths in ~/.bashrc
echo "Setting up environment variables in ~/.bashrc..."
cat <<EOL >> ~/.bashrc

# Maven environment variables
export PATH=$MAVEN_DIR/bin:\$PATH

# Git and Java already in path (ensure correct Java version installed)
EOL
source ~/.bashrc

# Install Jenkins key and repository
echo "Adding Jenkins repository and key..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key

# Install Jenkins
echo "Installing Jenkins..."
sudo dnf install -y jenkins

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins service status
echo "Checking Jenkins service status..."
sudo systemctl status jenkins --no-pager

# Display overall status
if sudo systemctl is-active --quiet jenkins; then
    echo "Jenkins is successfully installed and running!"
else
    echo "Jenkins installation or service failed. Check logs for details."
    exit 1
fi

echo "Script completed successfully!"
