# Laravel Project Installer

This repository contains a script to automatically set up a Laravel project with SQLite database configuration.

## Features

- Automatic installation of all required dependencies
- SQLite database configuration
- Node.js dependencies and asset compilation
- Production optimizations
- Custom port support
- Interactive server startup

## Requirements

- Debian/Ubuntu-based system
- Sudo privileges

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Make the installation script executable:
```bash
chmod +x install_laravel.sh
```

3. Run the installation script:
```bash
# Basic usage (default port: 51400)
./install_laravel.sh myproject

# With custom port
./install_laravel.sh myproject 8000
```

## What the Script Does

1. Installs system dependencies:
   - PHP 8.2 and required extensions
   - Composer (PHP package manager)
   - Node.js and npm

2. Creates a new Laravel project with:
   - SQLite database configuration
   - Node.js dependencies
   - Built frontend assets
   - Production optimizations

3. Creates a convenient start script

## Starting the Server

After installation, you can start the server:

```bash
cd myproject
./start.sh          # Uses default port (51400)
# or
./start.sh 8000     # Uses custom port
```

## Development

The project uses SQLite for the database, which is stored in `database/database.sqlite`. This makes it easy to get started without setting up a separate database server.

## Production Deployment

Before deploying to production:

1. Review and update `.env` file with production settings
2. Set `APP_ENV=production` and `APP_DEBUG=false`
3. Generate a new application key if needed:
   ```bash
   php artisan key:generate
   ```
4. Ensure proper file permissions
5. Configure your web server to point to the `public` directory