import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/storage_service.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final StorageService _storageService = StorageService();

  bool _isPlaying = false;
  bool _isLoading = false;
  String _currentAudioUrl = '';
  int? _activeSurahNomor;
  int? _activeAyahNomor; // null if playing full surah
  String _selectedQari = '01'; // Default: Misyari Rasyid
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Qari options
  static const Map<String, String> qariOptions = {
    '01': 'Abdullah Al-Juhany',
    '02': 'Abdul Muhsin Al-Qasim',
    '03': 'Abdurrahman As-Sudais',
    '04': 'Ibrahim Al-Dossari',
    '05': 'Misyari Rasyid Al-Afasy',
  };

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  int? get activeSurahNomor => _activeSurahNomor;
  int? get activeAyahNomor => _activeAyahNomor;
  String get selectedQari => _selectedQari;
  Duration get duration => _duration;
  Duration get position => _position;
  AudioPlayer get player => _player;

  AudioPlayerProvider() {
    _init();
  }

  Function(int surahNomor, int ayahNomor)? onAyahCompleted;

  void setOnAyahCompleted(Function(int surahNomor, int ayahNomor)? callback) {
    onAyahCompleted = callback;
  }

  void _init() async {
    _selectedQari = await _storageService.getSelectedQari();
    notifyListeners();

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.buffering ||
          state.processingState == ProcessingState.loading;

      if (state.processingState == ProcessingState.completed) {
        if (_activeAyahNomor != null && onAyahCompleted != null) {
          final sNomor = _activeSurahNomor!;
          final aNomor = _activeAyahNomor!;
          onAyahCompleted!(sNomor, aNomor);
        } else {
          stopAudio();
        }
      }
      notifyListeners();
    });

    _player.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });

    _player.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> changeQari(String qariId) async {
    _selectedQari = qariId;
    await _storageService.saveSelectedQari(qariId);
    notifyListeners();
  }

  bool isAyahActive(int surahNomor, int ayahNomor) {
    return _activeSurahNomor == surahNomor &&
        _activeAyahNomor == ayahNomor &&
        (_isPlaying || _isLoading);
  }

  bool isFullSurahActive(int surahNomor) {
    return _activeSurahNomor == surahNomor &&
        _activeAyahNomor == null &&
        (_isPlaying || _isLoading);
  }

  Future<void> playAyah({
    required int surahNomor,
    required int ayahNomor,
    required String audioUrl,
  }) async {
    if (isAyahActive(surahNomor, ayahNomor)) {
      await pauseAudio();
      return;
    }

    try {
      _isLoading = true;
      _activeSurahNomor = surahNomor;
      _activeAyahNomor = ayahNomor;
      _currentAudioUrl = audioUrl;
      notifyListeners();

      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      _isLoading = false;
      _activeAyahNomor = null;
      notifyListeners();
    }
  }

  Future<void> playFullSurah({
    required int surahNomor,
    required String audioUrl,
  }) async {
    if (isFullSurahActive(surahNomor)) {
      await pauseAudio();
      return;
    }

    try {
      _isLoading = true;
      _activeSurahNomor = surahNomor;
      _activeAyahNomor = null;
      _currentAudioUrl = audioUrl;
      notifyListeners();

      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      _isLoading = false;
      _activeSurahNomor = null;
      notifyListeners();
    }
  }

  Future<void> pauseAudio() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> resumeAudio() async {
    await _player.play();
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await _player.stop();
    _activeSurahNomor = null;
    _activeAyahNomor = null;
    _position = Duration.zero;
    notifyListeners();
  }

  Future<void> seekAudio(Duration pos) async {
    await _player.seek(pos);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
