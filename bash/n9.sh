#!/bin/bash

apt-get update
apt-get install nginx -y
service nginx start

echo '
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    upstream nodes_lb {
        server 10.78.2.2:8003;
        server 10.78.2.3:8001;
        server 10.78.2.4:8002;
    }

    server {
        listen 80;
        listen [::]:80;

        server_name arjuna.it04.com;

        location / {
            proxy_pass http://nodes_lb;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}' > /etc/nginx/nginx.conf

service nginx restart