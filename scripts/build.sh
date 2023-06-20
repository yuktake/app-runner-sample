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

composer --version
yum install php-mbstring php-xml wget tar -y
amazon-linux-extras install nginx1 -y
php composer.phar install
cp -p .env.example .env
php artisan key:generate

# ディレクトリの権限設定
chown -R :nginx ./storage
chown -R :nginx ./bootstrap/cache
chown -R :nginx ./public

chmod -R 777 ./storage

find ./bootstrap/cache -type d -exec chmod 775 {} \;
find ./bootstrap/cache -type f -exec chmod 664 {} \;

find ./bootstrap/cache -type d -exec chmod g+s {} \;

setfacl -R -d -m g::rwx ./bootstrap/cache

cd ../
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpmyadmin
tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpmyadmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz

mkdir /app/public/phpmyadmin
ln -s ./phpmyadmin ./app/public/phpmyadmin