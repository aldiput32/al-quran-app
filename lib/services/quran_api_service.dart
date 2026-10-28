import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';
import '../models/surah_detail_model.dart';
import '../models/tafsir_model.dart';
import '../models/doa_model.dart';

class QuranApiService {
  static const String baseUrl = 'https://equran.id/api/v2';
  static const String doaUrl = 'https://equran.id/api/doa';

  // Fetch all 114 surahs
  Future<List<SurahModel>> getAllSurah() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat')).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] ?? [];
        return data.map((json) => SurahModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data surah (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  // Fetch detail of a surah (all ayat with Arabic, Latin, and Indonesian translation)
  Future<SurahDetailModel> getSurahDetail(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$nomor')).timeout(
            const Duration(seconds: 20),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic data = body['data'];
        if (data != null) {
          return SurahDetailModel.fromJson(data);
        } else {
          throw Exception('Data surat tidak ditemukan');
        }
      } else {
        throw Exception('Gagal memuat detail surat ($nomor)');
      }
    } catch (e) {
      throw Exception('Gagal mengambil ayat: $e');
    }
  }

  // Fetch Tafsir of a surah
  Future<SurahTafsirModel> getSurahTafsir(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tafsir/$nomor')).timeout(
            const Duration(seconds: 20),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic data = body['data'];
        return SurahTafsirModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat tafsir surat ($nomor)');
      }
    } catch (e) {
      throw Exception('Gagal mengambil tafsir: $e');
    }
  }

  // Fetch Daily Doa with local cache fallback
  Future<List<DoaModel>> getDailyDoa() async {
    try {
      final response = await http.get(Uri.parse(doaUrl)).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> list = [];
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          list = decoded['data'];
        }
        final parsed = list.map((item) => DoaModel.fromJson(item)).toList();
        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
      return fallbackDoa;
    } catch (e) {
      return fallbackDoa;
    }
  }

  // Essential offline fallback prayers
  static final List<DoaModel> fallbackDoa = [
    DoaModel(
      id: '1',
      doa: 'Doa Sebelum Tidur',
      ayat: 'بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ',
      latin: 'Bismikallaahumma ahyaa wa amuutu.',
      artinya: 'Dengan nama-Mu ya Allah, aku hidup dan aku mati.',
      grup: 'Tidur',
      tentang: 'HR. Bukhari no. 6324 & Muslim no. 2711.',
      tag: ['tidur', 'malam'],
    ),
    DoaModel(
      id: '2',
      doa: 'Doa Bangun Tidur',
      ayat: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      latin: 'Alhamdu lillaahil-ladzii ahyaanaa ba\'da maa amaatanaa wa ilaihin-nusyuur.',
      artinya: 'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya kami kembali.',
      grup: 'Tidur',
      tentang: 'HR. Bukhari no. 6312.',
      tag: ['tidur', 'pagi'],
    ),
    DoaModel(
      id: '3',
      doa: 'Doa Sebelum Makan',
      ayat: 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ',
      latin: 'Allahumma baarik lanaa fiimaa razaqtanaa wa qinaa \'adzaaban naar.',
      artinya: 'Ya Allah, berkahilah kami dalam rezeki yang telah Engkau berikan kepada kami dan peliharalah kami dari siksa api neraka.',
      grup: 'Makan & Minum',
      tentang: 'HR. Ibnu Sunni no. 457.',
      tag: ['makan', 'makanan'],
    ),
    DoaModel(
      id: '4',
      doa: 'Doa Sesudah Makan',
      ayat: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      latin: 'Alhamdu lillaahil-ladzii ath\'amanaa wa saqaanaa wa ja\'alanaa muslimiin.',
      artinya: 'Segala puji bagi Allah yang telah memberi makan kami dan memberi minum kami, dan menjadikan kami orang-orang muslim.',
      grup: 'Makan & Minum',
      tentang: 'HR. Abu Dawud no. 3850 & Tirmidzi no. 3457.',
      tag: ['makan', 'syukur'],
    ),
    DoaModel(
      id: '5',
      doa: 'Doa Masuk Masjid',
      ayat: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      latin: 'Allahummaf-tah lii abwaaba rahmatik.',
      artinya: 'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.',
      grup: 'Masjid & Sholat',
      tentang: 'HR. Muslim no. 713.',
      tag: ['masjid', 'sholat'],
    ),
    DoaModel(
      id: '6',
      doa: 'Doa Keluar Masjid',
      ayat: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      latin: 'Allahumma innii as-aluka min fadhlik.',
      artinya: 'Ya Allah, sesungguhnya aku memohon keutamaan dari-Mu.',
      grup: 'Masjid & Sholat',
      tentang: 'HR. Muslim no. 713.',
      tag: ['masjid', 'keluar'],
    ),
    DoaModel(
      id: '7',
      doa: 'Doa untuk Kedua Orang Tua',
      ayat: 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      latin: 'Rabbighfir lii wa liwaalidayya warhamhumaa kamaa rabbayaanii shaghiiraa.',
      artinya: 'Wahai Tuhanku, ampunilah aku dan kedua orang tuaku, dan sayangilah mereka berdua sebagaimana mereka telah menyayangiku di waktu kecil.',
      grup: 'Keluarga & Orang Tua',
      tentang: 'QS. Al-Isra [17]: 24.',
      tag: ['orang tua', 'ibu', 'ayah'],
    ),
    DoaModel(
      id: '8',
      doa: 'Doa Kebaikan Dunia dan Akhirat (Sapu Jagad)',
      ayat: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      latin: 'Rabbanaa aatinaa fid-dunyaa hasanatan wa fil-aakhirati hasanatan wa qinaa \'adzaaban-naar.',
      artinya: 'Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat, dan lindungilah kami dari siksa neraka.',
      grup: 'Umum & Hajat',
      tentang: 'QS. Al-Baqarah [2]: 201 & HR. Bukhari no. 4522.',
      tag: ['sapu jagad', 'keselamatan'],
    ),
    DoaModel(
      id: '9',
      doa: 'Doa Keluar Rumah',
      ayat: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      latin: 'Bismillaahi tawakkaltu \'alallaahi laa hawla wa laa quwwata illaa billaah.',
      artinya: 'Dengan nama Allah, aku bertawakal kepada Allah, tiada daya dan kekuatan kecuali dengan pertolongan Allah.',
      grup: 'Perjalanan & Rumah',
      tentang: 'HR. Abu Dawud no. 5095 & Tirmidzi no. 3426.',
      tag: ['rumah', 'perjalanan'],
    ),
    DoaModel(
      id: '10',
      doa: 'Doa Masuk Rumah',
      ayat: 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
      latin: 'Bismillaahi walajnaa, wa bismillaahi kharajnaa, wa \'alaa rabbinaa tawakkalnaa.',
      artinya: 'Dengan nama Allah kami masuk, dan dengan nama Allah kami keluar, dan kepada Tuhan kami, kami bertawakal.',
      grup: 'Perjalanan & Rumah',
      tentang: 'HR. Abu Dawud no. 5096.',
      tag: ['rumah', 'masuk'],
    ),
    DoaModel(
      id: '11',
      doa: 'Doa Naik Kendaraan',
      ayat: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ',
      latin: 'Subhaanal-ladzii sakh-khara lanaa haadzaa wa maa kunnaa lahuu muqriniin, wa innaa ilaa rabbinaa lamunqalibuun.',
      artinya: 'Maha Suci Allah yang telah menundukkan semua ini bagi kami padahal kami sebelumnya tidak mampu menguasainya, dan sesungguhnya kami akan kembali kepada Tuhan kami.',
      grup: 'Perjalanan & Rumah',
      tentang: 'QS. Az-Zukhruf [43]: 13-14.',
      tag: ['perjalanan', 'kendaraan'],
    ),
    DoaModel(
      id: '12',
      doa: 'Doa Memohon Kemudahan Urusan',
      ayat: 'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
      latin: 'Allahumma laa sahla illaa maa ja\'altahuu sahlan, wa anta taj\'alul-hazna idzaa syi\'ta sahlan.',
      artinya: 'Ya Allah, tidak ada kemudahan kecuali apa yang Engkau jadikan mudah, dan Engkau menjadikan kesulitan jika Engkau menghendaki menjadi mudah.',
      grup: 'Umum & Hajat',
      tentang: 'HR. Ibnu Hibban no. 327.',
      tag: ['hajat', 'kemudahan', 'ujian'],
    ),
  ];
}
