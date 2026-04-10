#!/bin/bash
cd "$(dirname "$0")"
sudo systemctl daemon-reload
sudo systemctl enable frpc
sudo systemctl start frpc
sudo systemctl status frpc --no-pager
