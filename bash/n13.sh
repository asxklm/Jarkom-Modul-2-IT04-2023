#!/bin/bash

echo '
nameserver 192.168.122.1
nameserver 192.242.2.4
' > /etc/resolv.conf

echo '
<VirtualHost *:80>
    ServerName parikesit.abimanyu.it04.com
    ServerAlias www.parikesit.abimanyu.it04.com 
    DocumentRoot /var/www/parikesit.abimanyu.it04
    <Directory /var/www/parikesit.abimanyu.it04/public>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>
    <Directory /var/www/parikesit.abimanyu.it04/secret>
        Options -Indexes
        AllowOverride None
        Require all denied
    </Directory>
    ErrorDocument 404 /error/404.html
    ErrorDocument 403 /error/403.html
</VirtualHost>
' > /etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf

mkdir /var/www/parikesit.abimanyu.it04

cd /var/www/parikesit.abimanyu.it04

wget https://drive.google.com/file/d/1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc/view?usp=drive_link

unzip -e *

rm *.zip

chown -R www-data:www-data /var/www/parikesit.abimanyu.it04

a2ensite parikesit.abimanyu.it04.com.conf

service apache2 restart

echo '
#nameserver 192.168.122.1
nameserver 192.242.2.4
' > /etc/resolv.conf