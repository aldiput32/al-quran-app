import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _totalCounter = 0;
  int _target = 33;
  int _round = 1;

  final List<Map<String, String>> _dhikrPresets = [
    {
      'title': 'Subhanallah',
      'arabic': 'سُبْحَانَ اللَّهِ',
      'meaning': 'Maha Suci Allah',
    },
    {
      'title': 'Alhamdulillah',
      'arabic': 'الْحَمْدُ لِلَّهِ',
      'meaning': 'Segala Puji Bagi Allah',
    },
    {
      'title': 'Allahu Akbar',
      'arabic': 'اللَّهُ أَكْبَرُ',
      'meaning': 'Allah Maha Besar',
    },
    {
      'title': 'Astaghfirullah',
      'arabic': 'أَسْتَغْفِرُ اللَّهَ',
      'meaning': 'Aku memohon ampun kepada Allah',
    },
    {
      'title': 'Laa Ilaha Illallah',
      'arabic': 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      'meaning': 'Tiada Tuhan selain Allah',
    },
    {
      'title': 'Shalawat Nabi',
      'arabic': 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      'meaning': 'Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad',
    },
  ];

  int _selectedPresetIndex = 0;

  void _incrementCounter() {
    HapticFeedback.lightImpact();

    setState(() {
      _counter++;
      _totalCounter++;

      if (_counter >= _target) {
        // Milestone reached!
        HapticFeedback.heavyImpact();
        _counter = 0;
        _round++;
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _round = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentDhikr = _dhikrPresets[_selectedPresetIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih Digital'),
        actions: [
          IconButton(
            tooltip: 'Reset Hitungan',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reset,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              // Dhikr Selector Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedPresetIndex,
                    isExpanded: true,
                    items: List.generate(_dhikrPresets.length, (idx) {
                      return DropdownMenuItem(
                        value: idx,
                        child: Text(
                          _dhikrPresets[idx]['title']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedPresetIndex = val;
                          _reset();
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Arabic Dhikr Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      currentDhikr['arabic']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.primaryLight
                            : AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${currentDhikr['meaning']!}"',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Giant Circular Tap Button
              GestureDetector(
                onTap: _incrementCounter,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_counter',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 68,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/ $_target',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Stats Row (Putaran & Total)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Putaran ke-', '$_round'),
                  Container(width: 1, height: 32, color: Colors.grey.shade300),
                  _buildStatItem('Total Dzikir', '$_totalCounter'),
                  Container(width: 1, height: 32, color: Colors.grey.shade300),
                  _buildStatItem('Target', '$_target'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
