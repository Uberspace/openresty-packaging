#!/bin/sh
set -e

if [ "$USER" != "vagrant" ]; then
  echo this script must be executed inside a vagrant vm
  exit 1
fi

function build() {
  sudo -u makerpm spectool -g -R ~makerpm/rpmbuild/SPECS/$1.spec
  sudo -u makerpm rpmbuild -ba ~makerpm/rpmbuild/SPECS/$1.spec

  if [ "$2" == "install" ]; then
    sudo bash -c "yum install -y ~makerpm/rpmbuild/RPMS/x86_64/${1}{,-debuginfo,-devel}-*.rpm"
  fi
}

sudo cp ~vagrant/sync/rpm/SOURCES/* ~makerpm/rpmbuild/SOURCES/
sudo cp ~vagrant/sync/rpm/SPECS/*.spec ~makerpm/rpmbuild/SPECS
sudo chown -R makerpm:makerpm ~makerpm

sudo yum -y remove openresty-*

build openresty-zlib install
build openresty-pcre install

build openresty-openssl install
build openresty

sudo yum -y remove openresty-openssl-*

build openresty-openssl-debug install
build openresty-debug
build openresty-valgrind

DST=/home/vagrant/sync/build/`rpm -q centos-release | cut -d- -f-3`
rm -rf $DST
sudo mkdir -p $DST
sudo cp -r ~makerpm/rpmbuild/{RPMS,SRPMS} $DST
