# Zabbix/Grafana URL Redirect (Outdated)

Edit in `/etc/httpd/conf/httpd.conf`:

```apache
# Zabbix Redirect
NameVirtualHost *:80
<VirtualHost *:80>
DocumentRoot /usr/share/zabbix
ServerName $URL or $IP

# Grafana Redirect
ProxyPreserveHost On
ProxyPass /grafana http://$URL or $IP:3000
ProxyPassReverse /grafana http://$URL or $IP:3000

</VirtualHost>
```

Edit `/etc/grafana/grafana.ini`:

```ini
domain = $DOMAINSERVER
root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana
```
