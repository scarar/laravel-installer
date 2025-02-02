#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}[!] $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Check if project name is provided
if [ -z "$1" ]; then
    print_error "Please provide a project name"
    echo "Usage: $0 <project-name> [port-number]"
    exit 1
fi

PROJECT_NAME=$1
PORT=${2:-51400}  # Default port 51400 if not specified
PROJECT_PATH="/workspace/$PROJECT_NAME"

# Install system dependencies
print_status "Installing system dependencies..."
sudo apt update
sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-sqlite3 php8.2-zip \
    php8.2-gd php8.2-mbstring php8.2-curl php8.2-xml php8.2-bcmath \
    unzip nodejs npm

# Install Composer if not installed
if ! command -v composer &> /dev/null; then
    print_status "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Create Laravel project
print_status "Creating Laravel project: $PROJECT_NAME"
composer create-project laravel/laravel "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Configure SQLite database
print_status "Configuring SQLite database..."
touch database/database.sqlite
sed -i "s/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/" .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=\/workspace\/$PROJECT_NAME\/database\/database.sqlite/" .env
sed -i 's/DB_HOST=127.0.0.1/#DB_HOST=127.0.0.1/' .env
sed -i 's/DB_PORT=3306/#DB_PORT=3306/' .env
sed -i 's/DB_USERNAME=root/#DB_USERNAME=root/' .env
sed -i 's/DB_PASSWORD=/#DB_PASSWORD=/' .env

# Install Node.js dependencies and build assets
print_status "Installing Node.js dependencies and building assets..."
npm install
npm run build

# Run database migrations
print_status "Running database migrations..."
php artisan migrate

# Optimize for production
print_status "Optimizing for production..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create a startup script
print_status "Creating startup script..."
cat > start.sh << 'EOL'
#!/bin/bash
PORT=${1:-51400}
php artisan serve --host=0.0.0.0 --port=$PORT
EOL
chmod +x start.sh

print_status "Installation completed successfully!"
print_status "Your Laravel application is ready at: $PROJECT_PATH"
print_warning "To start the server, run:"
echo "cd $PROJECT_PATH && ./start.sh [port-number]"

# Start the server if requested
read -p "Would you like to start the server now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Starting Laravel development server on port $PORT..."
    ./start.sh "$PORT"
fi