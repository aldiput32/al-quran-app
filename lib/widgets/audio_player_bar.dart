import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';
import '../theme/app_colors.dart';

class AudioPlayerBar extends StatelessWidget {
  const AudioPlayerBar({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = context.watch<AudioPlayerProvider>();

    if (audioProv.activeSurahNomor == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAyah = audioProv.activeAyahNomor != null;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Playing Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(isDark ? 0.2 : 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.audiotrack_rounded,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Title Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAyah
                          ? 'Ayat ${audioProv.activeAyahNomor} (Surah ${audioProv.activeSurahNomor})'
                          : 'Full Murottal Surah ${audioProv.activeSurahNomor}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AudioPlayerProvider.qariOptions[audioProv.selectedQari] ??
                          'Qari Murottal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Play / Pause Button
              IconButton(
                iconSize: 32,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                icon: audioProv.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        audioProv.isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
                      ),
                onPressed: () {
                  if (audioProv.isPlaying) {
                    audioProv.pauseAudio();
                  } else {
                    audioProv.resumeAudio();
                  }
                },
              ),

              // Stop Button
              IconButton(
                iconSize: 22,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  audioProv.stopAudio();
                },
              ),
            ],
          ),

          // Duration Slider if duration is available
          if (audioProv.duration.inSeconds > 0)
            Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 10),
                    activeTrackColor: isDark
                        ? AppColors.primaryLight
                        : AppColors.primary,
                    inactiveTrackColor: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                    thumbColor: isDark
                        ? AppColors.primaryLight
                        : AppColors.primary,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: audioProv.duration.inMilliseconds.toDouble(),
                    value: audioProv.position.inMilliseconds
                        .clamp(0, audioProv.duration.inMilliseconds)
                        .toDouble(),
                    onChanged: (val) {
                      audioProv.seekAudio(
                        Duration(milliseconds: val.toInt()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(audioProv.position),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        _formatDuration(audioProv.duration),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
