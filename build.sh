#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[1/4] Installing PHP dependencies...${NC}"
composer install

echo -e "${GREEN}[2/4] Setting up environment file...${NC}"
cp .env.example .env
php artisan key:generate

echo -e "${GREEN}[3/4] Installing Node.js dependencies...${NC}"
npm install

echo -e "${GREEN}[4/4] Building frontend assets...${NC}"
npm run build

echo -e "${GREEN}Build completed! You can now configure your web server to point to the public directory.${NC}"