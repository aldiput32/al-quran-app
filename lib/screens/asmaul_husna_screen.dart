import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _filteredList = [];

  static const List<Map<String, dynamic>> _asmaulHusna = [
    {'no': 1, 'latin': 'Ar-Rahman', 'arab': 'الرَّحْمَٰنُ', 'arti': 'Yang Maha Pengasih'},
    {'no': 2, 'latin': 'Ar-Rahim', 'arab': 'الرَّحِيمُ', 'arti': 'Yang Maha Penyayang'},
    {'no': 3, 'latin': 'Al-Malik', 'arab': 'الْمَلِكُ', 'arti': 'Yang Maha Merajai'},
    {'no': 4, 'latin': 'Al-Quddus', 'arab': 'الْقُدُّوسُ', 'arti': 'Yang Maha Suci'},
    {'no': 5, 'latin': 'As-Salam', 'arab': 'السَّلَامُ', 'arti': 'Yang Maha Memberi Kesejahteraan'},
    {'no': 6, 'latin': 'Al-Mu\'min', 'arab': 'الْمُؤْمِنُ', 'arti': 'Yang Maha Memberi Keamanan'},
    {'no': 7, 'latin': 'Al-Muhaimin', 'arab': 'الْمُهَيْمِنُ', 'arti': 'Yang Maha Memelihara'},
    {'no': 8, 'latin': 'Al-\'Aziz', 'arab': 'الْعَزِيزُ', 'arti': 'Yang Maha Perkasa'},
    {'no': 9, 'latin': 'Al-Jabbar', 'arab': 'الْجَبَّارُ', 'arti': 'Yang Memiliki Mutlak Kegagahan'},
    {'no': 10, 'latin': 'Al-Mutakabbir', 'arab': 'الْمُتَكَبِّرُ', 'arti': 'Yang Maha Megah'},
    {'no': 11, 'latin': 'Al-Khaliq', 'arab': 'الْخَالِقُ', 'arti': 'Yang Maha Pencipta'},
    {'no': 12, 'latin': 'Al-Bari\'', 'arab': 'الْبَارِئُ', 'arti': 'Yang Maha Melepaskan'},
    {'no': 13, 'latin': 'Al-Mushawwir', 'arab': 'الْمُصَوِّرُ', 'arti': 'Yang Membentuk Rupa'},
    {'no': 14, 'latin': 'Al-Ghaffar', 'arab': 'الْغَفَّارُ', 'arti': 'Yang Maha Pengampun'},
    {'no': 15, 'latin': 'Al-Qahhar', 'arab': 'الْقَهَّارُ', 'arti': 'Yang Maha Menundukkan'},
    {'no': 16, 'latin': 'Al-Wahhab', 'arab': 'الْوَهَّابُ', 'arti': 'Yang Maha Pemberi Karunia'},
    {'no': 17, 'latin': 'Ar-Razzaq', 'arab': 'الرَّزَّاقُ', 'arti': 'Yang Maha Pemberi Rezeki'},
    {'no': 18, 'latin': 'Al-Fattah', 'arab': 'الْفَتَّاحُ', 'arti': 'Yang Maha Pembuka Rahmat'},
    {'no': 19, 'latin': 'Al-\'Alim', 'arab': 'الْعَلِيمُ', 'arti': 'Yang Maha Mengetahui'},
    {'no': 20, 'latin': 'Al-Qabidh', 'arab': 'الْقَابِضُ', 'arti': 'Yang Maha Menyempitkan'},
    {'no': 21, 'latin': 'Al-Basith', 'arab': 'الْبَاسِطُ', 'arti': 'Yang Maha Melapangkan'},
    {'no': 22, 'latin': 'Al-Khafidh', 'arab': 'الْخَافِضُ', 'arti': 'Yang Maha Merendahkan'},
    {'no': 23, 'latin': 'Ar-Rafi\'', 'arab': 'الرَّافِعُ', 'arti': 'Yang Maha Meninggikan'},
    {'no': 24, 'latin': 'Al-Mu\'izz', 'arab': 'الْمُعِزُّ', 'arti': 'Yang Maha Memuliakan'},
    {'no': 25, 'latin': 'Al-Mudzill', 'arab': 'المُذِلُّ', 'arti': 'Yang Maha Menghinakan'},
    {'no': 26, 'latin': 'As-Sami\'', 'arab': 'السَّمِيعُ', 'arti': 'Yang Maha Mendengar'},
    {'no': 27, 'latin': 'Al-Bashir', 'arab': 'الْبَصِيرُ', 'arti': 'Yang Maha Melihat'},
    {'no': 28, 'latin': 'Al-Hakam', 'arab': 'الْحَكَمُ', 'arti': 'Yang Maha Menetapkan'},
    {'no': 29, 'latin': 'Al-\'Adl', 'arab': 'الْعَدْلُ', 'arti': 'Yang Maha Adil'},
    {'no': 30, 'latin': 'Al-Lathif', 'arab': 'اللَّطِيفُ', 'arti': 'Yang Maha Lembut'},
    {'no': 31, 'latin': 'Al-Khabir', 'arab': 'الْخَبِيرُ', 'arti': 'Yang Maha Mengenal'},
    {'no': 32, 'latin': 'Al-Halim', 'arab': 'الْحَلِيمُ', 'arti': 'Yang Maha Penyantun'},
    {'no': 33, 'latin': 'Al-\'Azhim', 'arab': 'الْعَظِيمُ', 'arti': 'Yang Maha Agung'},
    {'no': 34, 'latin': 'Al-Ghafur', 'arab': 'الْغَفُورُ', 'arti': 'Yang Maha Pengampun'},
    {'no': 35, 'latin': 'Asy-Syakur', 'arab': 'الشَّكُورُ', 'arti': 'Yang Maha Pembalas Budi'},
    {'no': 36, 'latin': 'Al-\'Aliyy', 'arab': 'الْعَلِيُّ', 'arti': 'Yang Maha Tinggi'},
    {'no': 37, 'latin': 'Al-Kabir', 'arab': 'الْكَبِيرُ', 'arti': 'Yang Maha Besar'},
    {'no': 38, 'latin': 'Al-Hafizh', 'arab': 'الْحَفِيظُ', 'arti': 'Yang Maha Memelihara'},
    {'no': 39, 'latin': 'Al-Muqit', 'arab': 'الْمُقِيتُ', 'arti': 'Yang Maha Pemberi Kecukupan'},
    {'no': 40, 'latin': 'Al-Hasib', 'arab': 'الْحَسِيبُ', 'arti': 'Yang Maha Pembuat Perhitungan'},
    {'no': 41, 'latin': 'Al-Jalil', 'arab': 'الْجَلِيلُ', 'arti': 'Yang Maha Luhur'},
    {'no': 42, 'latin': 'Al-Karim', 'arab': 'الْكَرِيمُ', 'arti': 'Yang Maha Pemurah'},
    {'no': 43, 'latin': 'Ar-Raqib', 'arab': 'الرَّقِيبُ', 'arti': 'Yang Maha Mengawasi'},
    {'no': 44, 'latin': 'Al-Mujib', 'arab': 'الْمُجِيبُ', 'arti': 'Yang Maha Mengabulkan'},
    {'no': 45, 'latin': 'Al-Wasi\'', 'arab': 'الْوَاسِعُ', 'arti': 'Yang Maha Luas'},
    {'no': 46, 'latin': 'Al-Hakim', 'arab': 'الْحَكِيمُ', 'arti': 'Yang Maha Bijaksana'},
    {'no': 47, 'latin': 'Al-Wadud', 'arab': 'الْوَدُودُ', 'arti': 'Yang Maha Mengasihi'},
    {'no': 48, 'latin': 'Al-Majid', 'arab': 'الْمَجِيدُ', 'arti': 'Yang Maha Mulia'},
    {'no': 49, 'latin': 'Al-Ba\'its', 'arab': 'الْبَاعِثُ', 'arti': 'Yang Maha Membangkitkan'},
    {'no': 50, 'latin': 'Asy-Syahid', 'arab': 'الشَّهِيدُ', 'arti': 'Yang Maha Menyaksikan'},
    {'no': 51, 'latin': 'Al-Haqq', 'arab': 'الْحَقُّ', 'arti': 'Yang Maha Benar'},
    {'no': 52, 'latin': 'Al-Wakil', 'arab': 'الْوَكِيلُ', 'arti': 'Yang Maha Memelihara'},
    {'no': 53, 'latin': 'Al-Qawiyy', 'arab': 'الْقَوِيُّ', 'arti': 'Yang Maha Kuat'},
    {'no': 54, 'latin': 'Al-Matin', 'arab': 'الْمَتِينُ', 'arti': 'Yang Maha Kokoh'},
    {'no': 55, 'latin': 'Al-Waliyy', 'arab': 'الْوَلِيُّ', 'arti': 'Yang Maha Melindungi'},
    {'no': 56, 'latin': 'Al-Hamid', 'arab': 'الْحَمِيدُ', 'arti': 'Yang Maha Terpuji'},
    {'no': 57, 'latin': 'Al-Muhshi', 'arab': 'الْمُحْصِي', 'arti': 'Yang Maha Menghitung'},
    {'no': 58, 'latin': 'Al-Mubdi\'', 'arab': 'الْمُبْدِئُ', 'arti': 'Yang Maha Memulai'},
    {'no': 59, 'latin': 'Al-Mu\'id', 'arab': 'الْمُعِيدُ', 'arti': 'Yang Maha Mengembalikan Kehidupan'},
    {'no': 60, 'latin': 'Al-Muhyi', 'arab': 'الْمُحْيِي', 'arti': 'Yang Maha Menghidupkan'},
    {'no': 61, 'latin': 'Al-Mumit', 'arab': 'الْمُمِيتُ', 'arti': 'Yang Maha Mematikan'},
    {'no': 62, 'latin': 'Al-Hayy', 'arab': 'الْحَيُّ', 'arti': 'Yang Maha Hidup'},
    {'no': 63, 'latin': 'Al-Qayyum', 'arab': 'الْقَيُّومُ', 'arti': 'Yang Maha Mandiri'},
    {'no': 64, 'latin': 'Al-Wajid', 'arab': 'الْوَاجِدُ', 'arti': 'Yang Maha Menemukan'},
    {'no': 65, 'latin': 'Al-Majid', 'arab': 'الْمَاجِدُ', 'arti': 'Yang Maha Mulia'},
    {'no': 66, 'latin': 'Al-Wahid', 'arab': 'الْوَاحِدُ', 'arti': 'Yang Maha Tunggal'},
    {'no': 67, 'latin': 'Al-Ahad', 'arab': 'الْأَحَدُ', 'arti': 'Yang Maha Esa'},
    {'no': 68, 'latin': 'Ash-Shamad', 'arab': 'الصَّمَدُ', 'arti': 'Tempat Meminta Segala Sesuatu'},
    {'no': 69, 'latin': 'Al-Qadir', 'arab': 'الْقَادِرُ', 'arti': 'Yang Maha Menentukan'},
    {'no': 70, 'latin': 'Al-Muqtadir', 'arab': 'الْمُقْتَدِرُ', 'arti': 'Yang Maha Berkuasa'},
    {'no': 71, 'latin': 'Al-Muqaddim', 'arab': 'الْمُقَدِّمُ', 'arti': 'Yang Maha Mendahulukan'},
    {'no': 72, 'latin': 'Al-Mu\'akhkhir', 'arab': 'الْمُؤَخِّرُ', 'arti': 'Yang Maha Mengakhirkan'},
    {'no': 73, 'latin': 'Al-Awwal', 'arab': 'الْأَوَّلُ', 'arti': 'Yang Maha Awal'},
    {'no': 74, 'latin': 'Al-Akhir', 'arab': 'الْآخِرُ', 'arti': 'Yang Maha Akhir'},
    {'no': 75, 'latin': 'Azh-Zhahir', 'arab': 'الظَّاهِرُ', 'arti': 'Yang Maha Nyata'},
    {'no': 76, 'latin': 'Al-Bathin', 'arab': 'الْبَاطِنُ', 'arti': 'Yang Maha Ghaib'},
    {'no': 77, 'latin': 'Al-Wali', 'arab': 'الْوَالِي', 'arti': 'Yang Maha Memerintah'},
    {'no': 78, 'latin': 'Al-Muta\'ali', 'arab': 'الْمُتَعَالِي', 'arti': 'Yang Maha Tinggi'},
    {'no': 79, 'latin': 'Al-Barr', 'arab': 'الْبَرُّ', 'arti': 'Yang Maha Penderma'},
    {'no': 80, 'latin': 'At-Tawwab', 'arab': 'التَّوَّابُ', 'arti': 'Yang Maha Penerima Taubat'},
    {'no': 81, 'latin': 'Al-Muntaqim', 'arab': 'الْمُنْتَقِمُ', 'arti': 'Yang Maha Pemberi Balasan'},
    {'no': 82, 'latin': 'Al-\'Afuww', 'arab': 'الْعَفُوُّ', 'arti': 'Yang Maha Pemaaf'},
    {'no': 83, 'latin': 'Ar-Ra\'uf', 'arab': 'الرَّءُوفُ', 'arti': 'Yang Maha Pengasuh'},
    {'no': 84, 'latin': 'Malikul Mulk', 'arab': 'مَالِكُ الْمُلْكِ', 'arti': 'Penguasa Kerajaan Semesta'},
    {'no': 85, 'latin': 'Dzul Jalali wal Ikram', 'arab': 'ذُو الْجَلَالِ وَالْإِكْرَامِ', 'arti': 'Pemilik Keagungan dan Kemuliaan'},
    {'no': 86, 'latin': 'Al-Muqsit', 'arab': 'الْمُقْسِطُ', 'arti': 'Yang Maha Pemberi Keadilan'},
    {'no': 87, 'latin': 'Al-Jami\'', 'arab': 'الْجَامِعُ', 'arti': 'Yang Maha Mengumpulkan'},
    {'no': 88, 'latin': 'Al-Ghaniyy', 'arab': 'الْغَنِيُّ', 'arti': 'Yang Maha Kaya'},
    {'no': 89, 'latin': 'Al-Mughni', 'arab': 'الْمُغْنِي', 'arti': 'Yang Maha Memberi Kekayaan'},
    {'no': 90, 'latin': 'Al-Mani\'', 'arab': 'الْمَانِعُ', 'arti': 'Yang Maha Mencegah'},
    {'no': 91, 'latin': 'Adh-Dharr', 'arab': 'الضَّارُّ', 'arti': 'Yang Maha Penimpa Kemudharatan'},
    {'no': 92, 'latin': 'An-Nafi\'', 'arab': 'النَّافِعُ', 'arti': 'Yang Maha Memberi Manfaat'},
    {'no': 93, 'latin': 'An-Nur', 'arab': 'النُّورُ', 'arti': 'Yang Maha Bercahaya'},
    {'no': 94, 'latin': 'Al-Hadi', 'arab': 'الْهَادِي', 'arti': 'Yang Maha Pemberi Petunjuk'},
    {'no': 95, 'latin': 'Al-Badi\'', 'arab': 'الْبَدِيعُ', 'arti': 'Yang Maha Pencipta Keindahan'},
    {'no': 96, 'latin': 'Al-Baqi', 'arab': 'الْبَاقِي', 'arti': 'Yang Maha Kekal'},
    {'no': 97, 'latin': 'Al-Warits', 'arab': 'الْوَارِثُ', 'arti': 'Yang Maha Mewarisi'},
    {'no': 98, 'latin': 'Ar-Rasyid', 'arab': 'الرَّشِيدُ', 'arti': 'Yang Maha Pandai dan Bijak'},
    {'no': 99, 'latin': 'Ash-Shabur', 'arab': 'الصَّبُورُ', 'arti': 'Yang Maha Sabar'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(_asmaulHusna);
  }

  void _filter(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredList = List.from(_asmaulHusna);
      } else {
        _filteredList = _asmaulHusna.where((item) {
          return item['latin'].toLowerCase().contains(q) ||
              item['arti'].toLowerCase().contains(q) ||
              item['no'].toString() == q;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('99 Asmaul Husna'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: 'Cari Asmaul Husna (nama atau arti)...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final item = _filteredList[index];

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item['no']}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Text(
                            item['arab'],
                            style: GoogleFonts.amiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item['latin'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['arti'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
