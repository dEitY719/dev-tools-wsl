#!/bin/bash

echo "Installing Node.js, npm, and markdownlint-cli..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Update package list
echo "Updating package lists..."
if sudo apt update; then
    echo "Package lists updated successfully."
else
    echo "Failed to update package lists. Exiting."
    exit 1
fi

# Install curl if not present
echo "Checking for curl installation..."
if ! command -v curl &> /dev/null; then
    echo "curl not found. Installing curl..."
    if sudo apt install -y curl; then
        echo "curl installed successfully."
    else
        echo "Failed to install curl. Exiting."
        exit 1
    fi
else
    echo "curl is already installed."
fi

# Add NodeSource Node.js 24.x repository
# You can change '24.x' to your desired Node.js version.
echo "Adding NodeSource Node.js 24.x repository..."
if curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -; then
    echo "NodeSource repository added successfully."
else
    echo "Failed to add NodeSource repository. Exiting."
    exit 1
fi

# Install Node.js and npm
echo "Installing Node.js and npm..."
if sudo apt install -y nodejs; then
    echo "Node.js and npm installed successfully."
else
    echo "Failed to install Node.js and npm. Exiting."
    exit 1
fi

# Verify installation
echo "Verifying Node.js and npm installation..."
node_version=$(node -v)
npm_version=$(npm -v)
echo "Node.js version: $node_version"
echo "npm version: $npm_version"

if [[ -z "$node_version" || -z "$npm_version" ]]; then
    echo "Node.js or npm verification failed. Please check the installation manually."
    exit 1
fi

# Install markdownlint-cli globally
echo "Installing markdownlint-cli globally..."
if sudo npm install -g markdownlint-cli; then
    echo "markdownlint-cli installed successfully."
else
    echo "Failed to install markdownlint-cli. Exiting."
    exit 1
fi

echo "All installations complete."
echo "You can now use 'markdownlint' command."