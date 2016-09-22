# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "c7" do |c7|
    c7.vm.box = "centos/7"
  end
  config.vm.define "c6" do |c6|
    c6.vm.box = "centos/6"
  end

  config.vm.provision "shell", inline: <<-SHELL
    # install compiler, rpm build tools and openresty's build requirements
    sudo yum install rpm-build redhat-rpm-config rpmdevtools -y
    sudo yum install openssl-devel zlib-devel pcre-devel gcc make perl perl-Data-Dumper libtool ElectricFence systemtap-sdt-devel valgrind-devel -y

    # create the makerpm account for building rpms only:
    sudo useradd makerpm
    sudo groupadd mock
    sudo usermod -a -G mock makerpm

    # setup rpm build env
    echo '%_topdir /home/makerpm/rpmbuild' > ~makerpm/.rpmmacros

    # copy required files into makerpm user
    mkdir -p ~makerpm/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
  SHELL
end
