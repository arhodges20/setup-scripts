#!/bin/bash

# No interactives
export DEBIAN_FRONTEND=noninteractive

# Remove console-setup to avoid prompts
info "Removing console-setup to avoid interactive prompts..."
sudo apt-get remove -y console-setup

# Exit on any error
set -e

# Function to display a message
function info {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

info "Starting Kali Linux setup..."

# Step 1: Update and Upgrade the System
info "Updating and upgrading the system..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"
info "System updated."

# Step 2: Install Red-Teaming Tools
info "Installing/updating red-teaming tools..."

# List of common red-teaming tools to install
tools=(
    "metasploit-framework"
    "nmap"
    "burpsuite"
    "responder"
    "sqlmap"
    "john"
    "hashcat"
    "hydra"
    "seclists"
    "gobuster"
    "ffuf"  # Added Ffuf for fuzzing
)

# Install each tool
for tool in "${tools[@]}"; do
    info "Installing/updating $tool..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $tool
done

info "All tools installed and updated."

# Step 3: Install Additional CTF Tools in ~/Desktop/tools
info "Installing additional tools to ~/Desktop/tools..."
mkdir -p ~/Desktop/tools

# LinPEAS
info "Installing LinPEAS..."
git clone https://github.com/carlospolop/PEASS-ng.git ~/Desktop/tools/PEASS-ng

# WinPEAS
info "Installing WinPEAS..."
wget -P ~/Desktop/tools/ https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe
wget -P ~/Desktop/tools/ https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe

# AutoRecon
info "Installing AutoRecon..."
pip install git+https://github.com/Tib3rius/AutoRecon.git

# Additional Cleanup for ~/Desktop/tools
chmod +x ~/Desktop/tools/PEASS-ng/linpeas.sh
chmod +x ~/Desktop/tools/winPEASx64.exe
chmod +x ~/Desktop/tools/winPEASx86.exe

info "Additional tools installed and organized in ~/Desktop/tools."

# Step 4: Create a "Projects" Folder on the Desktop
info "Creating 'Projects' folder on the Desktop..."
mkdir -p ~/Desktop/Projects

# Step 5: Quality of Life Improvements
info "Installing quality-of-life tools..."

# Oh-My-ZSH
info "Installing ZSH and Oh-My-ZSH..."
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Tmux
info "Installing tmux..."
sudo apt-get install -y tmux

# Neovim
info "Installing Neovim..."
sudo apt-get install -y neovim

info "Quality of life tools installed."

# Additional Cleanup
info "Cleaning up unused packages..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Completion Message
info "Setup complete! Your machine is updated, tools are installed, and 'Projects' and 'tools' folders have been created on the Desktop."
info "It's recommended to reboot your system to ensure all services and tools work correctly."
