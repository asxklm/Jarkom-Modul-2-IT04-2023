#!/bin/bash

apt install apache2 -y
service apache2 start
apt install php -y
apt-get install php -y
service apache2 restart
apt-get install libapache2-mod-php7.0
apt install wget -y
apt install unzip -y

echo '
<VirtualHost *:80>
    ServerName www.abimanyu.it04.com
    DocumentRoot /var/www/abimanyu.it04
    <Directory /var/www/abimanyu.it04>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
' > /etc/apache2/sites-available/abimanyu.it04.com.conf

mkdir /var/www/abimanyu.it04

chown -R www-data:www-data /var/www/abimanyu.it04

cd /var/www/abimanyu.it04

wget https://file.amayuuki.my.id/api/public/dl/Q-OS0azA/data/abimanyu.zip

unzip -e *

rm abimanyu.zip
rm index.html

a2ensite abimanyu.it04.com.conf

a2enmod rewrite

service apache2 restart