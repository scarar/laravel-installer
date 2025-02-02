#!/usr/bin/env python3
import os
import sys
import stat
import subprocess
from pathlib import Path

def set_permissions(directory):
    """Set Laravel directory permissions."""
    try:
        base_dir = Path(directory).resolve()
        if not base_dir.exists():
            print(f"Error: Directory {base_dir} does not exist")
            return False

        print(f"Setting permissions for {base_dir}")

        # Standard directories (755)
        std_dirs = [
            'app', 'bootstrap', 'config', 'database', 'public', 
            'resources', 'routes', 'storage', 'tests'
        ]

        # Writable directories (775)
        writable_dirs = [
            'storage/app',
            'storage/app/public',
            'storage/framework',
            'storage/framework/cache',
            'storage/framework/sessions',
            'storage/framework/views',
            'storage/logs',
            'bootstrap/cache'
        ]

        # Set base directory permissions
        os.chmod(base_dir, 0o755)

        # Set standard directory permissions
        for dir_name in std_dirs:
            dir_path = base_dir / dir_name
            if dir_path.exists():
                print(f"Setting 755 for directory: {dir_name}")
                os.chmod(dir_path, 0o755)

        # Set writable directory permissions
        for dir_name in writable_dirs:
            dir_path = base_dir / dir_name
            if dir_path.exists():
                print(f"Setting 775 for writable directory: {dir_name}")
                os.chmod(dir_path, 0o775)

        # Set file permissions
        for root, dirs, files in os.walk(base_dir):
            root_path = Path(root)

            # Skip vendor and node_modules
            if 'vendor' in root_path.parts or 'node_modules' in root_path.parts:
                continue

            # Set directory permissions
            for d in dirs:
                dir_path = root_path / d
                if any(str(dir_path).endswith(wd) for wd in writable_dirs):
                    os.chmod(dir_path, 0o775)
                else:
                    os.chmod(dir_path, 0o755)

            # Set file permissions
            for f in files:
                file_path = root_path / f
                # Make artisan executable
                if f == 'artisan':
                    print("Setting artisan as executable")
                    os.chmod(file_path, 0o755)
                else:
                    os.chmod(file_path, 0o644)

        print("\nPermissions set successfully!")
        return True

    except Exception as e:
        print(f"Error setting permissions: {str(e)}")
        return False

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 permissions.py /path/to/laravel/project")
        sys.exit(1)

    project_dir = sys.argv[1]
    if not set_permissions(project_dir):
        sys.exit(1)

if __name__ == "__main__":
    main()