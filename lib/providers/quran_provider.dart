import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/surah_model.dart';
import '../models/surah_detail_model.dart';
import '../models/tafsir_model.dart';
import '../services/quran_api_service.dart';
import '../services/storage_service.dart';

class QuranProvider extends ChangeNotifier {
  final QuranApiService _apiService = QuranApiService();
  final StorageService _storageService = StorageService();

  List<SurahModel> _surahList = [];
  List<SurahModel> _filteredSurahList = [];
  bool _isLoadingList = false;
  String _errorMessage = '';
  String _searchQuery = '';

  // Detail Surah State
  SurahDetailModel? _currentSurahDetail;
  bool _isLoadingDetail = false;
  String _detailErrorMessage = '';

  // Tafsir State
  SurahTafsirModel? _currentTafsir;
  bool _isLoadingTafsir = false;

  // Getters
  List<SurahModel> get surahList => _filteredSurahList;
  bool get isLoadingList => _isLoadingList;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  SurahDetailModel? get currentSurahDetail => _currentSurahDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String get detailErrorMessage => _detailErrorMessage;

  SurahTafsirModel? get currentTafsir => _currentTafsir;
  bool get isLoadingTafsir => _isLoadingTafsir;

  Future<void> loadSurahList() async {
    // 1. Try to load cached surahs instantly for offline / fast startup
    if (_surahList.isEmpty) {
      final cachedJson = await _storageService.getCachedSurahs();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final List<dynamic> list = jsonDecode(cachedJson);
          _surahList = list.map((item) => SurahModel.fromJson(item)).toList();
          _filteredSurahList = List.from(_surahList);
          notifyListeners();
        } catch (_) {}
      }
    }

    if (_surahList.isEmpty) {
      _isLoadingList = true;
      _errorMessage = '';
      notifyListeners();
    }

    try {
      final fetchedList = await _apiService.getAllSurah();
      _surahList = fetchedList;
      _filteredSurahList = List.from(_surahList);
      _isLoadingList = false;
      _errorMessage = '';
      notifyListeners();

      // Save to local cache
      final jsonStr = jsonEncode(_surahList.map((s) => s.toJson()).toList());
      await _storageService.saveCachedSurahs(jsonStr);
    } catch (e) {
      _isLoadingList = false;
      // If we already have cached data, don't show full-page error
      if (_surahList.isEmpty) {
        _errorMessage = e.toString();
      }
      notifyListeners();
    }
  }

  void searchSurah(String query) {
    _searchQuery = query.trim().toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredSurahList = List.from(_surahList);
    } else {
      _filteredSurahList = _surahList.where((surah) {
        final nameMatch = surah.namaLatin.toLowerCase().contains(_searchQuery);
        final artiMatch = surah.arti.toLowerCase().contains(_searchQuery);
        final nomorMatch = surah.nomor.toString() == _searchQuery;
        return nameMatch || artiMatch || nomorMatch;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> loadSurahDetail(int nomor) async {
    _isLoadingDetail = true;
    _detailErrorMessage = '';
    _currentSurahDetail = null;
    notifyListeners();

    try {
      _currentSurahDetail = await _apiService.getSurahDetail(nomor);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _isLoadingDetail = false;
      _detailErrorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadSurahTafsir(int nomor) async {
    _isLoadingTafsir = true;
    _currentTafsir = null;
    notifyListeners();

    try {
      _currentTafsir = await _apiService.getSurahTafsir(nomor);
      _isLoadingTafsir = false;
      notifyListeners();
    } catch (e) {
      _isLoadingTafsir = false;
      notifyListeners();
    }
  }
}
