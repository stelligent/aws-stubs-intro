# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

#TODO:
# RVM and Ruby
# Atom
# Additional gems:
# cfn-dsl ()

Vagrant.configure(2) do |config|
  ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

  config.vm.communicator = "ssh"
   config.vm.box = "box-cutter/ubuntu1404-desktop"
   config.vm.network "private_network", type: 'dhcp' # ip: "192.168.33.10"
   config.vm.provider "virtualbox" do |vb|
     vb.gui = true
     vb.memory = "4096"
   end
   config.vm.provision "shell", inline: "sudo apt-get install curl -y"

  # #Atom IDE - uncomment this for an IDE-style editor
  # config.vm.provision "shell", privileged: false, inline: <<-ATOM
  #   sudo add-apt-repository ppa:webupd8team/atom -y
  #   sudo apt-get update
  #   sudo apt-get install atom -y
  # ATOM

  #RVM and Ruby 2.3.0
  config.vm.provision "shell", privileged: false, inline: <<-RVM
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

    #!/bin/bash
    set -xe

    # install & configure rvm
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -L https://get.rvm.io | bash -s stable --ruby=2.3.0
    #source /usr/local/rvm/scripts/rvm
    source /home/vagrant/.rvm/scripts/rvm
    rvm use 2.3.0 --default
  RVM

  #GIT
  config.vm.provision "shell", privileged: false, inline: "sudo apt-get install git-all -y"

  config.vm.provision "shell", privileged: false, inline: <<-BASHRC
    echo 'if test -f ~/.rvm/scripts/rvm; then' >> ~/.bashrc
    echo '    [ "$(type -t rvm)" = "function" ] || source ~/.rvm/scripts/rvm' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
  BASHRC

  config.vm.provision "shell", privileged: false, inline: <<-OTHER
    gem install bundler
    # NOTE: rubygems
    gem update --system
  OTHER
end
