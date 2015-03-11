#!/bin/sh

## Remi Dependency on CentOS 6 and Red Hat (RHEL) 6 
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm 

## CentOS 6 and Red Hat (RHEL) 6 
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/remi.repo

# Install Developer Tools
yum -y groupinstall 'Development Tools'

# Install Apache2 Server
yum -y install httpd
chkconfig --levels 235 httpd on
/etc/init.d/httpd start

# Install PHP
yum -y install php55.x86_64
yum -y install php55-php-devel.x86_64
yum -y install php55-php-gd.x86_64
yum -y install php55-php-intl.x86_64
yum -y install php55-php-mbstring.x86_64
yum -y install php55-php-mysqlnd.x86_64
yum -y install php55-php-pecl-xdebug.x86_64
yum -y install php55-php-pear.noarch

rm -rf /usr/bin/php
rm -rf /usr/bin/phpize
rm -rf /usr/bin/php-config
cp /opt/remi/php55/root/usr/bin/php /usr/bin/php
cp /opt/remi/php55/root/usr/bin/phpize /usr/bin/phpize
cp /opt/remi/php55/root/usr/bin/php-config /usr/bin/php-config
sudo rm -rf /usr/sbin/php-fpm
sudo cp /opt/remi/php55/root/usr/sbin/php-fpm /usr/sbin/php-fpm
sudo cp /opt/remi/php55/root/usr/sbin/php-fpm /usr/sbin/php55-php-fpm

# Install Oracle Client
yum -y install libaio.x86_64
wget http://www.crmall.com/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
wget http://www.crmall.com/oracle/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm
wget http://www.crmall.com/oracle/oci8-2.0.8.tgz

rpm -ivh oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
rpm -ivh oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/12.1/client64/bin:$PATH

tar -zxvf oci8-2.0.8.tgz
cd oci8-2.0.8 
/usr/bin/phpize
./configure --with-oci8=shared,instantclient,/usr/lib/oracle/12.1/client64/lib
make
make install
cd ~

