# TODO

- Grafana permissions (letsencrypt folder)
- script for certificate refresh
- script for permissions (letsencrypt folder)
- script for reload (nginx and grafana)

# Grafana installation

```
sudo apt-get install -y gnupg2 curl software-properties-common
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update
sudo apt install grafana
systemctl enable --now grafana-server
sudo systemctl enable --now grafana-server
```

# Certbot installation

```
sudo apt install certbot python3-certbot-nginx
```

## Deploy certificate

```
certbot --nginx
```

- Follow the instructions


# Grafana configuration

- File location
```/etc/grafana/grafana.ini```


```
#################################### Server ####################################
[server]
# Protocol (http, https, h2, socket)
protocol = https

# The ip address to bind to, empty will bind to all interfaces
;http_addr =

# The http port  to use
http_port = 3000

# The public facing domain name used to access grafana from a browser
domain = your.domain.com

# Redirect to correct domain if host header does not match domain
# Prevents DNS rebinding attacks
;enforce_domain = false

# The full public facing url you use in browser, used for redirects and emails
# If you use reverse proxy and sub path specify full url (with sub path)
root_url = https://your.domain.com

# Serve Grafana from subpath specified in `root_url` setting. By default it is set to `false` for compatibility reasons.
;serve_from_sub_path = false

# Log web requests
;router_logging = false

# the path relative working path
;static_root_path = public

# enable gzip
;enable_gzip = false

# https certs & key file
cert_file = /etc/letsencrypt/live/your.domain.com/fullchain.pem
cert_key = /etc/letsencrypt/live/your.domain.com/privkey.pem

```

# Nginx configuration

- File location
```/etc/nginx/sites-enabled/default```

In the end of the file add ```return 301 https://$host:3000$request_uri;``` parameter in these two locations

```
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/your.domain.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/your.domain.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    return 301 https://$host:3000$request_uri;

}
server {
    if ($host = your.domain.com) {
        #return 301 https://$host$request_uri;
        return 301 https://$host:3000$request_uri;
    } # managed by Certbot


        listen 80 ;
        listen [::]:80 ;
    server_name your.domain.com;
    return 404; # managed by Certbot

}
```
- nginx -s reload