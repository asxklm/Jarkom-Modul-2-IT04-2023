#!/bin/bash

echo '
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) /index.php/\$1 [L]
' > /var/www/abimanyu.it18/.htaccess

service apache2 restart