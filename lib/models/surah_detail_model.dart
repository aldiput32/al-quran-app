import 'ayah_model.dart';

class SurahDetailModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, dynamic> audioFull;
  final List<AyahModel> ayat;
  final dynamic suratSebelumnya;
  final dynamic suratSelanjutnya;

  SurahDetailModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
    this.suratSebelumnya,
    this.suratSelanjutnya,
  });

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    var rawAyat = json['ayat'] as List<dynamic>? ?? [];
    List<AyahModel> parsedAyat =
        rawAyat.map((item) => AyahModel.fromJson(item)).toList();

    return SurahDetailModel(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audioFull: json['audioFull'] is Map<String, dynamic>
          ? json['audioFull']
          : <String, dynamic>{},
      ayat: parsedAyat,
      suratSebelumnya: json['suratSebelumnya'],
      suratSelanjutnya: json['suratSelanjutnya'],
    );
  }

  String get fullAudioUrl {
    if (audioFull.containsKey('01')) return audioFull['01'] ?? '';
    if (audioFull.containsKey('05')) return audioFull['05'] ?? '';
    return audioFull.values.isNotEmpty ? audioFull.values.first.toString() : '';
  }
}
