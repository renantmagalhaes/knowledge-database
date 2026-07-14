# Zabbix Active Agent Conf — Amazon Linux AMI (Outdated)

## Install packages

```sh
rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-2.4.8-1.el6.x86_64.rpm
rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-agent-2.4.8-1.el6.x86_64.rpm
```

## Edit agent conf

```sh
vi /etc/zabbix/zabbix_agentd.conf
```

Zabbix Server IP Address or Hostname:

```
Server=$SERVERNAME or $SERVERIP
ServerActive=$SERVERNAME or $SERVERIP
```

Comment `Hostname`, uncomment `HostnameItem`:

```
HostMetadataItem=system.uname  # For registration in Actions
```

```sh
# Restart zabbix_agentd
service zabbix-agent restart

# Enable Zabbix service
systemctl enable zabbix-agent
```

## Install in a single command

```sh
rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-2.4.8-1.el6.x86_64.rpm && rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-agent-2.4.8-1.el6.x86_64.rpm && sed -i 's/127.0.0.1/$SERVERNAME/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostMetadataItem=/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf && chkconfig zabbix-agent on && service zabbix-agent start
```

## Seds

```sh
sed -i 's/127.0.0.1/$SERVERNAME/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf
sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/\#\ HostMetadataItem/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf
```
