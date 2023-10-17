# Jarkom Modul 2 IT04 2023
- Kevin Putra Santoso (5027211030)
- Bagus Cahyo Arrasyid (5027211033)
## Soal 1
> Yudhistira akan digunakan sebagai DNS Master, Werkudara sebagai DNS Slave, Arjuna merupakan Load Balancer yang terdiri dari beberapa Web Server yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Buatlah topologi dengan pembagian sebagai berikut. Folder topologi dapat diakses pada drive berikut.
### Topologi
![Screenshot 2023-10-17 190103](https://github.com/asxklm/Jarkom-Modul-2-IT04-2023/assets/113827418/1d198bb9-b576-433b-a429-5b21c25e7c3c)

### Network Configuration
#### Router
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.235.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.235.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.235.3.1
	netmask 255.255.255.0
```
#### Arjuna (Load Balancer)
```
auto eth0
iface eth0 inet static
	address 192.235.3.5
	netmask 255.255.255.0
	gateway 192.235.3.1
```
#### Yudhistira (DNS Master Server)
```
auto eth0
iface eth0 inet static
	address 192.235.1.3
	netmask 255.255.255.0
	gateway 192.235.1.1
```
#### Werkudara (DNS Slave Server)
```
auto eth0
iface eth0 inet static
	address 192.235.1.2
	netmask 255.255.255.0
	gateway 192.235.1.1
```
#### Abimanyu (Web Servers)
```
auto eth0
iface eth0 inet static
	address 192.235.3.2
	netmask 255.255.255.0
	gateway 192.235.3.1
```
#### Prabukusuma (Web Server)
```
auto eth0
iface eth0 inet static
	address 192.235.3.3
	netmask 255.255.255.0
	gateway 192.235.3.1
```
#### Wisanggeni (Web Server)
```
auto eth0
iface eth0 inet static
	address 192.235.3.4
	netmask 255.255.255.0
	gateway 192.235.3.1
```
#### Sadewa (Client)
```
auto eth0
iface eth0 inet static
	address 192.235.2.3
	netmask 255.255.255.0
	gateway 192.235.2.1
```
#### Nakula (Client)
```
auto eth0
iface eth0 inet static
	address 192.235.2.2
	netmask 255.255.255.0
	gateway 192.235.2.1
```
### Enable Internet Access
Agar setiap node dalam jaringan dapat mengakses internet melalui NAT, maka digunakan command berikut pada Router:
```bash
# enable all nodes to access internet
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.235.0.0/16
```
Selain itu, juga diperlukan untuk men-set nameserver pada setiap node dengan menggunakan bash script seperti berikut:
```bash
# define the nameserver for internet access
nameserver="192.168.122.1"
```
## Soal 2
> Buatlah website utama pada node arjuna dengan akses ke arjuna.yyy.com dengan alias www.arjuna.yyy.com dengan yyy merupakan kode kelompok.
### Setup DNS for arjuna.it04.com (Yudhistira)
1. Install depedencies
```bash
# Update package list
apt-get update

# Install BIND9
apt-get install bind9 -y
```
2. Start bind9
```bash
service bind9 start
```
2. Membuat direktori zone dan copy default zone untuk diedit
```
mkdir /etc/bind/jarkom

cp /etc/bind/db.local /etc/bind/jarkom/for.arjuna.com
cp /etc/bind/db.local /etc/bind/jarkom/for.abimanyu.com
cp /etc/bind/db.127 /etc/bind/jarkom/rev.abimanyu.com
```
3. Pada file `/etc/bind/named.local.conf` tambahkan line berikut:
```
zone "arjuna.it04.com" {
    type master;
    allow-transfer { 192.235.1.3; };
    file "/etc/bind/jarkom/for.arjuna.com";
};
```
4. Buat DNS recordnya pada `/etc/bind/jarkom/for.arjuna.com`:
```
$TTL    604800
@       IN      SOA     arjuna.it04.com. root.arjuna.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      arjuna.it04.com.
@       IN      A       192.235.3.5
www     IN      CNAME   arjuna.it04.com.
```
5. Restart bind9 service
```
service bind9 restart
```
## Soal 3
> Dengan cara yang sama seperti soal nomor 2, buatlah website utama dengan akses ke abimanyu.yyy.com dan alias www.abimanyu.yyy.com.
### Setup DNS for abimanyu.it04.com (Yudhistira)
1. Pada file `/etc/bind/named.local.conf` tambahkan line berikut:
```
zone "abimanyu.it04.com" {
    type master;
    allow-transfer { 192.235.1.3; }; 
    file "/etc/bind/jarkom/for.abimanyu.com";
};
```
2. Buat DNS recordnya pada `/etc/bind/jarkom/for.abimanyu.com`.
```
$TTL    604800
@       IN      SOA     abimanyu.it04.com. root.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      abimanyu.it04.com.
@       IN      A       192.235.3.2
www     IN      CNAME   abimanyu.it04.com.
@       IN      AAAA    ::1
```
3. Restart bind9 service
```
service bind9 restart
```
## Soal 4
> Kemudian, karena terdapat beberapa web yang harus di-deploy, buatlah subdomain parikesit.abimanyu.yyy.com yang diatur DNS-nya di Yudhistira dan mengarah ke Abimanyu.
### Setup DNS for parikesit.abimanyu.it04.com (Yudhistira)
1. Pada file `/etc/bind/named.local.conf` tambahkan line berikut:
```
zone "abimanyu.it04.com" {
    type master;
    allow-transfer { 192.235.1.3; }; 
    file "/etc/bind/jarkom/for.abimanyu.com";
};
```
2. Buat DNS recordnya pada file `/etc/bind/jarkom/for.abimanyu.com`.
```
$TTL    604800
@       IN      SOA     abimanyu.it04.com. root.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      abimanyu.it04.com.
@       IN      A       192.235.3.2
www     IN      CNAME   abimanyu.it04.com.
parikesit   IN  A       192.235.3.2
@       IN      AAAA    ::1
```
3. Restart bind9 service
```
service bind9 restart
```
## Soal 5
> Buat juga reverse domain untuk domain utama. (Abimanyu saja yang direverse)
### Setup Reverse DNS for abimanyu.it04.com (Yudhistira)
1. Pada file `/etc/bind/named.conf.local` tambahkan line berikut:
```
zone "1.235.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/rev.abimanyu.com";
};
```
2. Buat DNS recordnya pada file `/etc/bind/jarkom/rev.abimanyu.com`.
```
$TTL    604800
@       IN      SOA     abimanyu.it04.com. root.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
1.235.192.in-addr.arpa         IN      NS      abimanyu.it04.com.
2                            IN      PTR     abimanyu.it04.com.
```
3. Restart bind9 service
```
service bind9 restart
```
## Soal 6
> Agar dapat tetap dihubungi ketika DNS Server Yudhistira bermasalah, buat juga Werkudara sebagai DNS Slave untuk domain utama.
### Setup DNS for arjuna.it04.com & abimanyu.i049.com on DNS Master (Yudhistira)
1. Edit konfigurasi zone arjuna.it04.com & abimanyu.it04.com pada file `/etc/bind/named.local.conf` sehingga menjadi seperti berikut. 
```
zone "arjuna.it04.com" {
    type master;
    allow-transfer { 192.235.1.2; };
    file "/etc/bind/jarkom/for.arjuna.com";
};

