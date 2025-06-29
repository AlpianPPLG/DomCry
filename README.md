# 📱 DomCry (Dompet Crypto)

DomCry adalah aplikasi dompet cryptocurrency berbasis Flutter yang dirancang untuk memberikan pengalaman pengguna yang modern, aman, dan lintas platform. Aplikasi ini memungkinkan pengguna untuk mengelola aset kripto, melakukan transaksi (kirim/terima), memantau harga pasar secara real-time, dan mengelola portofolio dengan antarmuka yang intuitif dan responsif. DomCry mendukung platform Android, iOS, Web, dan Desktop dengan performa optimal.

## 🚀 Fitur Utama

| Fitur                          | Deskripsi                                                                                  |
|--------------------------------|-------------------------------------------------------------------------------------------|
| 🔐 Autentikasi Pengguna        | Mendukung login dengan email/password, autentikasi biometrik, dan opsi 2FA (opsional).  |
| 💸 Transaksi Aset Kripto       | Kirim dan terima aset seperti BTC, ETH, dan USDT dengan integrasi wallet berbasis blockchain. |
| 📊 Analitik Real-Time          | Tampilan saldo, grafik harga pasar, dan riwayat transaksi yang diperbarui secara langsung. |
| 📁 Manajemen Portofolio        | Fitur scan QR code, swap aset, staking, dan perdagangan.                                  |
| 🌙 Mode Terang & Gelap         | Tema dinamis untuk kenyamanan pengguna dalam berbagai kondisi pencahayaan.                |
| 🖼️ UI/UX Modern                | Desain responsif dengan animasi halus dan layout yang ramah pengguna.                      |
| 🔄 Multi-Platform              | Kompatibel dengan Android, iOS, Web, dan Desktop menggunakan satu codebase.              |

## 🧩 Teknologi yang Digunakan

| Teknologi              | Deskripsi                                                                       |
|-----------------------|--------------------------------------------------------------------------------|
| 🐦 Flutter            | Framework UI lintas platform untuk pengembangan aplikasi yang konsisten.       |
| 🔣 Dart               | Bahasa pemrograman utama untuk logika aplikasi.                                 |
| 📦 Pub.dev            | Manajemen dependensi untuk package seperti provider, http, dll.               |
| 🎨 Tailwind-ish       | Styling UI menggunakan pendekatan utility-first.                               |
| 🌐 Responsive         | Mendukung berbagai ukuran layar dan orientasi.                                 |
| 🔐 Secure Storage     | Penggunaan flutter_secure_storage untuk menyimpan kunci privat dan token.      |
| 🌍 API Integrasi      | Integrasi dengan API seperti CoinGecko untuk harga real-time.                  |

## 📁 Struktur Proyek

Struktur proyek mengikuti pendekatan Clean Architecture. Berikut adalah struktur direktori:

lib/
├── core/
│ ├── constants/
│ ├── theme/
│ ├── services/
│ └── utils/
├── data/
│ ├── models/
│ ├── datasources/
│ └── repositories/
├── domain/
│ ├── entities/
│ ├── usecases/
│ └── repositories/
├── presentation/
│ ├── pages/
│ ├── components/
│ ├── routes/
│ └── blocs/
├── config/
│ ├── environment.dart
│ └── injection.dart
├── main.dart
└── public/
├── assets/
│ ├── img/
│ └── svg/
└── fonts/

**Catatan:** Struktur ini dirancang untuk skalabilitas dan kemudahan perawatan.

## 🛠️ Instalasi & Menjalankan Aplikasi

### Prasyarat

- Flutter SDK: Versi 3.22.x atau lebih baru.
- Dart: Versi 3.x atau lebih baru.
- IDE: Android Studio, VS Code, atau IntelliJ IDEA.
- Git: Untuk cloning repository.
- API Key: (Opsional) Untuk integrasi API harga kripto.

### Langkah-langkah Instalasi

1. **Clone Repository:**
   ```bash
   git clone https://github.com/username/domcry.git
   cd domcry

2. Install Dependensi:

        flutter pub get 
        Jalankan Aplikasi:
Catatan Penting
Pastikan emulator atau perangkat fisik terhubung.
Untuk build iOS, Anda memerlukan macOS dan Xcode terinstal.


### ⚙️ Konfigurasi pubspec.yaml

Berikut adalah contoh konfigurasi pubspec.yaml:

     name: domcry
     description: A modern cryptocurrency wallet built with Flutter.
     version: 1.0.0+1
     environment:
     sdk: ">=3.0.0 <4.0.0"
     dependencies:
        flutter:
            sdk: flutter
              provider: ^6.0.0
              http: ^1.0.0
              flutter_secure_storage: ^9.0.0
              flutter_dotenv: ^5.0.0
              go_router: ^10.0.0

      dev_dependencies:
           flutter_test:
              sdk: flutter

### 🔒 Kebijakan Privasi
DomCry berkomitmen untuk melindungi privasi pengguna. Data yang dikumpulkan hanya digunakan untuk menyediakan layanan inti dan tidak dibagikan ke pihak ketiga tanpa persetujuan.

### 🧑‍💻 Panduan Kontribusi
Kami menyambut kontribusi! Berikut langkah-langkahnya:

    1. Fork repository.
    2. Clone fork Anda.
    3. Buat branch baru dan lakukan perubahan.
    4. Commit perubahan dan push ke fork Anda.
    5. Buat Pull Request dengan deskripsi yang jelas.

### 📜 Lisensi
Aplikasi ini dilisensikan di bawah MIT License. Anda bebas untuk menyalin, memodifikasi, dan mendistribusikan aplikasi ini dengan syarat menyertakan pemberitahuan lisensi.

### 📚 Dokumentasi Tambahan
API Reference: (Akan ditambahkan setelah integrasi backend selesai).

Changelog: Lihat CHANGELOG.md untuk riwayat perubahan.
Dokumentasi ini dirancang untuk memberikan panduan yang jelas bagi pengembang dan pengguna. Terima kasih telah menggunakan DomCry! 🚀