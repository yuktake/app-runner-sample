#!/usr/bin/env bash

php artisan config:clear
php artisan migrate

cd ../
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin
tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1

set -o monitor

trap exit SIGCHLD

# Start nginx 
nginx -g 'daemon off;' &

# Start php-fpm
php-fpm -F &

wait