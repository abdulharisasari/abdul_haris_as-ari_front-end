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
git clone https://github.com/username/AbdulHarisAsari_front-end.git
cd AbdulHarisAsari_front-end
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

## 👤 Author

Abdul Haris Asari
Email: [abdulharisasari@gmail.com](mailto:abdulharisasari@gmail.com)

---

## 📄 Catatan

* Pastikan backend API berjalan agar aplikasi dapat melakukan fetch data.
* Semua fitur telah diuji secara lokal dan siap digunakan.
* Setelah pull APK, HRD dapat langsung menginstall di Android device.
