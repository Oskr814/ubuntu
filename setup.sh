#!/bin/bash

# Upgrade packages
apt-get update && apt-get upgrade -y

# Docker installation
read -p "Do you want to install Docker? (y/n): " install_docker
if [ "$install_docker" == "y" ]; then
    echo "Installing Docker"
    # Docker installation
    # Add Docker's official GPG key:
    apt-get install ca-certificates curl -y
    install -m 0755 -d /etc/apt/keyrings -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
else
    echo "Skipping Docker installation."
fi

# Snap 
read -p "Do you want to install apps using Snap? (y/n): " install_snap
if [ "$install_snap" == "y" ]; then
    echo "Installing apps using Snap"
    snap install code --classic
    snap install slack discord dbeaver-ce
else
    echo "Skipping Snap installation."
fi

export MY_SETUP=~/.my-setup 
rm -rf $MY_SETUP
mkdir $MY_SETUP

# Install Chrome
read -p "Do you want to install Google Chrome? (y/n): " install_chrome
if [ "$install_chrome" == "y" ]; then
    echo "Installing Google Chrome"
    wget -P $MY_SETUP https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt-get install $MY_SETUP/google-chrome-stable_current_amd64.deb
else
    echo "Skipping Google Chrome installation."
fi

# Configure Zsh
read -p "Do you want to configure Zsh? (y/n): " configure_zsh
if [ "$configure_zsh" == "y" ]; then
    bash ./zsh.sh
else
    echo "Skipping Zsh configuration."
fi

# Node version manager
read -p "Do you want to install Volta? (y/n): " install_volta
if [ "$install_volta" == "y" ]; then
    echo "Installing Volta"
    curl https://get.volta.sh | bash
else
    echo "Skipping Volta installation."
fi

# Setup SSH keys
read -p "Do you want to setup SSH keys? (y/n): " setup_ssh
if [ "$setup_ssh" == "y" ]; then
    bash ./ssh.sh
else
    echo "Skipping SSH key setup."
fi

# Clean up
rm -rf $MY_SETUP