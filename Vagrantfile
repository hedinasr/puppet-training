# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "puppetlabs/centos-7.2-64-puppet"

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
  end

  config.vm.box = "centos/7"
  config.vm.hostname = "dev.puppet.vm"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 19999, host: 19999

  #config.vm.synced_folder ".", "/vagrant", type: "nfs"

  #config.vbguest.auto_update = false
  config.vm.network "private_network", ip: "192.168.50.4",
                    virtualbox__intnet: true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provision "shell", inline: <<-SHELL
    rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
    yes | yum -y install puppet net-tools
  SHELL

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.facter = {
      "environment" => "testing"
    }
    puppet.options = ENV['PUPPET_ARGS']
    #puppet.manifest_file = "default.pp"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
end
