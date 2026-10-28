import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/surah_model.dart';
import '../providers/quran_provider.dart';
import '../theme/app_colors.dart';

class TafsirScreen extends StatefulWidget {
  final SurahModel surah;
  final int? highlightAyat;

  const TafsirScreen({
    super.key,
    required this.surah,
    this.highlightAyat,
  });

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().loadSurahTafsir(widget.surah.nomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quranProv = context.watch<QuranProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tafsir QS. ${widget.surah.namaLatin}'),
      ),
      body: quranProv.isLoadingTafsir
          ? const Center(child: CircularProgressIndicator())
          : quranProv.currentTafsir == null || quranProv.currentTafsir!.tafsir.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            size: 48, color: Colors.orangeAccent),
                        const SizedBox(height: 12),
                        Text(
                          'Tafsir belum dapat dimuat',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pastikan koneksi internet Anda terhubung untuk mengunduh data tafsir Kemenag RI.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Coba Lagi'),
                          onPressed: () {
                            quranProv.loadSurahTafsir(widget.surah.nomor);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  itemCount: quranProv.currentTafsir!.tafsir.length,
                  itemBuilder: (context, index) {
                    final item = quranProv.currentTafsir!.tafsir[index];
                    final isHighlighted = widget.highlightAyat == item.ayat;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? (isDark
                                ? AppColors.primaryDark.withOpacity(0.3)
                                : AppColors.primaryContainer.withOpacity(0.4))
                            : (isDark ? AppColors.cardDark : AppColors.cardLight),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isHighlighted
                              ? (isDark
                                  ? AppColors.primaryLight
                                  : AppColors.primary)
                              : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Ayat ke-${item.ayat}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.teks,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              height: 1.7,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
