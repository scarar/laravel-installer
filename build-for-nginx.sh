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

# Check if we're in a Laravel project directory
if [ ! -f "composer.json" ] || [ ! -f "artisan" ]; then
    print_error "Please run this script from your Laravel project directory"
fi

# Install PHP dependencies
print_status "Installing PHP dependencies..."
composer install --no-dev

# Install Node.js dependencies
print_status "Installing Node.js dependencies..."
npm install

# Build frontend assets
print_status "Building frontend assets..."
npm run build

# Set up environment if needed
if [ ! -f ".env" ]; then
    print_status "Setting up environment..."
    cp .env.example .env
    php artisan key:generate
fi

# Optimize for production
print_status "Optimizing for production..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

print_status "Build completed! Your Laravel application is ready for nginx."
print_status "Make sure your nginx configuration points to the 'public' directory."