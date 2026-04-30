<div align="center">
  <img src="assets/logo/AllerRisk.svg" alt="AllerRisk Logo" width="200" />

  # AllerRisk
  **Aplikasi Cerdas Penilaian & Pemantauan Risiko Alergi Anak**

  [![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
  [![GetX](https://img.shields.io/badge/State_Management-GetX-FF4500?logo=dart)](https://pub.dev/packages/get)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

<br />

AllerRisk adalah platform kesehatan digital berbasis Flutter yang dirancang untuk membantu orang tua dan dokter spesialis anak dalam menilai, memantau, dan mengelola risiko alergi pada anak sejak usia dini. Menggunakan algoritma *Simple Additive Weighting* (SAW), AllerRisk memberikan analisis prediktif awal mengenai potensi alergi anak berdasarkan genetik, gejala klinis, riwayat atopi, dan kondisi lingkungan.

---

## 📥 Download & Install

> **Status:** Beta Release
> 
> [**⬇️ Download AllerRisk APK (Android)**](#) *(Placeholder Link)*

---

## ✨ Fitur Utama

Aplikasi ini dibagi menjadi dua modul utama: **Modul Orang Tua** dan **Modul Dokter**.

### 👨‍👩‍👧‍👦 Modul Orang Tua (Parent)
- **Profil Anak:** Kelola data banyak anak dalam satu akun.
- **Asesmen Risiko Alergi:** Kuesioner komprehensif yang menilai risiko genetik, gejala, riwayat, dan lingkungan.
- **Riwayat & Pantauan:** Pantau hasil asesmen dari waktu ke waktu lengkap dengan level risiko (Rendah, Sedang, Tinggi).
- **Rekomendasi Cerdas:** Dapatkan saran medis awal berdasarkan tingkat keparahan hasil asesmen.
- **Edukasi (Artikel):** Akses artikel kesehatan dan tips *parenting* yang ditulis langsung oleh dokter spesialis.

### 🩺 Modul Dokter (Doctor)
- **Dashboard Pasien:** Pantau tingkat risiko pasien yang ditangani secara *real-time*.
- **Catatan Klinis:** Tambahkan catatan diagnosis dan rencana tindakan untuk setiap pasien anak.
- **Artikel Edukasi:** Dokter dapat mempublikasikan artikel edukasi kesehatan yang akan dibaca oleh orang tua pasien.
- **Manajemen Notifikasi:** Sistem pemberitahuan otomatis ketika anak dari pasien melakukan asesmen dengan hasil "Risiko Tinggi".

---

## 🛠️ Tech Stack & Arsitektur

AllerRisk dikembangkan menggunakan standar industri modern dengan fokus pada performa dan skalabilitas:

- **Framework:** [Flutter](https://flutter.dev/) (Multi-platform mobile app)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get) (Reactive State Management, Dependency Injection, and Route Management)
- **Local Storage:** `get_storage` untuk caching dan penyimpanan data sesi yang cepat.
- **UI/UX Design:** Desain "Clinical Curator" kustom dengan integrasi `google_fonts` dan komponen Material 3 (M3).
- **Data Visualization:** `fl_chart` untuk grafik dan tren riwayat asesmen alergi.
- **Dokumen & Laporan:** `pdf` & `printing` untuk ekspor catatan klinis dan riwayat medis.
- **Algoritma Sistem:** Menggunakan algoritma *Simple Additive Weighting* (SAW) untuk penentuan skor akhir alergi.

---

## 🚀 Cara Menjalankan Proyek (Development)

Ikuti langkah-langkah di bawah ini untuk menjalankan AllerRisk di perangkat lokal Anda.

### 1. Prasyarat
- Flutter SDK (Versi 3.x.x)
- Dart SDK
- Android Studio / VS Code dengan ekstensi Flutter
- Emulator Android atau Simulator iOS (atau perangkat fisik)

### 2. Instalasi
Clone repositori ini dan jalankan perintah instalasi dependensi:
```bash
git clone https://github.com/username/allerrisk.git
cd allerrisk
flutter pub get
```

### 3. Generate Launcher Icons (Jika diperlukan)
Jika Anda melakukan perubahan pada logo aplikasi, jalankan:
```bash
flutter pub run flutter_launcher_icons
```

### 4. Menjalankan Aplikasi
```bash
flutter run
```

### 5. Membangun Release APK (Split ABIs)
Untuk membuat ukuran aplikasi lebih kecil saat rilis ke Android, Anda dapat menggunakan split ABI:
```bash
flutter build apk --split-per-abi
```
*Hasil build akan tersimpan di `build/app/outputs/flutter-apk/`.*

---

## 👤 Akun Demo (Mock Data)

Karena aplikasi saat ini masih berjalan menggunakan data *mock* untuk pengembangan, Anda dapat login menggunakan kredensial berikut:

**Orang Tua (Parent):**
- Email: `budi@demo.com`
- Password: `demo1234`

**Dokter (Doctor):**
- Email: `dokter@demo.com`
- Password: `demo1234`

---

<div align="center">
  <p>Dibuat dengan ❤️ oleh MasFana.</p>
  <p>© 2026 MasFana.</p>
</div>
