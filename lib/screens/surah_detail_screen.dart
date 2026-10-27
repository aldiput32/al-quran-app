import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/surah_model.dart';
import '../providers/audio_player_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/quran_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/audio_player_bar.dart';
import '../widgets/ayah_card.dart';
import '../widgets/tajweed_text_widget.dart';
import 'tafsir_screen.dart';

class SurahDetailScreen extends StatefulWidget {
  final SurahModel surah;
  final int? initialAyah;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    this.initialAyah,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final quranProv = context.read<QuranProvider>();
      final bookmarkProv = context.read<BookmarkProvider>();

      // Update Last Read automatically
      bookmarkProv.updateLastRead(
        surahNomor: widget.surah.nomor,
        surahNamaLatin: widget.surah.namaLatin,
        ayahNomor: widget.initialAyah ?? 1,
      );

      await quranProv.loadSurahDetail(widget.surah.nomor);

      // Auto-scroll to initialAyah if specified
      if (widget.initialAyah != null && widget.initialAyah! > 1) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            final targetOffset = (widget.initialAyah! - 1) * 260.0;
            _scrollController.animateTo(
              targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }

      // Continuous Murottal: auto play next ayah when current ayah finishes
      final audioProv = context.read<AudioPlayerProvider>();
      audioProv.setOnAyahCompleted((sNomor, aNomor) {
        if (!mounted || sNomor != widget.surah.nomor) return;
        final detail = quranProv.currentSurahDetail;
        if (detail == null) return;

        final nextAyahIndex = detail.ayat.indexWhere((a) => a.nomorAyat == aNomor + 1);
        if (nextAyahIndex != -1) {
          final nextAyah = detail.ayat[nextAyahIndex];
          final audioUrl = nextAyah.getAudioUrl(audioProv.selectedQari);
          if (audioUrl.isNotEmpty) {
            audioProv.playAyah(
              surahNomor: widget.surah.nomor,
              ayahNomor: nextAyah.nomorAyat,
              audioUrl: audioUrl,
            );

            // Animate scroll to follow the playing ayah
            if (_scrollController.hasClients) {
              final targetOffset = nextAyahIndex * 260.0;
              _scrollController.animateTo(
                targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        } else {
          audioProv.stopAudio();
        }
      });
    });
  }

  @override
  void dispose() {
    context.read<AudioPlayerProvider>().setOnAyahCompleted(null);
    _scrollController.dispose();
    super.dispose();
  }

  void _showFontSizeDialog() {
    final themeProv = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ukuran Tulisan Arab',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: GoogleFonts.amiri(
                        fontSize: themeProv.arabicFontSize,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    min: 20.0,
                    max: 42.0,
                    divisions: 11,
                    value: themeProv.arabicFontSize,
                    onChanged: (val) {
                      setModalState(() {});
                      themeProv.setArabicFontSize(val);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quranProv = context.watch<QuranProvider>();
    final audioProv = context.watch<AudioPlayerProvider>();
    final isFullSurahPlaying = audioProv.isFullSurahActive(widget.surah.nomor);

    final themeProv = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.namaLatin),
        actions: [
          IconButton(
            tooltip: themeProv.isTajweedEnabled ? 'Tajwid Aktif (Klik untuk Panduan)' : 'Aktifkan Tajwid',
            icon: Icon(
              Icons.palette_rounded,
              color: themeProv.isTajweedEnabled ? AppColors.accentGold : Colors.grey,
            ),
            onPressed: () {
              TajweedTextWidget.showTajweedLegend(context);
            },
          ),
          IconButton(
            tooltip: 'Ukuran Font',
            icon: const Icon(Icons.format_size_rounded),
            onPressed: _showFontSizeDialog,
          ),
          IconButton(
            tooltip: 'Tafsir Surat',
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TafsirScreen(surah: widget.surah),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (quranProv.isLoadingDetail)
            const Center(child: CircularProgressIndicator())
          else if (quranProv.detailErrorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      quranProv.detailErrorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        quranProv.loadSurahDetail(widget.surah.nomor);
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          else if (quranProv.currentSurahDetail != null)
            ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 90),
              children: [
                // Header Banner Card
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.surah.namaLatin,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(${widget.surah.arti})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const Divider(
                        color: Colors.white24,
                        height: 24,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.surah.tempatTurun.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentGoldLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle,
                              size: 4, color: Colors.white54),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.surah.jumlahAyat} AYAT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Play Full Surah Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          isFullSurahPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        label: Text(
                          isFullSurahPlaying
                              ? 'Jeda Murottal Surat'
                              : 'Putar Murottal Penuh',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () {
                          final fullUrl =
                              quranProv.currentSurahDetail!.fullAudioUrl;
                          if (fullUrl.isNotEmpty) {
                            audioProv.playFullSurah(
                              surahNomor: widget.surah.nomor,
                              audioUrl: fullUrl,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Bismillah Banner (Except Surah #9 At-Taubah and Surah #1 Al-Fatihah where it's ayah 1)
                if (widget.surah.nomor != 9 && widget.surah.nomor != 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),

                // Ayah List
                ...quranProv.currentSurahDetail!.ayat.map((ayah) {
                  return AyahCard(
                    ayah: ayah,
                    surah: widget.surah,
                    onOpenTafsir: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TafsirScreen(
                            surah: widget.surah,
                            highlightAyat: ayah.nomorAyat,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),

          // Floating Audio Player at bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AudioPlayerBar(),
          ),
        ],
      ),
    );
  }
}
