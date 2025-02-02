#!/bin/bash

# Exit on error
set -e

# Get the real user's home directory when running with sudo
if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME=$HOME
fi

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print status
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}[!] $1${NC}"
    exit 1
}

# Check if we're in a Laravel project directory
if [ ! -f "composer.json" ] || [ ! -f "artisan" ]; then
    print_error "This script must be run from the root of a Laravel project"
fi

# Install PHP dependencies
print_status "Installing PHP dependencies..."
if [ -n "$SUDO_USER" ]; then
    sudo -u "$SUDO_USER" composer install
else
    composer install
fi

# Set up environment file
print_status "Setting up environment file..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        if [ -n "$SUDO_USER" ]; then
            sudo -u "$SUDO_USER" php artisan key:generate
        else
            php artisan key:generate
        fi
    else
        print_error ".env.example file not found"
    fi
fi

# Install Node.js dependencies
print_status "Installing Node.js dependencies..."
if [ -n "$SUDO_USER" ]; then
    sudo -u "$SUDO_USER" npm install
else
    npm install
fi

# Build frontend assets
print_status "Building frontend assets..."
if [ -n "$SUDO_USER" ]; then
    sudo -u "$SUDO_USER" npm run build
else
    npm run build
fi

print_status "Build completed! You can now configure your web server to point to the public directory."