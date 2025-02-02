# Laravel Project Installer

This repository contains scripts to set up and manage Laravel projects with proper configurations and permissions.

## Features

- Automatic installation and build process
- SQLite database configuration
- Node.js dependencies and asset compilation
- Production optimizations
- Proper permissions management
- Custom port support
- Interactive server startup

## Requirements

- Debian/Ubuntu-based system
- Python 3.x
- Sudo privileges

## Scripts

### 1. Build Script (build.sh)

After cloning your Laravel project, use this script to set up everything:

```bash
./build.sh
```

This script:
- Installs PHP dependencies
- Sets up the environment file
- Generates application key
- Installs Node.js dependencies
- Builds frontend assets

### 2. Permissions Script (permissions.py)

Manages Laravel directory and file permissions:

```bash
sudo python3 permissions.py /path/to/your/laravel/project
```

This script sets:
- Standard directories to 755
- Writable directories to 775
- Files to 644
- Artisan as executable (755)

#### Managed Directories

Standard (755):
- app
- bootstrap
- config
- database
- public
- resources
- routes
- tests

Writable (775):
- storage/app
- storage/app/public
- storage/framework/*
- storage/logs
- bootstrap/cache

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Make scripts executable:
```bash
chmod +x build.sh permissions.py
```

3. Run the build script:
```bash
./build.sh
```

4. Set proper permissions:
```bash
sudo python3 permissions.py /path/to/your/laravel/project
```

## Development

The project uses SQLite for the database, which is stored in `database/database.sqlite`. This makes it easy to get started without setting up a separate database server.

## Production Deployment

Before deploying to production:

1. Run the build script:
```bash
./build.sh
```

2. Set proper permissions:
```bash
sudo python3 permissions.py /path/to/your/project
```

3. Update `.env` file with production settings:
   - Set `APP_ENV=production`
   - Set `APP_DEBUG=false`
   - Configure database settings
   - Set application URL

4. Configure your web server to point to the `public` directory