
#!/bin/bash

# Wazuh Agent Installation Script for Ubuntu
# Replace the IP below with your Wazuh Manager IP before running.

WAZUH_MANAGER_IP="10.10.1.60"

echo "Updating system..."
sudo apt update -y

echo "Installing dependencies..."
sudo apt install curl apt-transport-https lsb-release gnupg -y

echo "Adding Wazuh GPG key..."
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /usr/share/keyrings/wazuh.gpg

echo "Adding Wazuh repository..."
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

echo "Updating repositories..."
sudo apt update

echo "Installing Wazuh agent..."
sudo WAZUH_MANAGER="$WAZUH_MANAGER_IP" apt install wazuh-agent -y

echo "Starting and enabling Wazuh agent..."
sudo systemctl daemon-reexec
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

echo "Installing auditd (recommended)..."
sudo apt install auditd audispd-plugins -y
sudo systemctl enable auditd
sudo systemctl start auditd

echo "Installation complete."
echo "Check agent status with: sudo systemctl status wazuh-agent"
