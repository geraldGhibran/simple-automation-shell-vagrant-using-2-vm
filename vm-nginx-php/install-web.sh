#!/bin/bash

jawaban="Y"

read -p "Are you sure to install webserver press y to continue ? (Y/n) " pilih;
if [ $pilih == $jawaban ];
then
    echo "======================================================================"
    echo "===============        Update repository        ======================"
    echo "======================================================================"
    sudo apt-get update
    echo "======================================================================"
    echo "===============        Install webserver        ======================"
    echo "======================================================================"
    sudo apt-get install -y nginx php-mysqli mysql-server php-fpm git unzip
    echo "======================================================================"
    echo "==============      Get nginx setting for web application  ==========="
    echo "======================================================================"
    # sudo wget https://github.com/geraldGhibran/simple-automation-nginx/archive/main.zip && sudo unzip main.zip
sudo tee /etc/nginx/sites-available/pesbuk <<EOF
server {
        listen 80;
        root /var/www/html;
        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;
        server_name localhost;
        location / {
        	index index.php index.html index.htm;
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files \$uri \$uri/ =404;
        }
        location ~ \.php$ {
          include snippets/fastcgi-php.conf;
          fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }
}
EOF
    echo "======================================================================"
    echo "===========       Remove any file in html directory        ==========="
    echo "======================================================================"
    sudo rm -rf /var/www/html/*
    echo "======================================================================"
    echo "=========   Move file to upper directory    =========================="
    echo "======================================================================"
    cd /var/www/html && sudo git clone https://github.com/geraldGhibran/sosial-media.git && sudo mv sosial-media/* .
    echo "======================================================================"
    echo "Configure previous if exist"
    echo "======================================================================"
#    sudo cp /home/vagrant/simple-automation-nginx-main/pesbuk /etc/nginx/sites-available/ 
#    sudo cp /home/vagrant/simple-automation-nginx-main/pesbuk /etc/nginx/sites-enabled/ 
    sudo ln -s /etc/nginx/sites-available/pesbuk /etc/nginx/sites-enabled/pesbuk
    sudo unlink /etc/nginx/sites-enabled/default
    echo "======================================================================"
    echo "==========    Restart service     ===================================="
    echo "======================================================================"
    sudo nginx -t
    sudo systemctl restart nginx
    sudo systemctl restart php7.2-fpm
    echo "======================================================================"
    echo "==========    Setting Database    ===================================="
    echo "======================================================================"
    cd /var/www/html/ 
sudo mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE USER IF NOT EXISTS 'devopscilsy'@'localhost' IDENTIFIED BY '1234567890';
GRANT ALL PRIVILEGES ON * . * TO 'devopscilsy'@'localhost';
FLUSH PRIVILEGES;
EOF
sudo mysql dbsosmed < dump.sql
    echo "================================================================================="
    echo "Done installation web server please check your ip address in nginx configuration "
    echo "================================================================================="
else
    echo "Webserver installation has been canceled"
    exit 1
fi
