# AbdulHarisAsari\_Front-end

Aplikasi Front-end untuk manajemen barang (inventory) menggunakan Flutter.
Project ini mencakup fitur tambah, edit, hapus, dan bulk delete barang, serta integrasi kategori.

---

## 📦 Fitur

* Tambah barang baru
* Edit barang
* Hapus barang
* Bulk delete barang
* Dropdown kategori dari database
* Format harga dalam Rupiah (Currency Format)
* Validasi form dan error handling

---

## 🚀 Teknologi

* Flutter 3.x
* Dart
* GetX (State management & routing)
* Dio (HTTP client)
* MySQL (Backend) — menggunakan API

---

## 🏗 Struktur Project

```
lib/
 ├─ data/
 │   ├─ models/           # Model Product, Category, BulkDelete, EditRequest
 │   ├─ providers/        # ApiProvider (Dio config)
 │   └─ repository/       # ProductRepository
 ├─ modules/
 │   ├─ home/
 │   │   ├─ bindings/
 │   │   ├─ controllers/
 │   │   └─ views/
 │   └─ form/
 │       ├─ controllers/
 │       └─ views/
 ├─ core/                 # Themes, Utils
 └─ main.dart
```

---

## ⚙️ Instalasi & Jalankan

1. Clone repository:

```bash
git clone https://github.com/abdulharisasari/abdul_haris_as-ari_front-end.git
cd abdul_haris_as-ari_front-end
```

2. Install dependencies:

```bash
flutter pub get
```

3. Jalankan aplikasi:

```bash
flutter run
```

4. Build APK release:

```bash
flutter build apk --release
```

APK akan tersedia di:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔗 API Endpoint (Contoh)

* GET `/barang` — ambil semua barang
* POST `/barang` — tambah barang baru
* PUT `/barang/:id` — edit barang
* POST `/barang/bulk-delete` — hapus beberapa barang sekaligus
* GET `/kategori` — ambil kategori barang

---

## 🗂 Backend Repository

**Nama Repository:** [abdul\_haris\_asari\_back-end](https://github.com/abdulharisasari/abdul_haris_asari_back-end)

**Deskripsi:** Implementasi CRUD untuk Barang dan Kategori menggunakan NestJS dan MySQL, termasuk fitur bulk delete dan response dengan format standar (`statusCode`, `message`, `data`).

### ⚙️ Persyaratan

* Node.js >= 18.x
* MySQL Server

### 🛠 Instalasi dan Pengaturan

1. Clone repository backend:

```bash
git clone https://github.com/abdulharisasari/abdul_haris_asari_back-end.git
cd abdul_haris_asari_back-end
```

2. Install dependencies:

```bash
npm install
```

3. Konfigurasi database:

   * Buat database baru di MySQL dengan nama `product_db`
   * Import file `product.sql` ke dalam database
4. Jalankan aplikasi:

```bash
npm run start
```

Aplikasi akan berjalan di `http://localhost:3000`

### 🔗 API Endpoints Backend

* **GET** `/barang` — Ambil semua barang
* **POST** `/barang` — Tambah barang baru
* **PUT** `/barang/:id` — Edit barang berdasarkan ID
* **DELETE** `/barang/:id` — Hapus barang berdasarkan ID
* **POST** `/barang/bulk-delete` — Hapus beberapa barang sekaligus
* **GET** `/kategori` — Ambil semua kategori barang

---

## 👤 Author

Abdul Haris Asari
Email: [abdulharisasari@gmail.com](mailto:abdulharisasari@gmail.com)

---

## 📄 Catatan

* Pastikan backend API berjalan agar aplikasi frontend dapat melakukan fetch data.
* Semua fitur telah diuji secara lokal dan siap digunakan.
* Setelah pull APK, HRD dapat langsung menginstall di Android device.
