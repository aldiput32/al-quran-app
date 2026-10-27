import 'package:flutter/material.dart';

class TajweedRule {
  final String name;
  final String description;
  final Color color;
  final String example;

  const TajweedRule({
    required this.name,
    required this.description,
    required this.color,
    required this.example,
  });

  static const List<TajweedRule> rules = [
    TajweedRule(
      name: 'Ikhfa Haqiqi & Syafawi',
      description: 'Dibaca samar-samar dengan dengung 2 harakat.',
      color: Color(0xFF10B981), // Emerald Green
      example: 'مِنْ قَبْلِكُمْ , أَنْفُسَكُمْ',
    ),
    TajweedRule(
      name: 'Qalqalah (Sugro & Kubro)',
      description: 'Huruf memantul (ق ط ب ج د) ketika sukun atau waqaf.',
      color: Color(0xFF0284C7), // Sky Blue
      example: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
    ),
    TajweedRule(
      name: 'Ghunnah Musyaddadah',
      description: 'Dengung 2 harakat pada huruf Nun atau Mim bertasydid.',
      color: Color(0xFFF97316), // Orange
      example: 'إِنَّ , عَمَّ',
    ),
    TajweedRule(
      name: 'Iqlab',
      description: 'Nun sukun atau tanwin bertemu Ba, ditukar menjadi Mim samar.',
      color: Color(0xFFD97706), // Amber / Gold
      example: 'مِنْ بَعْدِ',
    ),
    TajweedRule(
      name: 'Mad Wajib / Jaiz Munfashil',
      description: 'Dibaca panjang 4 sampai 5/6 harakat.',
      color: Color(0xFFE11D48), // Rose / Red
      example: 'إِذَا جَاءَ , بِمَا أُنْزِلَ',
    ),
    TajweedRule(
      name: 'Idgham Bighunnah',
      description: 'Melebur dengan dengung saat bertemu Ya, Nun, Mim, Wawu.',
      color: Color(0xFF8B5CF6), // Purple
      example: 'مَنْ يَقُولُ',
    ),
  ];
}
