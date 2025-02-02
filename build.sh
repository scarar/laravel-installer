#!/bin/bash

# Exit on error
set -e

# Get script location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the real user's home directory when running with sudo
if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    REAL_USER=$SUDO_USER
else
    REAL_HOME=$HOME
    REAL_USER=$(whoami)
fi

# Function to run command as real user
run_as_user() {
    if [ -n "$SUDO_USER" ]; then
        sudo -u "$REAL_USER" "$@"
    else
        "$@"
    fi
}

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

# Check if Laravel project path is provided as argument
if [ $# -eq 1 ]; then
    PROJECT_PATH="$1"
else
    PROJECT_PATH="$SCRIPT_DIR"
fi

# Verify the project path exists
if [ ! -d "$PROJECT_PATH" ]; then
    print_error "Directory not found: $PROJECT_PATH"
fi

# Change to project directory
cd "$PROJECT_PATH" || print_error "Could not change to directory: $PROJECT_PATH"

# Check if we're in a Laravel project directory
if [ ! -f "composer.json" ] || [ ! -f "artisan" ]; then
    print_error "Not a Laravel project directory: $PROJECT_PATH"
fi

# Install PHP dependencies
print_status "Installing PHP dependencies in: $PROJECT_PATH"
run_as_user composer install

# Set up environment file
print_status "Setting up environment file..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        run_as_user cp .env.example .env
        run_as_user php artisan key:generate
    else
        print_error ".env.example file not found"
    fi
fi

# Install Node.js dependencies
print_status "Installing Node.js dependencies..."
if [ -f "package.json" ]; then
    run_as_user npm install
else
    print_error "package.json not found"
fi

# Build frontend assets
print_status "Building frontend assets..."
if [ -f "package.json" ]; then
    run_as_user npm run build
else
    print_error "package.json not found"
fi

print_status "Build completed! You can now configure your web server to point to the public directory."