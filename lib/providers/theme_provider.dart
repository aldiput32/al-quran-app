import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isDarkMode = false;
  double _arabicFontSize = 28.0;
  bool _isTajweedEnabled = true;

  bool get isDarkMode => _isDarkMode;
  double get arabicFontSize => _arabicFontSize;
  bool get isTajweedEnabled => _isTajweedEnabled;

  ThemeProvider() {
    _loadPreferences();
  }

  void _loadPreferences() async {
    _isDarkMode = await _storageService.getDarkMode();
    _arabicFontSize = await _storageService.getFontSize();
    _isTajweedEnabled = await _storageService.getTajweed();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size;
    await _storageService.saveFontSize(size);
    notifyListeners();
  }

  Future<void> toggleTajweed() async {
    _isTajweedEnabled = !_isTajweedEnabled;
    await _storageService.saveTajweed(_isTajweedEnabled);
    notifyListeners();
  }
}
