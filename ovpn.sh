#!/bin/bash

sudo su
sudo apt-get update
cd /root
sudo wget https://git.io/vpn -O openvpn-install.sh

sudo bash /root/openvpn-install.sh << EOF
hostname
1
1194
3
client
EOF

sudo apt-get install apache2 -y
sudo sed -i "s#</VirtualHost>#AccessFileName .htaccess \n<Directory "/var/www/html"> \nOptions FollowSymLinks \nAllowOverride All \nRequire all granted \n</Directory> \n</VirtualHost>#" /etc/apache2/sites-available/000-default.conf


public_ip=`wget -qO- https://ipecho.net/plain ; echo`
echo -e "Redirect 302 /config http://$public_ip/client.ovpn \nAddType application/octect-stream .ovpn" > /var/www/html/.htaccess

sudo cp /root/client.ovpn /var/www/html/client.ovpn 