#!/bin/bash

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Harap jalankan script sebagai root atau dengan sudo!"
   exit 1
fi

# Minta input dari pengguna
read -p "Masukkan nama database baru: " WP_DB
read -p "Masukkan username database: " WP_USER
read -s -p "Masukkan password untuk user database tadi: " WP_PASS
echo ""

# Pastikan MariaDB sudah terinstal
if ! command -v mariadb &> /dev/null; then
    echo "MariaDB belum terinstal. Menginstal sekarang..."
    apt update && apt install -y mariadb-server
    systemctl enable --now mariadb
fi

# Buat database, user, dan berikan hak akses
mysql -uroot -e "CREATE DATABASE $WP_DB;"
mysql -uroot -e "CREATE USER '$WP_USER'@'localhost' IDENTIFIED BY '$WP_PASS';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $WP_DB.* TO '$WP_USER'@'localhost';"
mysql -uroot -e "FLUSH PRIVILEGES;"

# Tampilkan hasil
echo "----------------------------------------"
echo "Database berhasil dibuat!"
echo "Nama Database  : $WP_DB"
echo "Username       : $WP_USER"
echo "Password       : $WP_PASS"
echo "Host           : localhost"
echo "----------------------------------------"

# Selesai
exit 0
