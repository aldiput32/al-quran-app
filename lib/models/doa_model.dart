class DoaModel {
  final String id;
  final String doa;
  final String ayat;
  final String latin;
  final String artinya;
  final String grup;
  final String tentang;
  final List<String> tag;

  DoaModel({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
    this.grup = '',
    this.tentang = '',
    this.tag = const [],
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags = [];
    if (json['tag'] is List) {
      parsedTags = (json['tag'] as List).map((t) => t.toString()).toList();
    }

    return DoaModel(
      id: json['id']?.toString() ?? '',
      doa: (json['nama'] ?? json['doa'] ?? '').toString(),
      ayat: (json['ar'] ?? json['ayat'] ?? '').toString(),
      latin: (json['tr'] ?? json['latin'] ?? '').toString(),
      artinya: (json['idn'] ?? json['artinya'] ?? '').toString(),
      grup: (json['grup'] ?? '').toString(),
      tentang: (json['tentang'] ?? '').toString(),
      tag: parsedTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': doa,
      'doa': doa,
      'ar': ayat,
      'ayat': ayat,
      'tr': latin,
      'latin': latin,
      'idn': artinya,
      'artinya': artinya,
      'grup': grup,
      'tentang': tentang,
      'tag': tag,
    };
  }
}

