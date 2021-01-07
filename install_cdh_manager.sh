#! /usr/bin/bash

set -euxo pipefail
. colorful_log.sh

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
yum install cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server
JAVAHOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.275.b01-0.el7_9.x86_64 /opt/cloudera/cm-agent/bin/certmanager setup --configure-services



