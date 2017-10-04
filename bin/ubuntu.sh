#!/usr/bin/env bash

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2
a2enmod rewrite
debconf-set-selections <<< "mariadb-server mysql-server/root_password password vagrant"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password vagrant"
apt-get -y install mariadb-client
apt-get -y install mariadb-server
mysql -uroot -e "grant all privileges on *.* to vagrant@localhost identified by 'vagrant';"
apt-get install -y php libapache2-mod-php php-mysql php-cli php-curl mcrypt php-mcrypt php-gd php-mbstring
cat <<- EOT > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/html
    <Directory /var/www/html >
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    LogLevel warn
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOT
systemctl restart apache2
apt-get clean
echo '<?php phpinfo();' > "/var/www/html/info.php"
if [ -e /var/www/html/index.html ] ; then rm /var/www/html/index.html ; fi
