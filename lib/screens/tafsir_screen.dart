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
          : quranProv.currentTafsir == null
              ? const Center(child: Text('Tafsir belum tersedia'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
