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
sudo usermod -aG docker "$USER"

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
echo "Applying the new 'docker' group to THIS session (no logout needed)..."
echo ""

# 'sg docker' runs the given command in a subshell with the docker group
# active, so you don't need to log out/in or run 'newgrp' manually.
# We use it here to verify docker works right away without root.
sg docker -c "docker run hello-world"

echo "=============================="
echo "Docker is fully installed and working without root!"
echo "=============================="
echo "Note: this fix applies to commands run via 'sg docker -c \"...\"'"
echo "or a NEW terminal/SSH session from now on. This current shell"
echo "process itself still needs 'newgrp docker' or a re-login for"
echo "plain 'docker ...' commands (without sg) to work without sudo."
