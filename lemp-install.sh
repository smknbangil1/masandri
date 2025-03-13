#!/bin/bash

# Update dan upgrade sistem
apt update && apt upgrade -y

# Install MariaDB
apt install -y mariadb-server
systemctl enable --now mariadb

# Amankan instalasi MariaDB
echo -e "Y\nn\nY\nY\nY\nY\n" | mysql_secure_installation

# Install Nginx
apt install -y nginx
systemctl enable --now nginx

# Install PHP 8.3-FPM dan ekstensi yang diperlukan
apt install -y php8.3-fpm php8.3-cli php8.3-mysql php8.3-curl php8.3-xml php8.3-mbstring php8.3-zip php8.3-gd php8.3-bcmath php8.3-imagick php8.3-intl php8.3-soap
systemctl enable --now php8.3-fpm

# Konfigurasi Nginx untuk WordPress
cat > /etc/nginx/sites-available/wordpress <<EOF
server {
    listen 80;
    server_name example.com;
    root /var/www/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff2|woff|ttf|svg|eot)$ {
        expires max;
        log_not_found off;
    }

    location = /robots.txt { access_log off; log_not_found off; }
    location ~* /\.ht { deny all; }
}
EOF

# Aktifkan konfigurasi Nginx\ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

# Buat direktori WordPress dan atur izin
mkdir -p /var/www/wordpress
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# Restart layanan
systemctl restart nginx php8.3-fpm mariadb

echo "LEMP Stack dengan PHP 8.3 dan MariaDB telah berhasil diinstal!"
