# 📖 Al-Qur'an Indonesia - Android Flutter App

Aplikasi Al-Qur'an & Muslim Indonesia Android modern, elegan, dan kaya fitur yang dibangun menggunakan **Flutter** dengan standar resmi **Kementerian Agama Republik Indonesia (Kemenag RI)**.

---

## ✨ Fitur-Fitur Utama yang Tersedia

### 1. 📖 Al-Qur'an 30 Juz & 114 Surah
- **Teks Rasm Utsmani**: Menggunakan font kaligrafi *Amiri* yang elegan dan mudah dibaca.
- **Teks Tajwid Berwarna**: Pewarnaan tajwid interaktif (Ikhfa, Qalqalah, Ghunnah, Iqlab, Mad) lengkap dengan modal panduan warna tajwid. Bisa dihidupkan/dimatikan di Pengaturan.
- **Transliterasi Latin & Terjemahan Kemenag RI**: Membantu pembaca yang sedang belajar.
- **Tafsir Lengkap**: Tafsir resmi Kemenag RI per ayat dan per surat.

### 2. 🕌 Jadwal Sholat Real-Time & Notifikasi Adzan Fleksibel
- **Jadwal Sholat 5 Waktu + Imsak & Terbit**: Dihitung otomatis sesuai standar hisab Kemenag RI (Subuh 20°, Isya 18°) untuk berbagai kota di Indonesia.
- **Countdown Real-Time**: Hitung mundur detik demi detik menuju waktu sholat berikutnya.
- **Pengaturan Adzan Fleksibel**:
  - Saklar On / Off adzan tersendiri untuk masing-masing waktu (Subuh, Dzuhur, Ashar, Maghrib, Isya).
  - Pilihan suara adzan: **Adzan Makkah**, **Adzan Madinah**, **Adzan Subuh**, **Adzan Mesir (Syekh Abdul Basith)**, **Nada Beep**, atau **Hanya Getar**.
  - Tombol *"Dengarkan Contoh Adzan"* langsung dari aplikasi.

### 3. 🔊 Audio Murottal Merdu
- Putar audio per ayat atau per satu surat penuh.
- Pilihan Qari ternama:
  - Misyari Rasyid Al-Afasy
  - Abdurrahman As-Sudais
  - Abdullah Al-Juhany
  - Abdul Muhsin Al-Qasim
  - Ibrahim Al-Dossari
- Floating audio player bar di bawah layar dengan progress bar dan tombol navigasi.

### 4. 🧭 Kompas Arah Kiblat (Qibla Compass)
- Perhitungan sudut derajat Ka'bah otomatis berdasarkan koordinat kota.
- Tampilan kompas digital interaktif dengan indikator getaran haptic feedback saat ponsel tepat menghadap Ka'bah.

### 5. 📿 Tasbih Digital (Smart Dhikr Counter)
- Tombol lingkaran besar dengan getaran haptic feedback pada tiap klik.
- Pilihan bacaan dzikir (*Subhanallah, Alhamdulillah, Allahu Akbar, Astaghfirullah, Shalawat, dll.*).
- Penghitung putaran (lap) dan getaran khusus saat mencapai target (33x atau 100x).

### 6. ✨ 99 Asmaul Husna
- Daftar lengkap 99 nama-nama indah Allah SWT dengan kaligrafi Arab, transliterasi latin, arti bahasa Indonesia, dan pencarian instan.

### 7. 🤲 Koleksi Doa Sehari-Hari & Bookmark
- Puluhan doa harian dengan tombol salin (copy).
- Fitur penanda "Terakhir Dibaca" dan bookmark ayat favorit yang tersimpan offline.

### 8. 🎨 Kustomisasi Tampilan
- **Dark Mode (Mode Malam)** & Mode Terang.
- Slider pengatur ukuran font huruf Arab (20pt s/d 42pt).

---

## 📁 Struktur Direktori

```
alquran/
├── android/                   # Konfigurasi Gradle & Manifest Android
├── lib/
│   ├── models/                # Data model (Surah, Ayah, Tafsir, Bookmark, Doa, Tajweed, PrayerSetting)
│   ├── services/              # API Client (EQuran.id), Storage & PrayerService (Adhan & Qibla)
│   ├── providers/             # State Management (Quran, Audio, Bookmark, Theme, PrayerProvider)
│   ├── theme/                 # Palet warna Islami & Google Fonts typography
│   ├── widgets/               # Komponen UI (SurahCard, AyahCard, TajweedTextWidget, LastReadCard, AudioPlayerBar)
│   ├── screens/               # Halaman aplikasi (Splash, Home, Detail, Tafsir, Bookmarks, Doa, PrayerTimes, Qibla, Tasbih, AsmaulHusna, Settings)
│   └── main.dart              # Entry point aplikasi
└── pubspec.yaml               # Dependensi Flutter
```

---

## 🚀 Cara Menjalankan & Build APK

1. **Ambil Dependensi:**
   ```bash
   flutter pub get
   ```

2. **Jalankan di HP Android / Emulator:**
   ```bash
   flutter run
   ```

3. **Build APK Release:**
   ```bash
   flutter build apk --release
   ```
   File APK siap install berada di: `build/app/outputs/flutter-apk/app-release.apk`
