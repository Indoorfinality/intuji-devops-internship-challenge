#!/bin/bash

# Update the system and install dependencies
echo "Updating package lists and installing required packages..."
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository for Docker
echo "Setting up Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
echo "Installing Docker..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker service and enable it
echo "Starting Docker service and enabling it to start on boot..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Check Docker service status
echo "Checking Docker service status..."
sudo systemctl status docker || {
    echo "Docker service failed to start. Checking logs..."
    sudo journalctl -xeu docker.service
    echo "Attempting to restart Docker service..."
    sudo systemctl restart docker
    echo "Re-checking Docker service status..."
    sudo systemctl status docker
    exit 1
}

# Optional: check Docker logs if the service fails to start
echo "Checking Docker logs for errors..."
sudo journalctl -xeu docker.service

# Ensure kernel modules are loaded
echo "Loading necessary kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

echo "Docker installation complete!"
