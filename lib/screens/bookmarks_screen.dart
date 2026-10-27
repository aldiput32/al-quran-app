import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/surah_model.dart';
import '../providers/bookmark_provider.dart';
import '../providers/quran_provider.dart';
import '../theme/app_colors.dart';
import 'surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarkProv = context.watch<BookmarkProvider>();
    final quranProv = context.watch<QuranProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark & Terakhir Dibaca'),
      ),
      body: bookmarkProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookmarkProv.bookmarks.isEmpty && bookmarkProv.lastRead == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border_rounded,
                        size: 64,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum Ada Bookmark Disimpan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tekan ikon bookmark pada ayat untuk menyimpan.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Last Read Card if exists
                    if (bookmarkProv.lastRead != null) ...[
                      Text(
                        'Terakhir Dibaca',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer
                                    .withOpacity(isDark ? 0.2 : 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.history_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bookmarkProv.lastRead!.surahNamaLatin,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Ayat No. ${bookmarkProv.lastRead!.ayahNomor}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final surah = quranProv.surahList.firstWhere(
                                  (s) =>
                                      s.nomor ==
                                      bookmarkProv.lastRead!.surahNomor,
                                  orElse: () => SurahModel(
                                    nomor: bookmarkProv.lastRead!.surahNomor,
                                    nama: '',
                                    namaLatin:
                                        bookmarkProv.lastRead!.surahNamaLatin,
                                    jumlahAyat: 0,
                                    tempatTurun: '',
                                    arti: '',
                                    deskripsi: '',
                                    audioFull: {},
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SurahDetailScreen(
                                      surah: surah,
                                      initialAyah:
                                          bookmarkProv.lastRead!.ayahNomor,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Buka'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Bookmark List Header
                    if (bookmarkProv.bookmarks.isNotEmpty) ...[
                      Text(
                        'Ayat Disimpan (${bookmarkProv.bookmarks.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...bookmarkProv.bookmarks.map((bookmark) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardDark
                                : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'QS. ${bookmark.surahNamaLatin}: ${bookmark.ayahNomor}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.primaryLight
                                          : AppColors.primary,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    iconSize: 20,
                                    color: Colors.redAccent,
                                    icon: const Icon(Icons.delete_outline_rounded),
                                    onPressed: () {
                                      bookmarkProv.toggleBookmark(
                                        surahNomor: bookmark.surahNomor,
                                        surahNamaLatin: bookmark.surahNamaLatin,
                                        ayahNomor: bookmark.ayahNomor,
                                        teksArab: bookmark.teksArab,
                                        teksIndonesia: bookmark.teksIndonesia,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  bookmark.teksArab,
                                  style: GoogleFonts.amiri(
                                    fontSize: 20,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                bookmark.teksIndonesia,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
    );
  }
}
