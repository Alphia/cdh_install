#! /usr/bin/env bash

set -euxo pipefail


hostnamectl set-hostname $1.$2

sed -i -e "s/127.0.0.1.*/127.0.0.1 localhost $1 $1.$2/" /etc/hosts

echo "" >> /etc/hosts
cat host_list >> /etc/hosts

sed -i -e "s/HOSTNAME.*/HOSTNAME=$1.$2/" /etc/sysconfig/network


