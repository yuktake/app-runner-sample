#!/usr/bin/env bash

echo "post build"

php artisan config:clear
php artisan migrate