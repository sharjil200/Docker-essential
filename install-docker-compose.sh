#!/usr/bin/env bash
set -euo pipefail

echo "==> Removing old/conflicting packages (if any)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "==> Updating apt and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

echo "==> Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Installing Docker Engine, CLI, containerd, and Compose plugin..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Verifying installation..."
docker --version
docker compose version

echo "==> Adding current user to docker group (run without sudo)..."
sudo usermod -aG docker "$USER"

echo "==> Installing standalone docker-compose binary..."
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo ""
echo "Docker + Docker Compose installed successfully."
echo "Log out and back in (or run 'newgrp docker') for group changes to take effect."
