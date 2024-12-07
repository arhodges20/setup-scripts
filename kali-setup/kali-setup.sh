#!/bin/bash

#No interactives
export DEBIAN_FRONTEND=noninteractive

# Exit on any error
set -e

# Function to display a message
function info {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

info "Starting Kali Linux setup..."

# Step 1: Update and Upgrade the System
info "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
info "System updated."

# Step 2: Install Red-Teaming Tools
info "Installing/updating red-teaming tools..."

# List of common red-teaming tools to install
tools=(
    "metasploit-framework"
    "nmap"
    "burpsuite"
    "impacket-scripts"
    "responder"
    "sqlmap"
    "john"
    "hashcat"
    "hydra"
    "evil-winrm"
    "seclists"
    "gobuster"
    "crackmapexec"
    "bloodhound"
    "neo4j"
)

# Install each tool
for tool in "${tools[@]}"; do
    info "Installing/updating $tool..."
    sudo apt install -y $tool
done

# Enable Neo4j for BloodHound
info "Enabling Neo4j service..."
sudo systemctl enable neo4j
sudo systemctl start neo4j

info "All tools installed and updated."

# Step 3: Create a "Projects" Folder on the Desktop
info "Creating 'Projects' folder on the Desktop..."
mkdir -p ~/Desktop/Projects

# Completion Message
info "Setup complete! Your machine is updated, tools are installed, and 'Projects' folder has been created on the Desktop."
info "It's recommended to reboot your system to ensure all services and tools work correctly."
