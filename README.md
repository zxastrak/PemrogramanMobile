# Aplikasi Resino Katalog Produk & Keranjang Belanja (Tugas 5)

Aplikasi ini adalah simulasi aplikasi katalog produk kebutuhan sehari-hari yang dilengkapi dengan fitur keranjang belanja. Saya mengambil tema kebutuhan sehari-hari karena sejalan dengan tema PBL saya yaitu smartwarehouse and inventory system, walaupun aplikasi ini lebih mirip POS.

# Fitur Utama Aplikasi

1. Screen 1 - Beranda / Katalog Produk
   - AppBar dengan judul "Resino - Katalog Produk".
   - Menampilkan daftar produk kebutuhan harian (Sabun Mandi, Shampo, Detergen) lengkap dengan icon, harga, dan deskripsi singkat.
   - Navigasi ke Screen Detail membawa data produk terpilih.

2. Screen 2 - Detail Katalog Produk
   - AppBar dengan tombol Back otomatis ke katalog.
   - Ikon besar, nama produk, harga, dan deskripsi berlatar warna pastel (`Colors.blue[50]`).
   - Interaktivitas State:
     - Toggle Favorit: Menandai produk sebagai favorit (ikon hati berubah merah).
     - Counter Jumlah: Penambahan & pengurangan kuantitas item.
     - Tambah ke Keranjang: Menyimpan produk secara real-time ke dalam keranjang.

3. Screen 3 - Keranjang Belanja & Pembayaran (Auto ACC)
   - Akses cepat melalui Bottom Navigation Bar dengan indikator badge jumlah item real-time.
   - Menampilkan ringkasan produk yang telah ditambah beserta pengubah jumlah item.
   - Rincian kalkulasi total harga otomatis.
   - Tombol Bayar Sekarang: Menampilkan dialog konfirmasi pembayaran berhasil disetujui (ACC).

# Panduan Setup Project

## 1. Prasyarat & Setup Flutter

1. Pastikan Flutter SDK sudah terinstal dan terkonfigurasi dengan baik. Jalankan di terminal:
   ```bash
   flutter doctor
   ```
2. Unduh atau clone proyek ini, lalu buka direktori proyek (`Tugas5`) di terminal/IDE:
   ```bash
   cd d:\Coding\Project\PemrogramanMobile\Tugas5 //Ini adalah contoh direktori lokal saya
   ```
3. Unduh semua dependensi proyek:
   ```bash
   flutter pub get
   ```

# Panduan Import Database MySQL

Jika proyek terhubung atau dikembangkan menggunakan basis data MySQL lokal (misal: via XAMPP / Laragon):

1. Jalankan Service MySQL:
   - Buka XAMPP Control Panel (atau Laragon).
   - Klik tombol Start pada layanan Apache dan MySQL.

2. Buat Database:
   - Akses phpMyAdmin di browser: http://localhost/phpmyadmin
   - Klik New / Baru pada panel kiri, lalu buat nama database: `db_tugas5`

3. Import Script Database (`db_tugas5.sql`):
   - Pilih database `db_tugas5` yang telah dibuat.
   - Pilih tab SQL di menu atas phpMyAdmin.
   - Salin dan tempel (atau buka file `db_tugas5.sql` pada proyek ini), lalu jalankan/kirim.

# Perintah Menjalankan Server Lokal (Backend)

Jika proyek dihubungkan ke REST API / backend lokal:

- Menggunakan PHP Built-in Server:
  ```bash
  php -S localhost:8000
  ```
  (Server akan aktif di `http://localhost:8000`)

- Menggunakan Node.js / Express.js (Jika ada):
  ```bash
  npm install
  npm start
  ```

# Perintah Menjalankan Aplikasi Flutter

Gunakan salah satu perintah berikut di terminal direktori proyek:

- Jalankan di Web Browser (Chrome):
  ```bash
  flutter run -d chrome
  ```

- Jalankan di Android (Device / Emulator):
  ```bash
  flutter run
  ```

- Jalankan di Windows Desktop:
  ```bash
  flutter run -d windows
  ```
