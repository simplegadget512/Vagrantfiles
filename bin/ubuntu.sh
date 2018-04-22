#!/usr/bin/env bash

stars=$(printf '%*s' 60 '')

echo "${stars// /*}"
echo Provisioning $1 with $2 using $3
echo "${stars// /*}"

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2
a2enmod rewrite ssl
debconf-set-selections <<< "$3-server mysql-server/root_password password vagrant"
debconf-set-selections <<< "$3-server mysql-server/root_password_again password vagrant"
apt-get -y install "$3-client"
apt-get -y install "$3-server"
mysql -uroot -e "grant all privileges on *.* to vagrant@localhost identified by 'vagrant';"

echo "${stars// /*}"
echo Installing PHP 7.2
echo "${stars// /*}"

apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get update -y
apt-get install -y php7.2 libapache2-mod-php php-mysql php-cli php-curl mcrypt php-mcrypt php-gd php-mbstring php-zip php-xml composer

echo "${stars// /*}"
echo Installing PhpMyAdmin
echo "${stars// /*}"

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password vagrant"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password vagrant"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password vagrant"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
apt-get install -y phpmyadmin

echo "${stars// /*}"
echo Installing npm and dependencies
echo "${stars// /*}"

apt-get install -y npm

cat <<- EOT > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerName $1
    Redirect / https://$1
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/html
    <Directory /var/www/html >
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

if [ -d /var/www/html ]; then
    echo '<?php phpinfo();' > "/var/www/html/info.php"
fi

if [ -e /var/www/html/index.html ] ; then rm /var/www/html/index.html ; fi
