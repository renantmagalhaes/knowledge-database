#UBUNTU 16.04
#login as root
#Set var $SERVER_NAME 

# Ubuntu 20.04

```
wget http://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1%2Bubuntu20.04_all.deb -O zabbix_agent.deb && dpkg -i zabbix_agent.deb && apt-get update && apt-get install -y zabbix-agent && sed -i 's/127.0.0.1/$SERVER_NAME/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostMetadataItem=/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf &&  service zabbix-agent restart && systemctl enable zabbix-agent
```


# Ubuntu 18.04

```
wget http://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1%2Bubuntu18.04_all.deb -O zabbix_agent.deb && dpkg -i zabbix_agent.deb && apt-get update && apt-get install -y zabbix-agent && sed -i 's/127.0.0.1/$SERVER_NAME/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostMetadataItem=/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf &&  service zabbix-agent restart && systemctl enable zabbix-agent
```
