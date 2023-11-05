#!/bin/sh
cd /var/www/html

php artisan optimize:clear
php artisan route:clear
php artisan storage:link

rm -rf ./docker-config