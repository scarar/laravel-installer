# Laravel Project Installer

This repository contains scripts to set up, build, and manage Laravel projects with proper configurations and permissions. The scripts handle common issues like permission problems, npm conflicts, and provide clear error messages.

## Features

- Automatic installation and build process
- Safe sudo execution handling
- Proper user permissions management
- Flexible project path handling
- Clear error messages and troubleshooting
- Node.js/npm permission fixes
- SQLite database configuration
- Production optimizations
- Executable permission management
- Multiple execution options

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
# Option 1: From the Laravel project directory
cd /your/laravel/project
sudo ./build.sh

# Option 2: From the installer directory
sudo ./build.sh /path/to/laravel/project

# Option 3: Using full paths
sudo /path/to/build.sh /path/to/laravel/project

# Example:
# If your Laravel project is in a subdirectory of the installer
sudo ./build.sh my-laravel-app
```

The build script will:
- Install PHP dependencies with correct permissions
- Set up the environment file if needed
- Install Node.js dependencies
- Ensure proper executable permissions
- Build frontend assets

3. Set proper permissions:
```bash
sudo python3 permissions.py /your/laravel/project
```

### Troubleshooting

1. **Wrong Directory Error**
```
[!] Not a Laravel project directory: /path/to/directory
```
Solution: Make sure you're pointing to the correct Laravel project directory. If using the installer directory, specify the Laravel project subdirectory:
```bash
sudo ./build.sh my-laravel-app
```

2. **Permission Denied for npm/vite**
```
sh: 1: vite: Permission denied
```
Solution: The script will automatically fix this by making node_modules/.bin executables accessible. If you still see this error, run:
```bash
sudo chmod +x /path/to/project/node_modules/.bin/*
```

3. **Composer Root Warning**
```
Do not run Composer as root/super user!
```
Solution: This is a warning, not an error. The script handles permissions correctly, so you can safely continue.

4. **Node.js/npm Issues**
The build script handles npm installations with correct permissions. If you see any npm errors:
- Make sure Node.js is installed
- Try clearing npm cache: `npm cache clean --force`
- Remove node_modules and try again: `rm -rf node_modules`

5. **File Permission Problems**
After building, if you see permission issues in your web server logs:
```bash
sudo python3 permissions.py /path/to/laravel/project
```

## Development

The project uses SQLite for the database, which is stored in `database/database.sqlite`. This makes it easy to get started without setting up a separate database server.

## Production Deployment

### Option 1: Standard Build
```bash
./build.sh
```

### Option 2: Nginx Production Build
For nginx deployment, use the specialized build script:

```bash
# Copy build script to your Laravel project
cp build-for-nginx.sh /path/to/your/laravel/project/

# Run from your Laravel project directory
cd /path/to/your/laravel/project
./build-for-nginx.sh
```

The nginx build script will:
- Install production PHP dependencies only
- Install and compile frontend assets
- Generate application key if needed
- Optimize Laravel for production
- Cache configurations, routes, and views

### Post-Build Steps

1. Set proper permissions:
```bash
sudo python3 permissions.py /path/to/your/project
```

2. Update `.env` file with production settings:
   - Set `APP_ENV=production`
   - Set `APP_DEBUG=false`
   - Configure database settings
   - Set application URL

3. Configure nginx:
   - Point root to the `public` directory
   - Example path: `/usr/share/nginx/your-app/public`

### Verifying the Build

Check compiled assets in `public/build/`:
```bash
ls -l public/build/assets/
```

You should see:
- Compiled CSS (*.css)
- Compiled JavaScript (*.js)
- Asset manifest (manifest.json)