#!/bin/bash
PORT=${1:-51400}
php artisan serve --host=0.0.0.0 --port=$PORT
