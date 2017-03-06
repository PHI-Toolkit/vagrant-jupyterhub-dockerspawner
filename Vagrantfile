# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/yakkety64"
  #
  config.disksize.size = '500GB'
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 443, host: 443
  config.vm.network "forwarded_port", guest: 80, host: 9080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network", bridge: "enp0s31f6"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "8192"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  #config.vm.provision "docker" do |d|
    #d.build_dir = "/vagrant/dockerspawner/singleuser"
    #d.image = "jupyterhub/singleuser"
    #d.pull_images "jupyter/all-spark-notebook"
    #d.pull_images "jupyterhub/singleuser"
  #end
  $before_script = <<SCRIPT
  echo # vagrant profile script > /etc/profile.d/vagrant.sh
  echo export CONDA_HOME=/opt/conda >> /etc/profile.d/vagrant.sh
  echo export DEBIAN_FRONTEND=noninteractive >> /etc/profile.d/vagrant.sh
  echo export PATH=/opt/conda/bin:$PATH >> /etc/profile.d/vagrant.sh
  chmod +x /etc/profile.d/vagrant.sh
  cat /vagrant/env.sh >> /etc/profile.d/env.sh
  echo export CONFIGPROXY_AUTH_TOKEN=`openssl rand -hex 32` >> /etc/profile.d/env.sh
  chmod +x /etc/profile.d/env.sh
SCRIPT
  config.vm.provision "shell", inline: $before_script
  config.vm.provision "shell", path: "bootstrap.sh"
end
