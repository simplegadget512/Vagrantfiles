#!/usr/bin/env bash

echo ****************************************
echo Provisioning $1 on $2
echo ****************************************

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2
a2enmod rewrite ssl
debconf-set-selections <<< "mariadb-server mysql-server/root_password password vagrant"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password vagrant"
apt-get -y install mariadb-client
apt-get -y install mariadb-server
mysql -uroot -e "grant all privileges on *.* to vagrant@localhost identified by 'vagrant';"
apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get update -y
apt-get install -y php7.2 libapache2-mod-php php-mysql php-cli php-curl mcrypt php-mcrypt php-gd php-mbstring php-zip php-xml composer npm
cat <<- EOT > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerName $1
    Redirect / https://$1
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/html/public
    <Directory /var/www/html/public >
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

    ErrorLog /var/log/apache2/error.log
    LogLevel warn
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOT
systemctl restart apache2
apt-get upgrade -y
apt-get clean
echo '<?php phpinfo();' > "/var/www/html/public/info.php"
if [ -e /var/www/html/index.html ] ; then rm /var/www/html/index.html ; fi
