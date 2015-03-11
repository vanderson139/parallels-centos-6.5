#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo cp -r /home/vagrant/php.ini /opt/remi/php55/root/etc/php.ini
