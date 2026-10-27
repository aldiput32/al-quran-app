import 'package:flutter/material.dart';
import '../models/bookmark_model.dart';
import '../services/storage_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  LastReadModel? _lastRead;
  List<BookmarkModel> _bookmarks = [];
  bool _isLoading = true;

  LastReadModel? get lastRead => _lastRead;
  List<BookmarkModel> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;

  BookmarkProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _lastRead = await _storageService.getLastRead();
    _bookmarks = await _storageService.getBookmarks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLastRead({
    required int surahNomor,
    required String surahNamaLatin,
    required int ayahNomor,
  }) async {
    final newLastRead = LastReadModel(
      surahNomor: surahNomor,
      surahNamaLatin: surahNamaLatin,
      ayahNomor: ayahNomor,
      readAt: DateTime.now(),
    );
    _lastRead = newLastRead;
    await _storageService.saveLastRead(newLastRead);
    notifyListeners();
  }

  bool isBookmarked(int surahNomor, int ayahNomor) {
    return _bookmarks.any(
        (b) => b.surahNomor == surahNomor && b.ayahNomor == ayahNomor);
  }

  Future<void> toggleBookmark({
    required int surahNomor,
    required String surahNamaLatin,
    required int ayahNomor,
    required String teksArab,
    required String teksIndonesia,
  }) async {
    if (isBookmarked(surahNomor, ayahNomor)) {
      _bookmarks.removeWhere(
          (b) => b.surahNomor == surahNomor && b.ayahNomor == ayahNomor);
      await _storageService.removeBookmark(surahNomor, ayahNomor);
    } else {
      final newBookmark = BookmarkModel(
        surahNomor: surahNomor,
        surahNamaLatin: surahNamaLatin,
        ayahNomor: ayahNomor,
        teksArab: teksArab,
        teksIndonesia: teksIndonesia,
        createdAt: DateTime.now(),
      );
      _bookmarks.insert(0, newBookmark);
      await _storageService.saveBookmark(newBookmark);
    }
    notifyListeners();
  }
}
