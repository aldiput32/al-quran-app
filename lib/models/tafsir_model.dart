class TafsirAyahModel {
  final int ayat;
  final String teks;

  TafsirAyahModel({
    required this.ayat,
    required this.teks,
  });

  factory TafsirAyahModel.fromJson(Map<String, dynamic> json) {
    return TafsirAyahModel(
      ayat: json['ayat'] ?? 0,
      teks: json['teks'] ?? '',
    );
  }
}

class SurahTafsirModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<TafsirAyahModel> tafsir;

  SurahTafsirModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.tafsir,
  });

  factory SurahTafsirModel.fromJson(Map<String, dynamic> json) {
    var rawTafsir = json['tafsir'] as List<dynamic>? ?? [];
    List<TafsirAyahModel> parsedTafsir =
        rawTafsir.map((e) => TafsirAyahModel.fromJson(e)).toList();

    return SurahTafsirModel(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tafsir: parsedTafsir,
    );
  }
}
