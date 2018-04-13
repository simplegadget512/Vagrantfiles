#!/usr/bin/env bash

yum update -y --exclude=kernel
yum install -y httpd
chkconfig --add httpd
chkconfig httpd on
#debconf-set-selections <<< "mariadb-server mysql-server/root_password password vagrant"
#debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password vagrant"
yum -y install mariadb-client
yum -y install mariadb-server
mysql -uroot -e "grant all privileges on *.* to vagrant@localhost identified by 'vagrant';"
yum install -y php libapache2-mod-php php-mysql php-cli php-curl mcrypt php-mcrypt php-gd php-mbstring
if [ ! -d "/etc/httpd/sites-enabled" ] ; then mkdir -p /etc/httpd/sites-enabled ; fi
cat <<- EOT > /etc/httpd/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/html
    <Directory /var/www/html >
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/error.log
    LogLevel warn
    CustomLog /var/log/httpd/access.log combined
</VirtualHost>
EOT
echo 'IncludeOptional sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf
systemctl start httpd.service
yum clean
echo '<?php phpinfo();' > "/var/www/html/info.php"
if [ -e /var/www/html/index.html ] ; then rm /var/www/html/index.html ; fi
