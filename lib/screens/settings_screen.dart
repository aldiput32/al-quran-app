import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import 'donasi_screen.dart';
import 'prayer_times_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProv = context.watch<ThemeProvider>();
    final audioProv = context.watch<AudioPlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          // Theme Section
          Text(
            'TAMPILAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: SwitchListTile(
              secondary: Icon(
                themeProv.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                'Mode Gelap (Dark Mode)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                themeProv.isDarkMode ? 'Tema malam aktif' : 'Tema terang aktif',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              value: themeProv.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (_) => themeProv.toggleTheme(),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: SwitchListTile(
              secondary: const Icon(
                Icons.palette_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                'Teks Tajwid Berwarna',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                themeProv.isTajweedEnabled
                    ? 'Warna tajwid aktif (Ikhfa, Mad, Qalqalah, dll.)'
                    : 'Teks Arab polos tanpa warna',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              value: themeProv.isTajweedEnabled,
              activeColor: AppColors.primary,
              onChanged: (_) => themeProv.toggleTajweed(),
            ),
          ),

          const SizedBox(height: 24),

          // Prayer & Adzan Section
          Text(
            'JADWAL SHOLAT & ADZAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.access_time_filled_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                'Pengaturan Jadwal & Suara Adzan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Atur on/off per waktu sholat & pilihan suara adzan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrayerTimesScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Typography Section
          Text(
            'UKURAN HURUF ARAB',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: GoogleFonts.amiri(
                      fontSize: themeProv.arabicFontSize,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kecil (20pt)', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    Text(
                      '${themeProv.arabicFontSize.toInt()} pt',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text('Besar (42pt)', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                  ],
                ),
                Slider(
                  min: 20.0,
                  max: 42.0,
                  divisions: 11,
                  value: themeProv.arabicFontSize,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    themeProv.setArabicFontSize(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Qari Section
          Text(
            'PILIHAN QARI AUDIO MUROTTAL',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: audioProv.selectedQari,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.record_voice_over_rounded, color: AppColors.primary),
              ),
              items: AudioPlayerProvider.qariOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  audioProv.changeQari(val);
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Donation & Server Support Section
          Text(
            'DONASI & DUKUNGAN OPERASIONAL',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volunteer_activism_rounded,
                  color: AppColors.accentGold,
                  size: 20,
                ),
              ),
              title: Text(
                'Donasi Perpanjang Server',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Bantu operasional server cloud & streaming audio bebas iklan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonasiScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          Text(
            'TENTANG APLIKASI',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Al-Qur\'an Indonesia Mobile',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versi 1.0.0',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Divider(height: 20),
                Text(
                  'Sumber Data Teks & Terjemahan:\nKementerian Agama Republik Indonesia (Kemenag RI) & EQuran.id REST API.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
