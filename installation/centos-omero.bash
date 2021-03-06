#!/bin/bash
echo `hostname`

# sysadmin tools
yum -y install screen tmux htop expect bonnie++ tree

# Java
yum -y install java-1.7.0-openjdk
yum -y install java-1.7.0-openjdk-devel

# OMERO deps
yum -y install python-devel.x86_64 python-pip.noarch git gcc-c++.x86_64
yum -y install python-imaging python-matplotlib numpy
pip-python install virtualenv
pip-python install genshi

yum -y install hdf5.x86_64 hdf5-devel.x86_64

pip-python install numexpr==1.4.2
pip-python install cython					
pip-python install tables==2.4.0

# Postgres 9.2
wget http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm 
rpm -i pgdg-centos92-9.2-6.noarch.rpm

# Install the version from just downloaded
yum -y install postgresql92-server.x86_64 postgresql92-contrib.x86_64
chkconfig  postgresql-9.2 on
service postgresql-9.2  initdb en_US.UTF-8
service postgresql-9.2 start

# Nginx
# Add Nginx repo
echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/$basearch/
gpgcheck=0
enabled=1' > /etc/yum.repos.d/nginx.repo
# Install
yum -y install nginx
chkconfig --add nginx
chkconfig --level 35 nginx on
service nginx start

yum -y install mod_fastcgi

echo '[zeroc-ice]
name=Ice 3.4 for RHEL $releasever - $basearch
baseurl=http://www.zeroc.com/download/Ice/3.4/rhel$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=http://www.zeroc.com/download/RPM-GPG-KEY-zeroc-release' > /etc/yum.repos.d/zeroc_ice.repo

yum -y install db48-utils.x86_64 ice.noarch ice-java-devel.x86_64 ice-libs.x86_64 ice-python.x86_64  ice-python-devel.x86_64 ice-servers.x86_64 ice-sqldb.x86_64 ice-utils.x86_64 mcpp-devel.x86_64 ice-c++-devel.x86_64

# create/append to /etc/profile.d/omero.sh
echo export ICE_HOME=/usr/share/Ice-3.4.2 >> /etc/profile.d/omero.sh

#Pythonpath
echo export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/site-packages/Ice/ >> /etc/profile.d/omero.sh

# Update postgres auth file
cp /var/lib/pgsql/9.2/data/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf.orig
cd /var/lib/pgsql/9.2/data/
echo "time to update pg_hba.conf"
