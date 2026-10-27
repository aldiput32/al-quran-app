class DoaModel {
  final String id;
  final String doa;
  final String ayat;
  final String latin;
  final String artinya;

  DoaModel({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      id: json['id']?.toString() ?? '',
      doa: json['doa'] ?? '',
      ayat: json['ayat'] ?? '',
      latin: json['latin'] ?? '',
      artinya: json['artinya'] ?? '',
    );
  }
}