zone "abimanyu.it04.com" {
    type master;
    allow-transfer { 192.235.1.2; }; 
    file "/etc/bind/jarkom/for.abimanyu.com";
};
```
2. Restart bind9 service
```
service bind9 restart
```
### Setup DNS for arjuna.it04.com & abimanyu.it04.com on DNS Slave (Werkudara)
1. Install depedencies
```
# Update package list
apt-get update

# Install BIND9
apt-get install bind9 -y
```
2. Start bind9 service
```
service bind9 start
```
3. Membuat direktori dan copy konfigurasi
```
mkdir /etc/bind/delegasi

cp /etc/bind/db.local /etc/bind/delegasi/baratayuda.abimanyu.it04.com
```
4. Pada file `/etc/bind/named.local.conf` tambahkan line berikut:
```
zone "arjuna.it04.com" {
    type slave;
    masters { 192.235.1.3; }; 
    file "/var/lib/bind/arjuna.it04.com";
};

zone "abimanyu.it04.com" {
    type slave;
    masters { 192.235.1.3; }; 
    file "/var/lib/bind/abimanyu.it04.com";
};
```
5. Berikut adalah DNS record untuk domain arjuna.it04.com pada file `/etc/bind/jarkom/for.arjuna.com`.
```
$TTL    604800
@       IN      SOA     arjuna.it04.com. root.arjuna.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      arjuna.it04.com.
@       IN      A       192.235.3.5
www     IN      CNAME   arjuna.it04.com. 
```
5. Restart bind9 service
```
service bind9 restart
```
## Soal 7
> Seperti yang kita tahu karena banyak sekali informasi yang harus diterima, buatlah subdomain khusus untuk perang yaitu baratayuda.abimanyu.yyy.com dengan alias www.baratayuda.abimanyu.yyy.com yang didelegasikan dari Yudhistira ke Werkudara dengan IP menuju ke Abimanyu dalam folder Baratayuda.
### Setup DNS for baratayuda.abimanyu.it04.com on DNS Master (Yudhistira)
1. Edit file `/etc/bind/jarkom/for.abimanyu.com` seperti berikut:
```
$TTL    604800
@       IN      SOA     abimanyu.it04.com. root.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      abimanyu.it04.com.
@       IN      A       192.235.3.2
www     IN      CNAME   abimanyu.it04.com.
ns1     IN      A       192.235.1.3
baratayuda  IN  NS      ns1
```
2. Restart bind9 service
```
service bind9 restart
```
### Setup DNS for baratayuda.abimanyu.it04.com on DNS Slave (Werkudara)
1. Pada file `/etc/bind/named.local.conf` tambahkan line seperti berikut:
```
zone "baratayuda.abimanyu.it04.com" {
    type master;
    file "/etc/bind/delegasi/baratayuda.abimanyu.it04.com";
};
```
2. Buat DNS record pada file `/etc/bind/delegasi/baratayuda.abimanyu.it04.com`.
```
$TTL    604800
@       IN      SOA     baratayuda.abimanyu.it04.com. root.baratayuda.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      baratayuda.abimanyu.it04.com.
@       IN      A       192.235.3.2
www     IN      A       192.235.3.2
```
3. Restart bind9 service
```
service bind9 restart
```
## Soal 8
> Untuk informasi yang lebih spesifik mengenai Ranjapan Baratayuda, buatlah subdomain melalui Werkudara dengan akses rjp.baratayuda.abimanyu.yyy.com dengan alias www.rjp.baratayuda.abimanyu.yyy.com yang mengarah ke Abimanyu.
### Setup DNS for rjp.baratayuda.abimanyu.it04.com on DNS Slave (Werkudara)
1. Pada file `/etc/bind/named.local.conf` tambahkan line seperti berikut:
```
zone "baratayuda.abimanyu.it04.com" {
    type master;
    file "/etc/bind/delegasi/rjp.baratayuda.abimanyu.it04.com";
};
```
2. Buat DNS recordnya pada file `/etc/bind/delegasi/baratayuda.abimanyu.it04.com`.
```
$TTL    604800
@       IN      SOA     baratayuda.abimanyu.it04.com. root.baratayuda.abimanyu.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      baratayuda.abimanyu.it04.com.
@       IN      A       192.235.3.2
www     IN      A       192.235.3.2
rjp     IN      A       192.235.3.2
```
3. Restart bind9 service
```
service bind9 restart
```
## Soal 9 & Soal 10
> Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker (yang juga menggunakan nginx sebagai webserver) yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.
### Setup Load Balancer & Worker
1. Install depedencies
```
# install dependencies
apt-get update
apt-get install nginx -y
service nginx start
```
2. Buat Konfigurasi port pada file `/etc/nginx/sites-available/default` masing-masing worker.
- Prabukusuma
```
server {
	 listen 8001;
	 server_name prabukusuma;
	    # Konfigurasi situs web Abimanyu default nya
	 root /var/www/html;
	 # Add index.php to the list if you are using PHP
        index index.html index.htm;
	location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
```
- Abimanyu
```
server {
	 listen 8002;
	 server_name prabukusuma;
	    # Konfigurasi situs web Abimanyu default nya
	 root /var/www/html;
	 # Add index.php to the list if you are using PHP
        index index.html index.htm;
	location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
```
- Wisanggeni
```
server {
	 listen 8003;
	 server_name prabukusuma;
	    # Konfigurasi situs web Abimanyu default nya
	 root /var/www/html;
	 # Add index.php to the list if you are using PHP
        index index.html index.htm;
	location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
```
3. Restart nginx dan cek service
```
service nginx restart 

nginx -t
```
## Soal 11
> Selain menggunakan Nginx, lakukan konfigurasi Apache Web Server pada worker Abimanyu dengan web server www.abimanyu.yyy.com. Pertama dibutuhkan web server dengan DocumentRoot pada /var/www/abimanyu.yyy
### Setup web server for abimanyu.it04.com (Abimanyu)
1. Install depedencies
```bash
apt install apache2 -y
service apache2 start
apt install php -y
apt-get install php -y
service apache2 restart
apt-get install libapache2-mod-php7.0
apt install wget -y
apt install unzip -y
```
2. Buat konfigurasi web server pada file `/etc/apache2/sites-available/abimanyu.it04.com.conf`
```
<VirtualHost *:80>
    ServerName www.abimanyu.it04.com
    DocumentRoot /var/www/abimanyu.it04
    <Directory /var/www/abimanyu.it04>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```
4. Enable konfigurasi abimanyu.it04.com.conf dengan command berikut:
```bash
a2ensite abimanyu.it04.com.conf
```
5. Deployment resource
```bash
mkdir /var/www/abimanyu.it04

chown -R www-data:www-data /var/www/abimanyu.it04

cd /var/www/abimanyu.it04

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc" -O abimanyu.yyy.com.zip

unzip -e *

rm abimanyu.zip
rm index.html
```
6. Start Apache2 service
```bash
service apache2 start
```
## Soal 12
> Setelah itu ubahlah agar url www.abimanyu.yyy.com/index.php/home menjadi www.abimanyu.yyy.com/home.
### Change /home to /index.php/home (Abimanyu)
1. Enable module rewrite pada apache2
```
# activate rewrite module
a2enmod rewrite

# restart apache2
service apache2 restart
```
2. Buat file `/var/www/abimanyu.it04/.htaccess` dengan isi sebagai berikut:
```
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) /index.php/\$1 [L]
```
## Soal 13
> Selain itu, pada subdomain www.parikesit.abimanyu.yyy.com, DocumentRoot disimpan pada /var/www/parikesit.abimanyu.yyy
### Setup web server for parikesit.abimanyu.it04.com (Abimanyu)
1. Buat konfigurasi web server pada file `/etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf`
```
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
```
2. Enable konfigurasi abimanyu.it04.com.conf dengan command berikut:
```bash
a2ensite parikesit.abimanyu.it04.com.conf
```
3. Deployment resource
```bash
mkdir /var/www/parikesit.abimanyu.it04

chown -R www-data:www-data /var/www/parikesit.abimanyu.it04

cd /var/www/parikesit.abimanyu.it04

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc" -O parikesit.abimanyu.yyy.com.zip

unzip -e *

rm *.zip
```
4. Restart Apache2 service
```bash
service apache2 restart
```
## Soal 14
> Pada subdomain tersebut folder /public hanya dapat melakukan directory listing sedangkan pada folder /secret tidak dapat diakses (403 Forbidden).
### Set Forbidden Rule for /secret directory (Abimanyu)
1. Buat konfigurasi web server pada file `/etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf`
```
<VirtualHost *:80>
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

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
2. Restart Apache2 service
```bash
service apache2 restart
```
## Soal 15
> Buatlah kustomisasi halaman error pada folder /error untuk mengganti error kode pada Apache. Error kode yang perlu diganti adalah 404 Not Found dan 403 Forbidden.
### Set Forbidden Rule for /secret directory (Abimanyu)
1. Buat konfigurasi web server pada file `/etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf`
```
<VirtualHost *:80>
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
</VirtualHost>
```
2. Restart Apache2 service
```bash
service apache2 restart
```
## Soal 16
> Buatlah suatu konfigurasi virtual host agar file asset www.parikesit.abimanyu.yyy.com/public/js menjadi www.parikesit.abimanyu.yyy.com/js 
### Set Path Rule for /public directory (Abimanyu)
1. Buat konfigurasi web server pada file `/etc/apache2/sites-available/parikesit.abimanyu.it04.com.conf`
```
<VirtualHost *:80>
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
  Alias "/js" "/var/www/parikesit.abimanyu.it04/public/js"

  ErrorDocument 404 /error/404.html
  ErrorDocument 403 /error/403.html

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
2. Restart Apache2 service
```bash
service apache2 restart
```
