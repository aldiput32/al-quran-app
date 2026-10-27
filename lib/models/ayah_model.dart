class AyahModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, dynamic> audio;

  AyahModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      audio: json['audio'] is Map<String, dynamic>
          ? json['audio']
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': audio,
    };
  }

  String getAudioUrl(String qariId) {
    if (audio.containsKey(qariId)) {
      return audio[qariId] ?? '';
    }
    if (audio.containsKey('01')) return audio['01'] ?? '';
    return audio.values.isNotEmpty ? audio.values.first.toString() : '';
  }
}
