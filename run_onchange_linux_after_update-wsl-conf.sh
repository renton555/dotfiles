#!/bin/bash

# .wsl-conf-source hash: {{ include ".wsl-conf-source" | sha256sum }}

echo "Applying WSL configuration (requires sudo)..."
sudo cp ~/.wsl-conf-source /etc/wsl.conf
echo "Done! Remember to run 'wsl --shutdown' in PowerShell for changes to take effect."
