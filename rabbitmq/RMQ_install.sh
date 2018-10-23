#!/bin/sh
#
# RMQ_install.sh - Script to install RabbitMQ
#Site        :https://renantmagalhaes.net
#Author      :Renan Toesqui Magalhães <renantmagalhaes@gmail.com>
#                                     <https://github.com/renantmagalhaes>
#
# ---------------------------------------------------------------
#
# This script  will install a full working rabbitmq node
#
# For building a RMQ cluster see https://github.com/renantmagalhaes/knowledge-database/rabbitmq
#
# --------------------------------------------------------------
#
#
#

#Root check
if [ “$(id -u)” != “0” ]; then
echo “This script must be run as root” 2>&1
exit 1
fi


#Update and upgrade the system
apt-get update && apt-get -y upgrade

#Add the key
apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys "0x6B73A36E6026DFCA"
wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | sudo apt-key add -

#Add the repos
echo "deb https://dl.bintray.com/rabbitmq/debian xenial erlang" | sudo tee /etc/apt/sources.list.d/bintray.erlang.list
echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
apt-get update

#Install packages
sudo apt-get -y install erlang-nox rabbitmq-server

#Pinning the package to prevent upgrade
cat <<EOF >  /etc/apt/preferences.d/erlang
# /etc/apt/preferences.d/erlang
Package: erlang*
Pin: release o=Bintray
Pin-Priority: 1000
EOF


#Start and enable rabbitmq-server
service rabbitmq-server start
systemctl enable rabbitmq-server
