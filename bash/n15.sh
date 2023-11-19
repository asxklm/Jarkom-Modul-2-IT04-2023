#!/bin/bash

echo -e '<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/parikesit.abimanyu.it04
  ServerName parikesit.abimanyu.it04.com
  ServerAlias www.parikesit.abimanyu.it04.com

  <Directory /var/www/parikesit.abimanyu.it04/public>
          Options +Indexes
  </Directory>

  <Directory /var/www/parikesit.abimanyu.it04/secret>
          Options -Indexes
  </Directory>

  Alias "/public" "/var/www/parikesit.abimanyu.it04/public"
  Alias "/secret" "/var/www/parikesit.abimanyu.it04/secret"

  ErrorDocument 404 /error/404.html
  ErrorDocument 403 /error/403.html

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf

service apache2 restart