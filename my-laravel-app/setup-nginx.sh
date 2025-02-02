#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (use sudo)"
fi

# Install PHP-FPM if not installed
print_status "Installing PHP-FPM..."
apt-get install -y php8.2-fpm

# Start PHP-FPM
print_status "Starting PHP-FPM..."
systemctl start php8.2-fpm
systemctl enable php8.2-fpm

# Copy nginx configuration
print_status "Setting up nginx configuration..."
cp nginx.conf /etc/nginx/sites-available/laravel

# Create symbolic link
if [ -L "/etc/nginx/sites-enabled/laravel" ]; then
    rm /etc/nginx/sites-enabled/laravel
fi
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

# Remove default nginx site if it exists
if [ -L "/etc/nginx/sites-enabled/default" ]; then
    rm /etc/nginx/sites-enabled/default
fi

# Test nginx configuration
print_status "Testing nginx configuration..."
nginx -t

# Restart nginx
print_status "Restarting nginx..."
systemctl restart nginx

print_status "Setup complete! Your Laravel application should now be accessible through nginx."