# Install Packages

```
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt upgrade
sudo hostnamectl set-hostname HOSTNAME
sudo apt-get install apache2 mysql-server unzip
sudo apt-get install software-properties-common
sudo apt-get install php7.1 php7.1-common php7.1-mbstring php7.1-xmlrpc php7.1-soap php7.1-gd php7.1-xml php7.1-intl php7.1-mysql php7.1-cli php7.1-bcmath php7.1-mcrypt php7.1-ldap php7.1-zip php7.1-curl php7.1-bcmath -y
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