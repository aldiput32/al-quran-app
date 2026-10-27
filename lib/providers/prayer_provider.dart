import 'dart:async';
import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_setting_model.dart';
import '../services/prayer_service.dart';

class PrayerProvider extends ChangeNotifier {
  final PrayerService _prayerService = PrayerService();
  final AudioPlayer _adzanPlayer = AudioPlayer();

  CityLocation _selectedCity = PrayerService.defaultCities[0]; // Jakarta default
  PrayerTimes? _todayPrayerTimes;
  PrayerSettingModel _settings = PrayerSettingModel();

  Timer? _countdownTimer;
  String _nextPrayerName = '';
  Duration _timeUntilNextPrayer = Duration.zero;

  bool _isTestingAdzan = false;
  String? _testingAdzanKey;

  // Getters
  CityLocation get selectedCity => _selectedCity;
  PrayerTimes? get todayPrayerTimes => _todayPrayerTimes;
  PrayerSettingModel get settings => _settings;
  String get nextPrayerName => _nextPrayerName;
  Duration get timeUntilNextPrayer => _timeUntilNextPrayer;
  bool get isTestingAdzan => _isTestingAdzan;
  String? get testingAdzanKey => _testingAdzanKey;

  PrayerProvider() {
    _init();
  }

  void _init() async {
    await _loadPreferences();
    _recalculateTimes();
    _startCountdownTimer();

    _adzanPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isTestingAdzan = false;
        _testingAdzanKey = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cityName = prefs.getString('prayer_city_name');
    if (cityName != null) {
      _selectedCity = PrayerService.defaultCities.firstWhere(
        (c) => c.name == cityName,
        orElse: () => PrayerService.defaultCities[0],
      );
    }

    final settingsJson = prefs.getString('prayer_settings');
    if (settingsJson != null) {
      try {
        _settings = PrayerSettingModel.fromJson(jsonDecode(settingsJson));
      } catch (_) {}
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_settings', jsonEncode(_settings.toJson()));
    await prefs.setString('prayer_city_name', _selectedCity.name);
    notifyListeners();
  }

  void setCity(CityLocation city) {
    _selectedCity = city;
    _recalculateTimes();
    saveSettings();
  }

  void _recalculateTimes() {
    _todayPrayerTimes = _prayerService.calculatePrayerTimes(_selectedCity);
    _updateNextPrayer();
    notifyListeners();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateNextPrayer();
    });
  }

  void _updateNextPrayer() {
    if (_todayPrayerTimes == null) return;

    final now = DateTime.now();
    final nextPrayer = _todayPrayerTimes!.nextPrayer();

    DateTime? nextTime;
    String name = '';

    switch (nextPrayer) {
      case Prayer.fajr:
        name = 'Subuh';
        nextTime = _todayPrayerTimes!.fajr;
        break;
      case Prayer.sunrise:
        name = 'Terbit';
        nextTime = _todayPrayerTimes!.sunrise;
        break;
      case Prayer.dhuhr:
        name = 'Dzuhur';
        nextTime = _todayPrayerTimes!.dhuhr;
        break;
      case Prayer.asr:
        name = 'Ashar';
        nextTime = _todayPrayerTimes!.asr;
        break;
      case Prayer.maghrib:
        name = 'Maghrib';
        nextTime = _todayPrayerTimes!.maghrib;
        break;
      case Prayer.isha:
        name = 'Isya';
        nextTime = _todayPrayerTimes!.isha;
        break;
      case Prayer.none:
        // Next prayer is tomorrow's Fajr
        name = 'Subuh (Besok)';
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowTimes =
            _prayerService.calculatePrayerTimes(_selectedCity, date: tomorrow);
        nextTime = tomorrowTimes.fajr;
        break;
    }

    if (nextTime != null) {
      _nextPrayerName = name;
      _timeUntilNextPrayer = nextTime.difference(now);
      notifyListeners();
    }
  }

  // Toggle alarm per prayer
  void toggleAlarm(String prayerKey) {
    switch (prayerKey) {
      case 'subuh':
        _settings.subuhAlarm = !_settings.subuhAlarm;
        break;
      case 'dzuhur':
        _settings.dzuhurAlarm = !_settings.dzuhurAlarm;
        break;
      case 'ashar':
        _settings.asharAlarm = !_settings.asharAlarm;
        break;
      case 'maghrib':
        _settings.maghribAlarm = !_settings.maghribAlarm;
        break;
      case 'isya':
        _settings.isyaAlarm = !_settings.isyaAlarm;
        break;
    }
    saveSettings();
  }

  void setAdzanSound(String soundKey) {
    _settings.selectedAdzanSound = soundKey;
    saveSettings();
  }

  void setReminderMinutes(int minutes) {
    _settings.reminderMinutesBefore = minutes;
    saveSettings();
  }

  // Play test adzan audio
  Future<void> testPlayAdzan(String soundKey) async {
    if (_isTestingAdzan && _testingAdzanKey == soundKey) {
      await stopTestAdzan();
      return;
    }

    final soundData = PrayerService.adzanAudios[soundKey];
    if (soundData == null || soundData['url']!.isEmpty) {
      return;
    }

    try {
      _isTestingAdzan = true;
      _testingAdzanKey = soundKey;
      notifyListeners();

      await _adzanPlayer.setUrl(soundData['url']!);
      await _adzanPlayer.play();
    } catch (e) {
      _isTestingAdzan = false;
      _testingAdzanKey = null;
      notifyListeners();
    }
  }

  Future<void> stopTestAdzan() async {
    await _adzanPlayer.stop();
    _isTestingAdzan = false;
    _testingAdzanKey = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _adzanPlayer.dispose();
    super.dispose();
  }
}
