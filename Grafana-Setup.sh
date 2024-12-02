#!/bin/bash

# Script to install and configure Grafana on CentOS/RHEL
#Set Hostname
echo "Setting Hostname as Grafana"
hostnamectl set-hostname grafana
# Install default Packages
echo "Installing Vim Wget Tar Make Unzip Git"
yum install vim wget tar make uzip -y


# Add Grafana repository
echo "Adding Grafana repository..."
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=Grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

# Install Grafana
echo "Installing Grafana..."
sudo yum install grafana -y

# Start and enable Grafana service
echo "Starting and enabling Grafana service..."
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Verify Grafana service status
echo "Checking Grafana service status..."
sudo systemctl status grafana-server --no-pager

# Open required firewall port (3000)
echo "Configuring firewall to allow Grafana(port 3000)..."
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# Get server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Display Grafana access information
echo "======================================"
echo "Grafana installation complete!"
echo "Access Grafana at: http://$SERVER_IP:3000"
echo "Default login:"
echo "  Username: admin"
echo "  Password: admin"
echo "======================================"
