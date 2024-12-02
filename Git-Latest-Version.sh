# Git Latest Version Installation
#!/bin/bash

# Exit script on any error
set -e

# Variables
GIT_VERSION="2.47.1"
GIT_URL="https://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz"
INSTALL_DIR="/usr/local"

# Install dependencies
echo "Installing dependencies..."
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y gcc gcc-c++ make wget tar perl-CPAN curl-devel expat-devel gettext-devel openssl-devel zlib-devel

# Download Git source
echo "Downloading Git $GIT_VERSION..."
wget -O /tmp/git.tar.gz $GIT_URL

# Extract the tarball
echo "Extracting Git source..."
tar -xzf /tmp/git.tar.gz -C /tmp

# Build and install Git
echo "Building and installing Git..."
cd /tmp/git-$GIT_VERSION
make prefix=$INSTALL_DIR all
sudo make prefix=$INSTALL_DIR install

# Add Git to PATH in ~/.bashrc
echo "Adding Git to PATH in ~/.bashrc..."
if ! grep -q "export PATH=$INSTALL_DIR/bin:\$PATH" ~/.bashrc; then
    echo "export PATH=$INSTALL_DIR/bin:\$PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# Verify Git installation
echo "Verifying Git installation..."
if git --version | grep -q "$GIT_VERSION"; then
    echo "Git $GIT_VERSION installed successfully!"
else
    echo "Git installation failed!"
    exit 1
fi

# Clean up
echo "Cleaning up temporary files..."
rm -rf /tmp/git.tar.gz /tmp/git-$GIT_VERSION

echo "Script completed successfully!"
