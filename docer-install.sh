#!/bin/bash

set -e

echo "=============================="
echo "Updating package list..."
echo "=============================="
sudo apt update

echo "=============================="
echo "Installing Docker..."
echo "=============================="
sudo apt install -y docker.io

echo "=============================="
echo "Starting Docker service..."
echo "=============================="
sudo systemctl start docker
sudo systemctl enable docker

echo "=============================="
echo "Creating Docker group (if needed)..."
echo "=============================="
sudo groupadd docker 2>/dev/null || true

echo "=============================="
echo "Adding current user to Docker group..."
echo "=============================="
sudo usermod -aG docker $USER

echo "=============================="
echo "Docker Version"
echo "=============================="
docker --version || sudo docker --version

echo "=============================="
echo "Docker Status"
echo "=============================="
sudo systemctl status docker --no-pager

echo "=============================="
echo "Installation Complete!"
echo "=============================="
echo "Please log out and log back in, or run:"
echo "newgrp docker"
echo ""
echo "Then test Docker with:"
echo "docker run hello-world"
