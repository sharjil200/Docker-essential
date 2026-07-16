#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
# Docker Engine + Docker Compose Plugin Installation Script
# Target: Ubuntu 20.04 / 22.04 / 24.04
# ==============================================================

echo "==> Updating system package list..."
sudo apt update

echo "==> Removing old/conflicting Docker packages (if any)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

echo "==> Updating package index and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

echo "==> Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> Adding Docker apt repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Updating package index with Docker repo..."
sudo apt-get update

echo "==> Installing Docker Engine, CLI, containerd, buildx, and compose plugin..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "==> Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "==> Adding current user ($USER) to docker group (run without sudo)..."
sudo usermod -aG docker "$USER"

echo "==> Verifying installation..."
docker --version
docker compose version

echo ""
echo "=============================================================="
echo " Docker installation complete."
echo " NOTE: Log out and back in (or run 'newgrp docker') for the"
echo " docker group membership to take effect without sudo."
echo "=============================================================="
echo ""
echo "Testing Docker with hello-world image..."
sudo docker run hello-world
