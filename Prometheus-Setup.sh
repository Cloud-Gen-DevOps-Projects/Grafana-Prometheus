
#!/bin/bash
#Install default Packages 

# Step 1: Download Prometheus for AMD64 architecture
echo "Downloading Prometheus version 3.0.0 for AMD64..."
wget https://github.com/prometheus/prometheus/releases/download/v3.0.0/prometheus-3.0.0.linux-amd64.tar.gz

# Step 2: Extract the downloaded tarball
echo "Extracting Prometheus tarball..."
tar -xvzf prometheus-3.0.0.linux-amd64.tar.gz

# Step 3: Change directory to the extracted folder
cd prometheus-3.0.0.linux-amd64

# Step 4: Move Prometheus binaries to /usr/local/bin
echo "Moving Prometheus binaries to /usr/local/bin..."
sudo mv prometheus promtool /usr/local/bin/

# Step 5: Create Prometheus user and directories
echo "Creating Prometheus user and directories..."
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir -p /var/lib/prometheus
sudo mkdir -p /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus

# Step 6: Copy Prometheus configuration file to /etc/prometheus
echo "Copying Prometheus configuration..."
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Step 7: Create Prometheus systemd service file
echo "Creating Prometheus systemd service file..."
echo "[Unit]
Description=Prometheus
After=network.target

[Service]
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/data
User=prometheus
Group=prometheus
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

# Step 8: Reload systemd to recognize the Prometheus service
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Step 9: Enable and start Prometheus service
echo "Enabling and starting Prometheus service..."
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Step 10: Open Prometheus port (9090) in the firewall
echo "Configuring firewall to allow Prometheus (port 9090)..."
sudo firewall-cmd --permanent --add-port=9090/tcp
sudo firewall-cmd --reload

# Step 11: Check Prometheus service status
echo "Checking Prometheus service status..."
sudo systemctl status prometheus --no-pager

# Step 12: Display Prometheus access information
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "======================================"
echo "Prometheus installation complete!"
echo "Access Prometheus at: http://$SERVER_IP:9090"
echo "======================================"

