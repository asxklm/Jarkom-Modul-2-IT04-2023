#!/bin/bash

#dns router
echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

# Update package list
apt-get update

# Install BIND9
apt-get install bind9 -y

# Create the directory for zone files
mkdir /etc/bind/jarkom

# Copy the default zone file to the new zone file location
cp /etc/bind/db.local /etc/bind/jarkom/for.arjuna.com

cp /etc/bind/db.local /etc/bind/jarkom/for.abimanyu.com

cp /etc/bind/db.127 /etc/bind/jarkom/rev.abimanyu.com

# Create the BIND configuration for the "arjuna.it04.com" zone
echo 'zone "arjuna.it04.com" {
    type master;
    allow-transfer { 192.235.1.2; };
    file "/etc/bind/jarkom/for.arjuna.com";
};

zone "abimanyu.it04.com" {
    type master;
    allow-transfer { 192.235.1.2; }; // Masukan IP Water7 tanpa tanda petik
    file "/etc/bind/jarkom/for.abimanyu.com";
};

zone "1.235.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/rev.abimanyu.com";
};
' > /etc/bind/named.conf.local

# echo 'zone "abimanyu.it04.com" {
#     type master;
#     allow-transfer { 192.235.1.2; }; // Masukan IP Water7 tanpa tanda petik
#     file "/etc/bind/jarkom/for.abimanyu.com";
# };' >> /etc/bind/named.conf.local

# echo 'zone "1.235.192.in-addr.arpa" {
#     type master;
#     allow-transfer { 192.235.1.2; };
#     file "/etc/bind/jarkom/rev.abimanyu.com";
# };
# ' >> /etc/bind/named.conf.local



# Edit the newly created zone file
echo ';
; BIND data file for local loopback interface
;
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
' > /etc/bind/jarkom/for.arjuna.com

echo ';
; BIND data file for local loopback interface
;
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
ns1     IN      A       192.235.1.3
baratayuda  IN  NS      ns1
@       IN      AAAA    ::1
' > /etc/bind/jarkom/for.abimanyu.com

echo ';
; BIND data file for local loopback interface
;
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
' > /etc/bind/jarkom/rev.abimanyu.com

echo "
options {
	directory \"/var/cache/bind\";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP s for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the s replacing 
	// the all-0's placeholder.

	forwarders {
		192.168.122.1;
	};

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	//dnssec-validation auto;
	allow-query{any;};


	listen-on-v6 { any; };
};" > /etc/bind/named.conf.options


service bind9 restart




