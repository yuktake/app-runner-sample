#!/bin/bash

# Install Composer
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php
rm composer-setup.php

# Install dependencies
# php composer.phar install

composer --version
yum install php-mbstring php-xml -y
amazon-linux-extras install nginx1 -y
composer install
cp -p .env.example .env
php artisan key:generate

# ディレクトリの権限設定
chown -R :nginx ./storage
chown -R :nginx ./bootstrap/cache
chown -R :nginx ./public

find ./storage -type d -exec chmod 775 {} \;
find ./storage -type f -exec chmod 664 {} \;

find ./bootstrap/cache -type d -exec chmod 775 {} \;
find ./bootstrap/cache -type f -exec chmod 664 {} \;

find ./storage -type d -exec chmod g+s {} \;
find ./bootstrap/cache -type d -exec chmod g+s {} \;

setfacl -R -d -m g::rwx ./storage
setfacl -R -d -m g::rwx ./bootstrap/cache

# アプリケーションのログ出力先を設定
ln -s /dev/stdout /var/log/nginx/error.log
ln -s /dev/stdout /var/log/nginx/access.log

ln -s /dev/stdout /var/log/php-fpm/error.log
ln -s /dev/stdout /var/log/php-fpm/www-access.log
ln -s /dev/stdout /var/log/php-fpm/www-error.log