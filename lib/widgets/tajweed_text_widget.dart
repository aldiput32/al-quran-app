import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tajweed_rule.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class TajweedTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isTajweedEnabled;
  final Color defaultColor;

  const TajweedTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.isTajweedEnabled,
    required this.defaultColor,
  });

  // Parse Arabic text into colored Tajweed spans if enabled
  List<TextSpan> _buildSpans() {
    if (!isTajweedEnabled) {
      return [
        TextSpan(
          text: text,
          style: AppTheme.arabicStyle(
            fontSize: fontSize,
            color: defaultColor,
          ),
        ),
      ];
    }

    // Split into words so that Arabic cursive ligatures within each word remain connected
    final List<TextSpan> spans = [];
    final words = text.split(' ');

    for (int wIdx = 0; wIdx < words.length; wIdx++) {
      final word = words[wIdx];
      Color wordColor = defaultColor;

      // Identify Tajweed rules per word without breaking intra-word ligatures
      if (word.contains('ٓ') || word.contains('~')) {
        wordColor = const Color(0xFFE11D48); // Mad (Rose / Red)
      } else if (word.contains('نّ') || word.contains('مّ')) {
        wordColor = const Color(0xFFF97316); // Ghunnah (Orange)
      } else if (word.contains('ً') || word.contains('ٍ') || word.contains('ٌ')) {
        wordColor = const Color(0xFF10B981); // Ikhfa / Tanwin (Emerald Green)
      } else if (word.contains('ۢ') || (word.contains('ن') && word.contains('ب'))) {
        wordColor = const Color(0xFFD97706); // Iqlab (Amber / Gold)
      } else if (['ق', 'ط', 'ب', 'ج', 'د'].any((char) => word.contains(char))) {
        // Qalqalah: only if word has sukun or ends with qalqalah letter
        if (word.contains('ْ') || wIdx == words.length - 1) {
          wordColor = const Color(0xFF0284C7); // Qalqalah (Sky Blue)
        }
      }

      spans.add(
        TextSpan(
          text: word,
          style: AppTheme.arabicStyle(
            fontSize: fontSize,
            color: wordColor,
            fontWeight: wordColor != defaultColor ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      );

      if (wIdx < words.length - 1) {
        spans.add(
          TextSpan(
            text: ' ',
            style: AppTheme.arabicStyle(
              fontSize: fontSize,
              color: defaultColor,
            ),
          ),
        );
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          children: _buildSpans(),
        ),
      ),
    );
  }

  // Static helper to show Tajweed guide bottom sheet
  static void showTajweedLegend(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.palette_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Panduan Warna Tajwid',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...TajweedRule.rules.map((rule) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: rule.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              rule.description,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
