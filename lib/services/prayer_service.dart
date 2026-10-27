import 'package:adhan_dart/adhan_dart.dart';
import '../models/prayer_setting_model.dart';

class PrayerService {
  // Pre-configured major Indonesian cities
  static const List<CityLocation> defaultCities = [
    CityLocation(name: 'Jakarta', latitude: -6.2088, longitude: 106.8456),
    CityLocation(name: 'Surabaya', latitude: -7.2575, longitude: 112.7521),
    CityLocation(name: 'Bandung', latitude: -6.9175, longitude: 107.6191),
    CityLocation(name: 'Medan', latitude: 3.5952, longitude: 98.6722),
    CityLocation(name: 'Semarang', latitude: -6.9667, longitude: 110.4167),
    CityLocation(name: 'Makassar', latitude: -5.1477, longitude: 119.4327),
    CityLocation(name: 'Palembang', latitude: -2.9761, longitude: 104.7754),
    CityLocation(name: 'Yogyakarta', latitude: -7.7956, longitude: 110.3695),
    CityLocation(name: 'Denpasar', latitude: -8.6705, longitude: 115.2126),
    CityLocation(name: 'Banda Aceh', latitude: 5.5483, longitude: 95.3238),
    CityLocation(name: 'Banjarmasin', latitude: -3.3167, longitude: 114.5900),
    CityLocation(name: 'Jayapura', latitude: -2.5337, longitude: 140.7181),
  ];

  // Adzan audio sample streams (merdu audio)
  static const Map<String, Map<String, String>> adzanAudios = {
    'makkah': {
      'title': 'Adzan Makkah (Merdu & Syahdu)',
      'url': 'https://download.quranicaudio.com/athan/makkah.mp3',
    },
    'madinah': {
      'title': 'Adzan Madinah (Masjid Nabawi)',
      'url': 'https://download.quranicaudio.com/athan/madinah.mp3',
    },
    'subuh': {
      'title': 'Adzan Subuh (As-Shalatu Khairum Minan Naum)',
      'url': 'https://download.quranicaudio.com/athan/fajr_makkah.mp3',
    },
    'egypt': {
      'title': 'Adzan Mesir (Syekh Abdul Basith)',
      'url': 'https://download.quranicaudio.com/athan/abdulbasit.mp3',
    },
    'beep': {
      'title': 'Nada Notifikasi Lembut',
      'url': '',
    },
    'vibrate': {
      'title': 'Hanya Getar (Tanpa Suara)',
      'url': '',
    },
  };

  // Calculate prayer times using Kemenag RI standard (Fajr 20°, Isha 18°)
  PrayerTimes calculatePrayerTimes(CityLocation city, {DateTime? date}) {
    final coordinates = Coordinates(city.latitude, city.longitude);
    final params = CalculationMethodParameters.singapore();
    params.fajrAngle = 20.0; // Standar Kemenag RI
    params.ishaAngle = 18.0; // Standar Kemenag RI
    params.madhab = Madhab.shafi;

    return PrayerTimes(
      coordinates: coordinates,
      date: date ?? DateTime.now(),
      calculationParameters: params,
      precision: true,
    );
  }

  // Calculate Qibla direction from city coordinates
  double calculateQiblaDirection(double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    return Qibla.qibla(coordinates);
  }
}
