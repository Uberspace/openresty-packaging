#!/bin/sh

vagrant snapshot restore $1 clean --no-provision && vagrant rsync $1
vagrant ssh $1 -c /home/vagrant/sync/inner-build.sh
vagrant ssh-config > ssh_config && scp -rF ssh_config $1:/home/vagrant/sync/build . && rm ssh_config
