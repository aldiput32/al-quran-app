class BookmarkModel {
  final int surahNomor;
  final String surahNamaLatin;
  final int ayahNomor;
  final String teksArab;
  final String teksIndonesia;
  final DateTime createdAt;

  BookmarkModel({
    required this.surahNomor,
    required this.surahNamaLatin,
    required this.ayahNomor,
    required this.teksArab,
    required this.teksIndonesia,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNomor': surahNomor,
      'surahNamaLatin': surahNamaLatin,
      'ayahNomor': ayahNomor,
      'teksArab': teksArab,
      'teksIndonesia': teksIndonesia,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      surahNomor: json['surahNomor'] ?? 1,
      surahNamaLatin: json['surahNamaLatin'] ?? '',
      ayahNomor: json['ayahNomor'] ?? 1,
      teksArab: json['teksArab'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class LastReadModel {
  final int surahNomor;
  final String surahNamaLatin;
  final int ayahNomor;
  final DateTime readAt;

  LastReadModel({
    required this.surahNomor,
    required this.surahNamaLatin,
    required this.ayahNomor,
    required this.readAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNomor': surahNomor,
      'surahNamaLatin': surahNamaLatin,
      'ayahNomor': ayahNomor,
      'readAt': readAt.toIso8601String(),
    };
  }

  factory LastReadModel.fromJson(Map<String, dynamic> json) {
    return LastReadModel(
      surahNomor: json['surahNomor'] ?? 1,
      surahNamaLatin: json['surahNamaLatin'] ?? 'Al-Fatihah',
      ayahNomor: json['ayahNomor'] ?? 1,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
