# -*- mode: ruby -*-
# vim: ai ts=4 sts=4 et sw=4 nu ft=ruby

VM_HOSTNAME     = "mesh-dev.vm"

VM_BOX          = "bento/ubuntu-16.04-i386"
VM_OS           = "ubuntu"

# --==* You shouldn't need to adjust these much *==--

VM_NAME         = VM_HOSTNAME
VM_IP           = "192.168.30.6"
VM_MEMORY       = "1024"

# --==* Touch nothing below this line *==--

Vagrant.configure("2") do |config|
    config.vm.hostname = VM_HOSTNAME
    config.vm.box = VM_BOX
    config.vm.box_check_update = false
    config.vm.network "private_network", ip: VM_IP
    config.vm.synced_folder ".", "/var/www/html", :mount_options => ["dmode=777", "fmode=777"]

    config.vm.provider "virtualbox" do |vb|
        vb.name = VM_NAME
        vb.memory = VM_MEMORY
    end

    config.vm.provision :shell, path: "bin/#{VM_OS}.sh", :args=>[VM_HOSTNAME, VM_OS]

end
