# Panduan Membuat Website Termudah

Dengan panduan ini, Anda dapat membuat website dengan cepat hanya dalam beberapa langkah sederhana.
#
**Pastikan domain Anda sudah mengarah ke IP Public server sebelum menjalankan skrip**

## Langkah 1: Membuat Database 

1. Login ke Ubuntu.  
2. Jalankan perintah: `sudo su`  
3. Eksekusi skrip dengan perintah: `./buat_database.sh`  
4. Ikuti instruksi yang muncul di layar.  
5. Proses selesai.

## Langkah 2: Install Wordpress
1. Masuk ke server Ubuntu Anda melalui SSH.
2. Ketik perintah berikut untuk mendapatkan akses root:
   ```bash
   sudo su
   ```
3. Jalankan skrip instalasi WordPress dengan perintah berikut:
   ```bash
   ./wp-install.sh
   ```
4. Masukkan nama domain atau subdomain tanpa menulis `http://` atau `https://`.
   - Contoh domain utama: `sekolahku.com`
   - Contoh subdomain: `ujian.sekolahku.com`

## Langkah 3: Mengaktifkan SSL
1. Jalankan perintah berikut untuk memasang SSL menggunakan Certbot:
   ```bash
   certbot --nginx
   ```
2. Jika diminta email, masukkan email Anda.
3. Jika diminta memilih domain, masukkan angka sesuai urutan nomor domain Anda.
4. Selesai! Website dan SSL telah dibuat dengan sangat cepat.

### Catatan:
- Pastikan domain Anda sudah mengarah ke IP Public server sebelum menjalankan skrip.
- Hubungi maspur jika ada kendala ya

Website Anda kini telah siap digunakan! 🎉

