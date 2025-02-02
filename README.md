# Laravel Project Installer

This repository contains scripts to set up and manage Laravel projects with proper configurations and permissions. The scripts are designed to work correctly with both regular and sudo execution.

## Features

- Automatic installation and build process
- Safe sudo execution handling
- Proper user permissions management
- Node.js installation via nvm
- SQLite database configuration
- Production optimizations
- Custom port support

## Requirements

- Debian/Ubuntu-based system
- Python 3.x
- Sudo privileges

## Scripts

### 1. Build Script (build.sh)

This script sets up an existing Laravel project. Run it from your Laravel project root:

```bash
# If running as regular user
./build.sh

# If running as sudo (maintains correct permissions)
sudo ./build.sh
```

The script:
- Verifies Laravel project structure
- Installs PHP dependencies with correct user
- Sets up the environment file
- Generates application key
- Installs Node.js dependencies via nvm
- Builds frontend assets
- Maintains proper file ownership

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

## Installation and Usage

### For a New Laravel Project

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Make scripts executable:
```bash
chmod +x install_laravel.sh build.sh permissions.py
```

3. Create a new Laravel project:
```bash
./install_laravel.sh myproject
```

### For an Existing Laravel Project

1. Copy the scripts to your Laravel project:
```bash
cp /path/to/build.sh /path/to/permissions.py /your/laravel/project/
chmod +x build.sh permissions.py
```

2. Run the build script:
```bash
# Option 1: Run from the Laravel project directory
cd /your/laravel/project
sudo ./build.sh

# Option 2: Specify the Laravel project path as an argument
sudo ./build.sh /path/to/your/laravel/project
```

3. Set proper permissions:
```bash
sudo python3 permissions.py /your/laravel/project
```

### Common Issues

1. **Sudo Permission Issues**: The scripts handle sudo execution correctly, maintaining proper file ownership and permissions.

2. **Node.js/npm Issues**: The build script uses nvm (Node Version Manager) to avoid package conflicts.

3. **File Permission Problems**: Run the permissions.py script after setup to ensure correct permissions.

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