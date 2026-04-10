#!/bin/bash
set -e

# FRPC Install Script for Ubuntu 22.04 x86_64
# Usage: ./install.sh

cd "$(dirname "$0")"

echo "=== Installing FRPC ==="

# Stop existing service
sudo systemctl stop frpc 2>/dev/null || true
sudo systemctl disable frpc 2>/dev/null || true

# Copy files
sudo cp frpc /usr/local/bin/
sudo cp frpc.toml /etc/frp/
sudo chmod 644 /etc/frp/frpc.toml

# Create systemd service
sudo tee /etc/systemd/system/frpc.service > /dev/null << SERVICE
[Unit]
Description=FRPC Client
After=network.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.toml
Restart=on-failure
RestartSec=5
User=$USER

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable frpc
sudo systemctl start frpc

echo ""
echo "=== Installation Complete ==="
echo "Status:"
sudo systemctl status frpc --no-pager
echo ""
echo "Access SSH via: ssh -p 7022 xuqi@150.158.17.153"
