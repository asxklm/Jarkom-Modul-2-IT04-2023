#!/bin/bash

apt-get update -y
apt-get install nginx unzip php7.2-fpm lsb-release ca-certificates apt-transport-https software-properties-common -y

# Prabukusuma
echo '
server {
    listen 8001;
    listen [::]:8001;

    root /var/www/arjuna.it04.com;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name arjuna.it04.com;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}' > /etc/nginx/sites-available/arjuna.it04.com

# Wisanggeni
echo '
server {
    listen 8003;
    listen [::]:8003;

    root /var/www/arjuna.it04.com;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name arjuna.it04.com;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}' > /etc/nginx/sites-available/arjuna.it04.com

# Abimanyu
echo '
server {
    listen 8002;
    listen [::]:8002;

    root /var/www/arjuna.it04.com;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name arjuna.it04.com;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}' > /etc/nginx/sites-available/arjuna.it04.com

ln -s /etc/nginx/sites-available/arjuna.it04.com /etc/nginx/sites-enabled/arjuna.it04.com

# create directory for arjuna.it04.com
mkdir -p /var/www/arjuna.it04.com

# wget dist.zip
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=17tAM_XDKYWDvF-JJix1x7txvTBEax7vX' -O /tmp/dist.zip

# unzip dist.zip
unzip /tmp/dist.zip -d /tmp

# move dist to /var/www/arjuna.it04.com
mv /tmp/arjuna.yyy.com/index.php /var/www/arjuna.it04.com/index.php

# start php
service php7.2-fpm start

# start nginx
service nginx start