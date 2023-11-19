#!/bin/bash

echo -e '<VirtualHost *:14000 *:14400>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/rjp.baratayuda.abimanyu.it04
  ServerName rjp.baratayuda.abimanyu.it04.com
  ServerAlias www.rjp.baratayuda.abimanyu.it04.com

  ErrorDocument 404 /error/404.html
  ErrorDocument 403 /error/403.html

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/rjp.baratayuda.abimanyu.it04.com.conf

echo -e '
# kalo pengen ngubah atau nambah port biasanya
# harus mengubah port pada conf ini
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 14000
Listen 14400

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
' > /etc/apache2/ports.conf

a2ensite rjp.baratayuda.abimanyu.it04.com.conf

service apache2 restart

mkdir /var/www/rjp.baratayuda.abimanyu.it04

cd /var/www/rjp.baratayuda.abimanyu.it04

wget https://file.amayuuki.my.id/api/public/dl/qIqnpS5G/data/rjp.baratayuda.zip

unzip -e *.zip

rm *.zip

service apache2 restart