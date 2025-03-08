#!/bin/sh
set -e

# Create storage and bootstrap/cache directories if they don't exist
mkdir -p /var/www/html/storage
mkdir -p /var/www/html/bootstrap/cache

# Set proper permissions
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

exec "$@"
