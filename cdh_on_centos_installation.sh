#! /usr/bin/bash

set -euxo pipefail
. colorful_log.sh

# common tools
log_blue "install common tools"
yum install epel-release -y
yum install net-tools -y
yum install bind-utils -y
yum install wget -y
yum install vim -y
log_green "finish installing common tools\n"

# aliyun yum source:
log_blue "enable aliyun yum source"
if [ ! -e /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
fi
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
if [ ! -e /etc/yum.repos.d/epel.repo.bak ]; then
  cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak
fi
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
log_green "enabled aliyun yum source\n"

# enable yum change
yum clean all
yum makecache

# timezone consequense
log_blue "timezone to Asia/Shanghai"
timedatectl set-timezone Asia/Shanghai
log_green "now Asia/Shanghai\n"

# disable selinux
log_blue " disable selinux"
sed -i -e "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config
setenforce 0
log_green "selinux disabled\n"

# ntp for cdh requirements
log_blue "clock service to ntp"
systemctl stop chronyd
systemctl disable chronyd
yum install ntp -y
ntpdate -u 0.cn.pool.ntp.org
hwclock --systohc #Synchronize the hardware clock to the system clock
log_green "clock service to ntp and syced\n"

# DB for cdh requirements, one of 'pg mysql oracle'
log_blue "install pg for cdh"
yum install postgresql postgresql-server -y
if [ -e /var/lib/pgsql/data/pg_hba.conf ]; then
  mv /var/lib/pgsql/data /var/lib/pgsql/data-`date +%F`
fi
su -l postgres -c "postgresql-setup initdb"
systemctl start postgresql
systemctl enable postgresql
log_green "pg installed\n"

# jdk for cdh r9s. jdk8 is compatable
log_blue "install jdk8 as cdh6.2.1 required"
yum install java-1.8.0-openjdk-devel -y
log_green "jdk8 is now available\n"

# disable fastermirror
cp /etc/yum/pluginconf.d/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf.bak
sed -i -e "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf
sed -i -e "s/plugins=1/plugins=0/" /etc/yum.conf

# install the cloudera manager
# config repo for cdh
log_blue "config cdh repo to install cdh"
log_yellow "note: this action is only need for the manager node"
if [ -e /etc/yum.repos.d/cloudera-manager.repo ]; then 
  echo "cloudera-manager.repo exists, no need to install"
else
  wget https://archive.cloudera.com/cm6/6.2.1/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/
fi
# Import the repository signing GPG key
rpm --import https://archive.cloudera.com/cm6/6.2.1/redhat7/yum/RPM-GPG-KEY-cloudera
# Install Cloudera Manager Packages on the 
#yum install cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server



