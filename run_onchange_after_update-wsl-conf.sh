#!/bin/bash

# This comment line is the magic trigger. Chezmoi calculates the hash of 
# your tracked file. If the file changes, the hash changes, and this script runs!
# wsl-conf-source hash: {{ include ".wsl-conf-source" | sha256sum }}

echo "Updating /etc/wsl.conf..."
sudo cp ~/.wsl-conf-source /etc/wsl.conf
