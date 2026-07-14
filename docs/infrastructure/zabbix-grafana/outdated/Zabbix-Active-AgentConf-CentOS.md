# Zabbix Active Agent Conf — CentOS (Outdated)

## Add repo

```sh
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
```

## Install package

```sh
yum install -y zabbix-agent
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

## Full install (single command)

```sh
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm && yum install -y zabbix-agent && sed -i 's/127.0.0.1/$SERVERNAME/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf && sed -i 's/\#\ HostMetadataItem=/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf && service zabbix-agent restart && systemctl enable zabbix-agent
```

## Seds

```sh
sed -i 's/127.0.0.1/$SERVERNAME/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server//' /etc/zabbix/zabbix_agentd.conf
sed -i 's/\#\ HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/\#\ HostMetadataItem/HostMetadataItem=system.uname/' /etc/zabbix/zabbix_agentd.conf
```
