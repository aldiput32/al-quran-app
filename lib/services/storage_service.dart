import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark_model.dart';

class StorageService {
  static const String _keyLastRead = 'last_read_quran';
  static const String _keyBookmarks = 'bookmarks_quran';
  static const String _keyFontSize = 'arabic_font_size';
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keySelectedQari = 'selected_qari';
  static const String _keyTajweed = 'is_tajweed_enabled';
  static const String _keyCachedSurahs = 'cached_surahs_json';

  // --- LAST READ ---
  Future<void> saveLastRead(LastReadModel lastRead) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastRead, jsonEncode(lastRead.toJson()));
  }

  Future<LastReadModel?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyLastRead);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return LastReadModel.fromJson(jsonDecode(jsonString));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // --- BOOKMARKS ---
  Future<List<BookmarkModel>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? listString = prefs.getStringList(_keyBookmarks);
    if (listString == null || listString.isEmpty) return [];

    try {
      return listString
          .map((item) => BookmarkModel.fromJson(jsonDecode(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBookmark(BookmarkModel bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    List<BookmarkModel> current = await getBookmarks();

    // Check if already bookmarked
    current.removeWhere((b) =>
        b.surahNomor == bookmark.surahNomor && b.ayahNomor == bookmark.ayahNomor);
    current.insert(0, bookmark);

    List<String> rawList =
        current.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_keyBookmarks, rawList);
  }

  Future<void> removeBookmark(int surahNomor, int ayahNomor) async {
    final prefs = await SharedPreferences.getInstance();
    List<BookmarkModel> current = await getBookmarks();
    current.removeWhere(
        (b) => b.surahNomor == surahNomor && b.ayahNomor == ayahNomor);
    List<String> rawList =
        current.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_keyBookmarks, rawList);
  }

  // --- FONT SIZE ---
  Future<void> saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, size);
  }

  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyFontSize) ?? 28.0;
  }

  // --- THEME ---
  Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  // --- QARI ---
  Future<void> saveSelectedQari(String qariId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedQari, qariId);
  }

  Future<String> getSelectedQari() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedQari) ?? '01'; // 01 is Misyari Rasyid
  }

  // --- TAJWEED ---
  Future<void> saveTajweed(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTajweed, enabled);
  }

  Future<bool> getTajweed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTajweed) ?? true;
  }

  // --- CACHED SURAHS ---
  Future<void> saveCachedSurahs(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCachedSurahs, jsonString);
  }

  Future<String?> getCachedSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCachedSurahs);
  }
}
