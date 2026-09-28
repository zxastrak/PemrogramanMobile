# Warehouse Management System (PBL UAS - Pemrograman Mobile)

Aplikasi mobile manajemen gudang & inventaris (*Warehouse & Inventory Management*) yang dibangun dengan **Flutter** berdasarkan desain wireframe/mockup Figma untuk memenuhi kriteria evaluasi **PBL UAS Pemrograman Mobile**.

---

## 📌 Tautan Pengumpulan
* **Tautan Desain Figma**: [Link Figma PBL UAS](https://www.figma.com/design/pbl-uas-mobile-warehouse) *(Silakan sesuaikan tautan Figma Anda)*
* **Tautan Repositori GitHub**: [https://github.com/username/pbl_uas_inventory](https://github.com/username/pbl_uas_inventory) *(Silakan sesuaikan dengan URL repo Anda)*

---

## 📱 Slicing UI: 4 Screen Utama (Sesuai Desain Figma)

Aplikasi mengimplementasikan 4 screen utama secara presisi sesuai gambar rancangan wireframe:

1. **Screen 1: Login Screen**
   * Input teks **Username** dan **Password** (dilengkapi toggle visibilitas *show/hide password*).
   * Tombol **Masuk** dengan validasi kredensial pengguna dan feedback status login.
   * Terintegrasi dengan `AuthProvider`.
   * *Akun Demo:* `admin` / kata sandi bebas (contoh: `123456`).

2. **Screen 2: Home Screen (Tugas & Map)**
   * **Custom Search Bar**: Input pencarian real-time + tombol **Filter** (Semua, IN, OUT, Selesai).
   * **Info Banner**: Ringkasan status shift kerja, staf bertugas, dan jumlah tugas aktif.
   * **Interactive MAP Card**: Denah digital gudang (Rak A Inbound, Rak B Storage, Rak C Outbound, dan sensor GPS Live Tracking).
   * **Tugas Hari Ini**: Daftar tugas gudang interaktif yang menampilkan:
     * Label Rak (misal: `Rak A-02`)
     * Nama Barang (misal: `Forklift Hydraulic Pump`)
     * Jumlah (`Qty : 120`) & Kode SKU (`SKU-99023412`)
     * Badge status operasi **IN** (Inbound hijau) atau **OUT** (Outbound merah)
     * Checkbox untuk menandai tugas selesai/belum.
   * **Floating Action Button (`+`)**: Menggunakan widget `Stack` untuk membuka modal tambah tugas baru ke dalam state secara real-time.

3. **Screen 3: Item Screen (Katalog & GridView)**
   * **Search & Kategori**: Pencarian barang berdasarkan nama, SKU, rak, atau kategori (Packaging, Storage, Equipment, Electronics, Safety).
   * **2-Column GridView (`SliverGrid`)**: Tampilan kartu barang responsif dengan placeholder visual, indikator stok, lokasi rak, serta tombol penyesuaian kuantitas cepat (`+` / `-`).
   * **Item Detail Dialog**: Ketuk kartu barang untuk melihat detail spesifikasi barang.
   * **Floating Action Button (`QR`)**: Tombol melayang di pojok kanan bawah menggunakan `Stack` untuk membuka pemindai barcode / SKU barang.

4. **Screen 4: Menu Screen (Profil Staf & Manajemen)**
   * **Profil Card**:
     * Foto Avatar lingkaran (**Foto**)
     * Informasi **Nama Lengkap** & **No Staf**
     * Zona penempatan tugas staf
     * Tombol **Kustomisasi**: Membuka dialog untuk mengedit profil pengguna secara real-time melalui `AuthProvider`.
   * **Penempatan Staf**: Navigasi ke sub-layar pengelolaan zonasi staf (*Zone A, Zone B, Zone C, dsb.*).
   * **QR Scanner Absensi**: Simulasi pemindaian QR Code kehadiran dengan animasi laser scanner interaktif dan pencatatan absensi otomatis.
   * **Log History**: Riwayat lengkap seluruh aktivitas pergudangan (Absensi, Inbound barang, perubahan penempatan staf, dsb.) disertai *timestamp*.
   * **Keluar dari Akun (Logout)**: Kembali ke Login Screen dan mereset sesi.

5. **Shared Bottom Navigation Bar**
   * Terdiri dari 3 menu navigasi utama: **Item**, **Home**, dan **Menu** dengan tampilan border wireframe yang rapi.

---

## 🎨 Tipografi & Palet Warna Khusus
* **Tipografi**: Menggunakan font **`Space Mono`** (Google Fonts) di seluruh aplikasi untuk memberikan tampilan teknis, presisi, dan modern khas sistem inventaris/pergudangan.
* **Palet Warna**:
  * `Primary (Crimson Red)`: **`#D62A2A`** (Aksen utama, tombol masuk, floating actions, status OUT)
  * `Secondary (Coral Red)`: **`#E46B63`** (Aksen pelengkap, chip filter, status pending)
  * `Surface Variant (Sage Mint)`: **`#B4CDB1`** (Border elemen, kontainer input, card background)
  * `Accent / Success (Olive Green)`: **`#5C732B`** (Status IN, live tracking, kartu banner, konfirmasi aktif)

---

## 🛠️ Pemenuhan Requirement Teknis

### 1. Advanced UI Layout
* **`CustomScrollView` & Slivers**:
  * Digunakan pada `HomeScreen` dan `ItemScreen` untuk scroll performa tinggi dengan sliver header (`SliverToBoxAdapter`, `SliverPadding`, `SliverGrid`).
* **`GridView` (`SliverGrid`)**:
  * Diimplementasikan pada `ItemScreen` dengan konfigurasi `SliverGridDelegateWithFixedCrossAxisCount` 2 kolom untuk katalog barang yang rapi dan responsif.
* **`Stack` & `Positioned`**:
  * Digunakan pada `MapCardWidget` untuk menumpuk label MAP, denah custom painter, indikator badge zona, dan status GPS.
  * Digunakan pada `HomeScreen` untuk menempatkan tombol melayang tambah tugas (`+`).
  * Digunakan pada `ItemScreen` untuk menempatkan tombol scanner bulat (`QR`).
  * Digunakan pada `QrScannerDialog` untuk animasi garis pemindai laser merah yang bergerak naik-turun.

### 2. State Management (Global & Local)
* **Global State Management: `Provider`**:
  * Menggunakan `MultiProvider` pada akar aplikasi (`MyApp`).
  * `AuthProvider`: Mengatur status otentikasi login, profil staf, dan kustomisasi identitas.
  * `TaskProvider`: Mengelola data tugas hari ini, filter IN/OUT, status checklist, serta penambahan tugas.
  * `InventoryProvider`: Mengelola daftar barang gudang, filter kategori, pencarian, dan mutasi stok.
  * `StaffProvider`: Mengatur zonasi staf dan pencatatan histori absensi/aktivitas.
* **Local State Management: `setState`**:
  * Mengontrol index tab aktif pada `MainNavigationScreen`.
  * Mengatur toggle *show/hide password* pada `LoginScreen`.
  * Mengontrol input form pada dialog penambahan data dan filter lokal.

### 3. Pemisahan Logika (Clean Architecture)
Struktur kode dipisahkan secara teratur antara berkas UI (`.dart` tampilan screen), Controller/State Provider, dan Model:

```
lib/
├── main.dart                          # Inisialisasi MultiProvider & AppTheme
├── constants/
│   ├── app_colors.dart                # Konstanta warna tema wireframe slate & status
│   └── app_theme.dart                 # Konfigurasi ThemeData & styling global
├── models/
│   ├── user_model.dart                # Model entitas pengguna/staf
│   ├── task_model.dart                # Model tugas Inbound & Outbound
│   ├── inventory_item_model.dart      # Model katalog barang inventaris
│   └── log_model.dart                 # Model log riwayat aktivitas & absensi
├── providers/
│   ├── auth_provider.dart             # Logika otentikasi & kustomisasi profil
│   ├── task_provider.dart             # Logika manajemen tugas & filter
│   ├── inventory_provider.dart        # Logika katalog stok & pencarian
│   └── staff_provider.dart            # Logika penempatan staf & histori absensi
├── widgets/
│   ├── custom_search_bar.dart         # Komponen search bar & tombol filter
│   ├── bottom_nav_bar.dart            # 3-tab bottom navigation bar [Item, Home, Menu]
│   ├── map_card_widget.dart           # Widget MAP gudang dengan Stack & CustomPainter
│   ├── task_card_widget.dart          # Kartu item tugas hari ini (Rak, IN/OUT, SKU)
│   ├── item_grid_card.dart            # Kartu barang untuk GridView 2 kolom
│   └── qr_scanner_dialog.dart         # Dialog simulasi QR Scanner dengan animasi laser
└── screens/
    ├── login_screen.dart              # Screen 1: Tampilan Login
    ├── main_navigation_screen.dart    # Induk navigasi tab BottomNavBar
    ├── home_screen.dart               # Screen 2: Tampilan Home (Tugas & Map)
    ├── item_screen.dart               # Screen 3: Tampilan Item (Katalog Grid & QR)
    ├── menu_screen.dart               # Screen 4: Tampilan Menu (Profil & Navigasi Fitur)
    ├── staff_placement_screen.dart    # Sub-screen Penempatan Staf
    └── log_history_screen.dart        # Sub-screen Log Riwayat Aktivitas
```

---

## 🚀 Cara Menjalankan Aplikasi

1. **Pastikan Flutter SDK terpasang**:
   ```bash
   flutter --version
   ```

2. **Clone repositori atau buka direktori proyek**:
   ```bash
   cd "d:/Coding/Pemrograman Mobile"
   ```

3. **Unduh dependensi (*packages*)**:
   ```bash
   flutter pub get
   ```

4. **Verifikasi kode tanpa error (*clean check*)**:
   ```bash
   flutter analyze
   ```

5. **Jalankan pengujian unit / widget test**:
   ```bash
   flutter test
   ```

6. **Jalankan aplikasi**:
   * Untuk Chrome / Web:
     ```bash
     flutter run -d chrome
     ```
   * Untuk Windows Desktop:
     ```bash
     flutter run -d windows
     ```
   * Untuk Emulator Android / Perangkat Fisik:
     ```bash
     flutter run
     ```
