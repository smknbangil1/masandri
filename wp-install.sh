#!/bin/bash

# Meminta input domain
echo -n "Masukkan domain atau subdomain: "
read domain

# Definisi path
webroot="/var/www/$domain/wordpress"
wp_source="/software/wordpress"
nginx_conf="/etc/nginx/sites-available/$domain"
nginx_link="/etc/nginx/sites-enabled/$domain"

# Membuat direktori webroot jika belum ada
if [ ! -d "$webroot" ]; then
    mkdir -p "$webroot"
fi

# Menyalin WordPress ke direktori webroot
cp -r "$wp_source"/* "$webroot"/

# Mengatur izin kepemilikan dan hak akses
chown -R www-data:www-data "$webroot"
chmod -R 755 "$webroot"

# Membuat konfigurasi virtual host untuk Nginx
cat > "$nginx_conf" <<EOF
server {
    listen 80;
    server_name $domain;
    root $webroot;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|otf|eot|mp4|webm|ogg|ogv|webp|avif|xml|json)$ {
        expires max;
        log_not_found off;
    }
}
EOF

# Mengaktifkan konfigurasi Nginx
ln -s "$nginx_conf" "$nginx_link"

# Menguji konfigurasi Nginx
nginx -t
if [ $? -eq 0 ]; then
    # Restart Nginx jika konfigurasi valid
    systemctl restart nginx
    echo "Website dan VHOST telah sukses dibuat."
else
    echo "Terjadi kesalahan dalam konfigurasi Nginx. Periksa kembali."
fi
