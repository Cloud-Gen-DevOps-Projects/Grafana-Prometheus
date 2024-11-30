[200~#!/bin/bash

# Step 1: Create a directory for Node Exporter
echo "Creating directory for Node Exporter..."
sudo mkdir -p /opt/node_exporter

# Step 2: Navigate to the Node Exporter directory
cd /opt/node_exporter

# Step 3: Download Node Exporter v1.8.2 for AMD64
echo "Downloading Node Exporter v1.8.2..."
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

# Step 4: Extract the tar file
echo "Extracting the downloaded tar file..."
tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz

# Step 5: Move the binary to /usr/local/bin
echo "Moving Node Exporter binary to /usr/local/bin..."
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/

# Step 6: Remove the extracted folder and tar file (cleanup)
echo "Cleaning up extracted files..."
rm -rf node_exporter-1.8.2.linux-amd64*
rm -f node_exporter-1.8.2.linux-amd64.tar.gz

# Step 7: Create a system user for running Node Exporter
echo "Creating system user for Node Exporter..."
sudo useradd --no-create-home --shell /bin/false node_exporter

# Step 8: Create a systemd service file for Node Exporter
echo "Creating systemd service file for Node Exporter..."
echo "[Unit]
Description=Node Exporter
Documentation=https://github.com/prometheus/node_exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/node_exporter.service

# Step 9: Reload the systemd daemon to recognize the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Step 10: Enable and start the Node Exporter service
echo "Enabling and starting Node Exporter service..."
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Step 11: Check the status of the Node Exporter service
echo "Checking Node Exporter service status..."
sudo systemctl status node_exporter --no-pager

# Step 12: Open port 9100 (default Node Exporter port) on firewall if needed
echo "Configuring firewall to allow Node Exporter (port 9100)..."
sudo firewall-cmd --zone=public --add-port=9100/tcp --permanent
sudo firewall-cmd --reload

# Step 13: Display Node Exporter access information
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "======================================"
echo "Node Exporter installation complete!"
echo "Access Node Exporter at: http://$SERVER_IP:9100"
echo "======================================"


