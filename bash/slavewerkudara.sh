#!/bin/bash

#dns router
echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

# Update package list
apt-get update

# Install BIND9
apt-get install bind9 -y

mkdir /etc/bind/delegasi

cp /etc/bind/db.local /etc/bind/delegasi/baratayuda.abimanyu.it04.com

echo 'zone "arjuna.it04.com" {
    type slave;
    masters { 192.235.1.3; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/arjuna.it04.com";
};

zone "abimanyu.it04.com" {
    type slave;
    masters { 192.235.1.3; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/abimanyu.it04.com";
};

zone "baratayuda.abimanyu.it04.com" {
    type master;
    file "/etc/bind/delegasi/baratayuda.abimanyu.it04.com";
};' > /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
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
' > /etc/bind/delegasi/baratayuda.abimanyu.it04.com

echo "
options {
	directory \"/var/cache/bind\";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the addresses replacing 
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







