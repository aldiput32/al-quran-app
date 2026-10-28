import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/doa_model.dart';
import '../services/quran_api_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final QuranApiService _apiService = QuranApiService();
  final StorageService _storageService = StorageService();

  List<DoaModel> _doaList = [];
  List<DoaModel> _filteredList = [];
  List<String> _categories = ['Semua'];
  String _selectedCategory = 'Semua';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDoaData();
  }

  Future<void> _loadDoaData() async {
    // 1. Try local cache first for instant UI response
    final cachedJson = await _storageService.getCachedDoa();
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(cachedJson);
        final cached = list.map((item) => DoaModel.fromJson(item)).toList();
        if (cached.isNotEmpty && mounted) {
          _updateListState(cached, loading: false);
        }
      } catch (_) {}
    }

    // 2. Fetch fresh data from API
    try {
      final freshData = await _apiService.getDailyDoa();
      if (freshData.isNotEmpty && mounted) {
        _updateListState(freshData, loading: false);

        // Save to local cache
        final jsonStr = jsonEncode(freshData.map((d) => d.toJson()).toList());
        await _storageService.saveCachedDoa(jsonStr);
      }
    } catch (_) {
      if (_doaList.isEmpty && mounted) {
        _updateListState(QuranApiService.fallbackDoa, loading: false);
      }
    }
  }

  void _updateListState(List<DoaModel> data, {required bool loading}) {
    // Extract unique categories
    final Set<String> groupSet = {'Semua'};
    for (var d in data) {
      if (d.grup.isNotEmpty) {
        groupSet.add(d.grup);
      }
    }

    setState(() {
      _doaList = data;
      _categories = groupSet.toList();
      _isLoading = loading;
      _applyFilter();
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredList = _doaList.where((d) {
        final matchesCat = _selectedCategory == 'Semua' || d.grup == _selectedCategory;
        if (!matchesCat) return false;

        if (query.isEmpty) return true;

        final nameMatch = d.doa.toLowerCase().contains(query);
        final artinyaMatch = d.artinya.toLowerCase().contains(query);
        final latinMatch = d.latin.toLowerCase().contains(query);
        final tagMatch = d.tag.any((t) => t.toLowerCase().contains(query));

        return nameMatch || artinyaMatch || latinMatch || tagMatch;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kumpulan Doa Harian',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_doaList.isNotEmpty)
              Text(
                '${_doaList.length} Doa Shahih & Pilihan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _searchController.clear();
          await _loadDoaData();
        },
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
                    hintText: 'Cari doa (misal: tidur, makan, orang tua)...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Category Chips if categories exist
            if (_categories.length > 1)
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: _categories.length,
                  itemBuilder: (context, idx) {
                    final cat = _categories[idx];
                    final isSelected = cat == _selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(
                          cat,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                        checkmarkColor: Colors.white,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = cat;
                            _applyFilter();
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

            // Content List
            Expanded(
              child: _isLoading && _doaList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 56,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Doa tidak ditemukan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Coba gunakan kata kunci pencarian yang lain.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final item = _filteredList[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Category Tag & Title Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (item.grup.isNotEmpty) ...[
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryContainer
                                                      .withOpacity(isDark ? 0.2 : 0.6),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  item.grup,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? AppColors.primaryLight
                                                        : AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                            ],
                                            Text(
                                              item.doa,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? AppColors.primaryLight
                                                    : AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        tooltip: 'Salin Doa',
                                        icon: const Icon(Icons.copy_rounded),
                                        onPressed: () {
                                          final copyText =
                                              '${item.doa}\n\n${item.ayat}\n\n${item.latin.isNotEmpty ? "${item.latin}\n\n" : ""}"${item.artinya}"${item.tentang.isNotEmpty ? "\n\n(${item.tentang})" : ""}';
                                          Clipboard.setData(ClipboardData(text: copyText));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${item.doa} disalin ke clipboard'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // Arabic Calligraphy Text
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      item.ayat,
                                      style: GoogleFonts.amiri(
                                        fontSize: 22,
                                        height: 2.0,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),

                                  // Latin Transliteration
                                  if (item.latin.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      item.latin,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: isDark
                                            ? AppColors.primaryLight
                                            : AppColors.primary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],

                                  // Indonesian Meaning
                                  const SizedBox(height: 8),
                                  Text(
                                    item.artinya,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),

                                  // Hadith Reference (Tentang)
                                  if (item.tentang.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.surfaceDark
                                            : AppColors.backgroundLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.info_outline_rounded,
                                              size: 14, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              item.tentang.trim(),
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                color: Colors.grey,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
