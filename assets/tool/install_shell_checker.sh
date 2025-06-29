#!/bin/bash

# shellcheck disable=SC2154,SC1090,SC1091
# SC2154: 'os_release' is referenced but not assigned. This script is for apt-based systems only.
# SC1090, SC1091: Not sourcing files, so these warnings are irrelevant here.

echo "Installing essential shell checker tools: shellcheck and shfmt..."

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

# Install shellcheck and shfmt
echo "Installing shellcheck and shfmt..."
if sudo apt install -y shellcheck shfmt; then
    echo "shellcheck and shfmt installed successfully."
else
    echo "Failed to install shellcheck and shfmt. Please check your internet connection or package sources."
    exit 1
fi

echo "Installation complete."
echo "You can now use 'shellcheck' and 'shfmt' to lint and format your shell scripts."