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

# Function to check if a command exists
function command_exists {
    command -v "$1" &> /dev/null
}

# Function to check if a file exists
function file_exists {
    [[ -f "$1" ]]
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
    if ! command_exists "$tool"; then
        info "Installing/updating $tool..."
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $tool
    else
        info "$tool is already installed. Skipping..."
    fi
done

info "All tools installed and updated."

# Step 3: Install Additional CTF Tools in ~/Desktop/tools
info "Installing additional tools to ~/Desktop/tools..."
mkdir -p ~/Desktop/tools

# LinPEAS
if [ ! -d ~/Desktop/tools/PEASS-ng ]; then
    info "Installing LinPEAS..."
    git clone https://github.com/carlospolop/PEASS-ng.git ~/Desktop/tools/PEASS-ng
else
    info "LinPEAS is already installed. Skipping..."
fi

# WinPEAS
if ! file_exists ~/Desktop/tools/winPEASx64.exe; then
    info "Installing WinPEAS..."
    wget -P ~/Desktop/tools/ https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe
    wget -P ~/Desktop/tools/ https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe
else
    info "WinPEAS is already installed. Skipping..."
fi

# AutoRecon Installation with Virtual Environment
info "Installing AutoRecon..."

# Ensure python3-venv is installed
if ! dpkg -s python3-venv &> /dev/null; then
    info "Installing python3-venv..."
    sudo apt-get install -y python3-venv
else
    info "python3-venv is already installed. Skipping..."
fi

# Create the virtual environment for AutoRecon
if [ ! -d ~/Desktop/tools/autorecon-venv ]; then
    info "Creating virtual environment for AutoRecon..."
    python3 -m venv ~/Desktop/tools/autorecon-venv
    source ~/Desktop/tools/autorecon-venv/bin/activate
    pip install git+https://github.com/Tib3rius/AutoRecon.git
    deactivate
    info "AutoRecon installed in ~/Desktop/tools/autorecon-venv."
else
    info "AutoRecon virtual environment already exists. Skipping..."
fi

# Additional Cleanup for ~/Desktop/tools
chmod +x ~/Desktop/tools/PEASS-ng/linpeas.sh || true
chmod +x ~/Desktop/tools/winPEASx64.exe || true
chmod +x ~/Desktop/tools/winPEASx86.exe || true

info "Additional tools installed and organized in ~/Desktop/tools."

# Step 4: Create a "Projects" Folder on the Desktop
info "Creating 'Projects' folder on the Desktop..."
mkdir -p ~/Desktop/Projects

# Step 5: Quality of Life Improvements
info "Installing quality-of-life tools..."

# Oh-My-ZSH
if ! command_exists "zsh"; then
    info "Installing ZSH and Oh-My-ZSH..."
    sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    info "ZSH is already installed. Skipping..."
fi

# Tmux
if ! command_exists "tmux"; then
    info "Installing tmux..."
    sudo apt-get install -y tmux
else
    info "Tmux is already installed. Skipping..."
fi

# Neovim
if ! command_exists "nvim"; then
    info "Installing Neovim..."
    sudo apt-get install -y neovim
else
    info "Neovim is already installed. Skipping..."
fi

info "Quality of life tools installed."

# Additional Cleanup
info "Cleaning up unused packages..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Completion Message
info "Setup complete! Your machine is updated, tools are installed, and 'Projects' and 'tools' folders have been created on the Desktop."
info "It's recommended to reboot your system to ensure all services and tools work correctly."
