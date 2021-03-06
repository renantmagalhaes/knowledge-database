#!/bin/bash
##########################################################################################################################
#                                           READ BEFORE PROCEED                                                             #
#   Is required to read all the comments for this installation, there are some information that change accordingly the node   #
 ##########################################################################################################################

#DISCLAIMER
# This is guide is not written in stone, take time to read it, and change according your needs
# Also i run all the commands as root to facilitate the installation, in a true production environment is a good practice to create a specific user to run the services and host the files

#update and upgrade the system
sudo apt-get update \
&& sudo apt-get -y upgrade \
&& sudo apt-get -y install wget ca-certificates zip net-tools vim tar netcat

#Download install java (11)
##The latest version of kafka (2.1.0 at this time) supports java 11
apt-get -y install default-jdk

#Basic performance tuning
##Disable Swap 
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.conf

##Adjust limits to open 100,000 file descriptor
echo "* hard nofile 100000
* soft nofile 100000" | sudo tee --append /etc/security/limits.conf

#Create basic folders
mkdir -p $HOME/downloads \
&& mkdir -p $HOME/data \
&& mkdir -p $HOME/data/kafka-data \
&& mkdir -p $HOME/data/zookeeper-data \
&& mkdir -p  $HOME/bin/kafka 

# Download kafka
curl -o $HOME/downloads/kafka_2.12-2.1.0.tgz http://ftp.unicamp.br/pub/apache/kafka/2.1.0/kafka_2.12-2.1.0.tgz

# Unzip bin files
tar -xvzf $HOME/downloads/kafka_2.12-2.1.0.tgz -C $HOME/bin/kafka/

# Set CONFS
## Zookeeper
###VERY IMPORTANT EDIT "myid" accordingly, each node MUST have a UNIQUE ID
# for example node 2 will be echo "2" > $HOME/data/zookeeper-data/myid and so on
echo "1" > $HOME/data/zookeeper-data/myid

## Zookeeper config 
##OBS: If running on-premise, change the server.x to 0.0.0.0 accordingly to each node - view README.md for for details 
cat <<EOF > /root/bin/kafka/kafka_2.12-2.1.0/config/zookeeper.properties
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/root/data/zookeeper-data
clientPort=2181
server.1=zookeeper-1:2888:3888
server.2=zookeeper-2:2888:3888
server.3=zookeeper-3:2888:3888
EOF

## KAFKA config
##VERY IMPORTANT EDIT broker.id and advertised.listeners accordingly, each host MUST have UNIQUE values

cat <<EOF > /root/bin/kafka/kafka_2.12-2.1.0/config/server.properties
broker.id=1
advertised.listeners=PLAINTEXT://kafka-1:9092
#delete.topic.enable=true
log.dirs=/root/data/kafka-data
num.partitions=8
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=368
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=host-1:2181,host-2:2181,host-3:2181
#/kafka at the end to create a folder named kafka
#zookeeper.connect=zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181/kafka
zookeeper.connection.timeout.ms=6000
auto.create.topics.enable=true
EOF

#Configue services
## Zookeeper
### edit DAEMON_PATH= and ZOO_CONF path accordingly)
curl https://raw.githubusercontent.com/renantmagalhaes/knowledge-database/master/kafka-zookeeper-cluster/init-scripts/zookeeper-init-service.sh > /etc/init.d/zookeeper
chmod +x /etc/init.d/zookeeper
update-rc.d zookeeper defaults #(can ignore if any error appears)

## Kafka
### edit DAEMON_PATH= and KAFKA_CONF path accordingly
curl https://raw.githubusercontent.com/renantmagalhaes/knowledge-database/master/kafka-zookeeper-cluster/init-scripts/kafka-init-service.sh > /etc/init.d/kafka
chmod +x /etc/init.d/kafka
update-rc.d kafka defaults #(can ignore if any error appears)

#Reboot
shutdown -r now

#Start the services
##Fist start zookeeper in all nodes
service zookeeper start
##Second start kafka in all nodes
service kafka start
