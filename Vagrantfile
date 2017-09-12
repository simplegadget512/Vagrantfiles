# -*- mode: ruby -*-
# vim: ai ts=4 sts=4 et sw=4 nu ft=ruby

VM_BOX          = "minimal/trusty64"
VM_HOSTNAME     = "blank.vm"
VM_NAME         = VM_HOSTNAME
VM_IP           = "192.168.30.33"
VM_MEMORY       = "1024"

# --==* Touch nothing below this line *==--

Vagrant.configure("2") do |config|
    config.vm.hostname = VM_HOSTNAME
    config.vm.box = VM_BOX
    config.vm.box_check_update = false
    config.vm.network "private_network", ip: VM_IP
    config.vm.synced_folder "./html", "/var/www/html", :mount_options => ["dmode=777", "fmode=777"]

    config.vm.provider "virtualbox" do |vb|
        vb.name = VM_NAME
        vb.memory = VM_MEMORY
    end

    config.vm.provision "shell", inline: <<-SHELL
        apt-get update -y
        apt-get upgrade -y
        apt-get install -y apache2
        a2enmod rewrite
        apt-get install -y php5 php5-sqlite
        cat <<EOT > /etc/apache2/sites-enabled/000-default.conf
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
        service apache2 restart
        apt-get clean
    SHELL
end
