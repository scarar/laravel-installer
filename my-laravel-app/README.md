# Laravel Blog with Tor Integration

A Laravel-based blog application with user authentication, SQLite database, and Tor network integration. This application allows users to create, read, update, and delete blog posts while also providing access to .onion sites through the Tor network.

## Features

- User authentication (register, login, logout)
- Blog post management (CRUD operations)
- Authorization (users can only edit/delete their own posts)
- SQLite database for data storage
- Tor network integration for accessing .onion sites
- Responsive UI using Tailwind CSS

## Requirements

- PHP 8.2 or higher
- Node.js and npm
- Composer
- SQLite3
- Tor service

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd my-laravel-app
```

2. Install PHP dependencies:
```bash
composer install
```

3. Install and build frontend dependencies:
```bash
npm install
npm run build
```

4. Set up environment:
```bash
cp .env.example .env
php artisan key:generate
```

5. Create SQLite database:
```bash
touch database/database.sqlite
```

6. Run migrations:
```bash
php artisan migrate
```

7. Install and start Tor service:
```bash
sudo apt-get install -y tor
sudo service tor start
```

## Production Deployment

1. Configure your web server (e.g., Nginx) to point to the `/public` directory.

2. Example Nginx configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/my-laravel-app/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

3. Set appropriate permissions:
```bash
sudo chown -R www-data:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache
```

4. Configure environment variables in `.env`:
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com
```

5. Optimize Laravel:
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## Usage

### Blog Features
- Register a new account or login with existing credentials
- Create new blog posts from the dashboard
- Edit or delete your own posts
- View all posts on the home page
- Read individual posts with full content

### Tor Integration
Access .onion sites through the `/test-tor` endpoint. The application uses the Tor network to proxy requests to .onion domains.

## Security Considerations

1. Always use HTTPS in production
2. Keep PHP, Laravel, and all dependencies up to date
3. Configure proper file permissions
4. Use strong passwords and secure session management
5. Enable CSRF protection (already included in Laravel)
6. Consider implementing rate limiting for the Tor proxy endpoint

## License

[MIT License](LICENSE.md)
