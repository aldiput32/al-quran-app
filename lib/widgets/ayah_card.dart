import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';
import '../providers/audio_player_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'tajweed_text_widget.dart';

class AyahCard extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final VoidCallback? onOpenTafsir;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.surah,
    this.onOpenTafsir,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProv = context.watch<ThemeProvider>();
    final bookmarkProv = context.watch<BookmarkProvider>();
    final audioProv = context.watch<AudioPlayerProvider>();

    final isBookmarked =
        bookmarkProv.isBookmarked(surah.nomor, ayah.nomorAyat);
    final isLastRead = bookmarkProv.lastRead != null &&
        bookmarkProv.lastRead!.surahNomor == surah.nomor &&
        bookmarkProv.lastRead!.ayahNomor == ayah.nomorAyat;
    final isAudioActive =
        audioProv.isAyahActive(surah.nomor, ayah.nomorAyat);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAudioActive
            ? (isDark
                ? AppColors.primaryDark.withOpacity(0.3)
                : AppColors.primaryContainer.withOpacity(0.4))
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAudioActive
              ? (isDark ? AppColors.primaryLight : AppColors.primary)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isAudioActive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Action Bar (Ayah Number, Audio, Copy, Bookmark, Tafsir)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Ayah Number
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.primaryLight.withOpacity(0.4)
                          : AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${ayah.nomorAyat}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.primaryLight
                          : AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),

                // Play Audio Button
                IconButton(
                  iconSize: 20,
                  tooltip: 'Dengarkan Ayat',
                  icon: isAudioActive
                      ? (audioProv.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.pause_circle_filled,
                              color: AppColors.primary))
                      : Icon(
                          Icons.play_circle_outline,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                  onPressed: () {
                    final audioUrl =
                        ayah.getAudioUrl(audioProv.selectedQari);
                    if (audioUrl.isNotEmpty) {
                      audioProv.playAyah(
                        surahNomor: surah.nomor,
                        ayahNomor: ayah.nomorAyat,
                        audioUrl: audioUrl,
                      );
                    }
                  },
                ),

                // Tafsir Button
                if (onOpenTafsir != null)
                  IconButton(
                    iconSize: 20,
                    tooltip: 'Lihat Tafsir',
                    icon: Icon(
                      Icons.menu_book_outlined,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    onPressed: onOpenTafsir,
                  ),

                // Copy Verse Button
                IconButton(
                  iconSize: 20,
                  tooltip: 'Salin Ayat',
                  icon: Icon(
                    Icons.copy_rounded,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  onPressed: () {
                    final copyText =
                        '${ayah.teksArab}\n\n"${ayah.teksIndonesia}" (QS. ${surah.namaLatin}: ${ayah.nomorAyat})';
                    Clipboard.setData(ClipboardData(text: copyText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Ayat ${ayah.nomorAyat} berhasil disalin ke clipboard'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Mark Last Read Button
                IconButton(
                  iconSize: 20,
                  tooltip: isLastRead
                      ? 'Posisi Terakhir Dibaca'
                      : 'Tandai Terakhir Dibaca',
                  icon: Icon(
                    isLastRead
                        ? Icons.history_edu_rounded
                        : Icons.history_rounded,
                    color: isLastRead
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                  onPressed: () {
                    bookmarkProv.updateLastRead(
                      surahNomor: surah.nomor,
                      surahNamaLatin: surah.namaLatin,
                      ayahNomor: ayah.nomorAyat,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Ditandai sebagai Terakhir Dibaca: QS. ${surah.namaLatin} ayat ${ayah.nomorAyat}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Bookmark Toggle Button
                IconButton(
                  iconSize: 20,
                  tooltip: 'Simpan Bookmark',
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isBookmarked
                        ? AppColors.accentGold
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                  onPressed: () {
                    bookmarkProv.toggleBookmark(
                      surahNomor: surah.nomor,
                      surahNamaLatin: surah.namaLatin,
                      ayahNomor: ayah.nomorAyat,
                      teksArab: ayah.teksArab,
                      teksIndonesia: ayah.teksIndonesia,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Arabic Text with Tajweed Coloring
          TajweedTextWidget(
            text: ayah.teksArab,
            fontSize: themeProv.arabicFontSize,
            isTajweedEnabled: themeProv.isTajweedEnabled,
            defaultColor: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          const SizedBox(height: 14),

          // Latin Transliteration
          Text(
            ayah.teksLatin,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          // Indonesian Translation
          Text(
            ayah.teksIndonesia,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
