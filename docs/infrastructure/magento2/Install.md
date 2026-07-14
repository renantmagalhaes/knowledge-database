# Install Packages

```
sudo apt update
sudo apt upgrade
sudo hostnamectl set-hostname HOSTNAME
sudo apt-get install apache2 mysql-server unzip
sudo apt-get install software-properties-common
sudo apt install php7.2 libapache2-mod-php7.2 php7.2-common php7.2-gmp php7.2-curl php7.2-soap php7.2-bcmath php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2-mcrypt php7.2-mysql php7.2-gd php7.2-xml php7.2-cli php7.2-zip
```

## Modify php.ini
vi sudo nano /etc/php/7.2/apache2/php.ini

```
file_uploads = On
allow_url_fopen = On
short_open_tag = On
memory_limit = 512M
upload_max_filesize = 128M
max_execution_time = 3600
```

# Database Setup

```
sudo systemctl start mysql
sudo systemctl enable mysql
```

```sudo mysql```

```
CREATE DATABASE magento;
CREATE USER 'magentouser'@'localhost' IDENTIFIED BY 'PASSWORD';
CREATE USER 'magentouser'@'%' IDENTIFIED BY 'PASSWORD';
GRANT ALL ON magento.* TO 'magentouser'@'localhost' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;
GRANT ALL ON magento.* TO 'magentouser'@'%' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

# Download latest magento version
* [Magento Communit Edition](https://magento.com/tech-resources/download)
```
sudo mv ~/Downloads/Magento*.zip /var/www/html/

cd /var/www/html/

sudo unzip Magento*.zip
```
Change the permissions for this folder

```
sudo chown -R www-data:www-data /var/www/html/magento
sudo chmod -R 755 /var/www/html/magento
```

# Apache Configuration

```rm /etc/apache2/sites-enabled/000-default.conf```

```sudo nano /etc/apache2/sites-available/magento.conf```

```
<VirtualHost *:80>
     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/
     ServerName site.com
     ServerAlias www.site.com

     <Directory /var/www/html/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```


```
sudo a2ensite magento.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
```

# Cron configuration

` sudo crontab -u www-data -e `

```
* * * * * /usr/bin/php /var/www/html/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/magento/var/log/magento.cron.log
* * * * * /usr/bin/php /var/www/html/update/cron.php >> /var/www/magento/var/log/update.cron.log
* * * * * /usr/bin/php /var/www/html/bin/magento setup:cron:run >> /var/www/magento/var/log/setup.cron.log
```

# Finish instalation

http://server_ip_or_server_name/

# Useful commands