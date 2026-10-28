import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/prayer_provider.dart';
import '../services/prayer_service.dart';
import '../theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final PrayerService _prayerService = PrayerService();
  double _qiblaDegree = 295.2; // Default for Indonesia
  double _currentDeviceDegree = 0.0;
  bool _hasTriggeredHaptic = false;

  // Sensor state
  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<AccelerometerEvent>? _accSub;
  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 9.8;
  bool _hasSensorData = false;
  bool _isTilted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProv = context.read<PrayerProvider>();
      final city = prayerProv.selectedCity;
      setState(() {
        _qiblaDegree = _prayerService.calculateQiblaDirection(
            city.latitude, city.longitude);
      });
      _initSensors();
    });
  }

  void _initSensors() {
    // 1. Listen to accelerometer for tilt calculation
    _accSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      (AccelerometerEvent event) {
        _accX = event.x;
        _accY = event.y;
        _accZ = event.z;

        // Check if phone is tilted significantly (> 35 degrees)
        final totalG = math.sqrt(_accX * _accX + _accY * _accY + _accZ * _accZ);
        if (totalG > 0) {
          final tiltAngle = math.acos((_accZ.abs() / totalG).clamp(-1.0, 1.0));
          final isTiltedNow = tiltAngle > (35.0 * math.pi / 180.0);
          if (isTiltedNow != _isTilted && mounted) {
            setState(() {
              _isTilted = isTiltedNow;
            });
          }
        }
      },
      onError: (_) {},
      cancelOnError: false,
    );

  // 2. Listen to magnetometer for compass orientation
    _magSub = magnetometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      (MagnetometerEvent event) {
        _onMagnetometerData(event.x, event.y, event.z);
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  void _onMagnetometerData(double mx, double my, double mz) {
    // Calculate pitch and roll from accelerometer for tilt compensation
    final pitch = math.atan2(-_accY, math.sqrt(_accX * _accX + _accZ * _accZ));
    final roll = math.atan2(_accX, _accZ);

    // Tilt compensated magnetometer values
    final magX = mx * math.cos(pitch) + mz * math.sin(pitch);
    final magY = mx * math.sin(roll) * math.sin(pitch) +
        my * math.cos(roll) -
        mz * math.sin(roll) * math.cos(pitch);

    // Calculate heading azimuth in degrees (0 = North, 90 = East, 180 = South, 270 = West)
    double rawHeading = (math.atan2(-magX, magY) * (180.0 / math.pi) + 360.0) % 360.0;

    // Smooth angle interpolation across 0/360 boundary
    double diff = rawHeading - _currentDeviceDegree;
    while (diff < -180.0) diff += 360.0;
    while (diff > 180.0) diff -= 360.0;

    final newDegree = (_currentDeviceDegree + diff * 0.28 + 360.0) % 360.0;

    if (mounted) {
      setState(() {
        _currentDeviceDegree = newDegree;
        _hasSensorData = true;
      });

      // Haptic feedback when aligned with Qibla (within +/- 3.5 degrees)
      final qiblaDiff = ((_currentDeviceDegree - _qiblaDegree).abs() % 360.0);
      final isAligned = qiblaDiff < 3.5 || qiblaDiff > 356.5;

      if (isAligned && !_hasTriggeredHaptic) {
        _hasTriggeredHaptic = true;
        HapticFeedback.mediumImpact();
      } else if (!isAligned && _hasTriggeredHaptic) {
        _hasTriggeredHaptic = false;
      }
    }
  }

  void _manualRotate(double newDegree) {
    setState(() {
      _currentDeviceDegree = (newDegree + 360.0) % 360.0;
    });

    final qiblaDiff = ((_currentDeviceDegree - _qiblaDegree).abs() % 360.0);
    if (qiblaDiff < 3.5 || qiblaDiff > 356.5) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _magSub?.cancel();
    _accSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerProv = context.watch<PrayerProvider>();
    final city = prayerProv.selectedCity;
    _qiblaDegree = _prayerService.calculateQiblaDirection(
        city.latitude, city.longitude);

    final qiblaDiff = ((_currentDeviceDegree - _qiblaDegree).abs() % 360.0);
    final isAligned = qiblaDiff < 4.0 || qiblaDiff > 356.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kompas Arah Kiblat'),
        actions: [
          IconButton(
            tooltip: 'Kalibrasi Kompas',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _showCalibrationDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Location & Direction Header
              // Location & Direction Header (Clickable to change city)
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showCityPicker(context, prayerProv),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(isDark ? 0.2 : 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  city.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
                              ],
                            ),
                            Text(
                              'Kiblat: ${_qiblaDegree.toStringAsFixed(1)}° Baratlaut (NW)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isAligned
                              ? AppColors.accentGold.withOpacity(0.2)
                              : (_hasSensorData ? Colors.green.withOpacity(0.12) : Colors.grey.withOpacity(0.12)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isAligned
                                ? AppColors.accentGold
                                : (_hasSensorData ? Colors.green : Colors.grey),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isAligned
                                    ? AppColors.accentGold
                                    : (_hasSensorData ? Colors.green : Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isAligned
                                  ? 'Tepat Menghadap'
                                  : (_hasSensorData ? 'Sensor Aktif' : 'Mode Manual'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isAligned
                                    ? AppColors.accentGold
                                    : (_hasSensorData ? Colors.green : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tilt Warning if phone held steeply
              if (_isTilted) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade700, width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.screen_rotation_rounded, size: 16, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Text(
                        'Pegang HP lebih mendatar untuk akurasi optimal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Compass Dial with interactive touch drag and real-time rotating needle
              GestureDetector(
                onPanUpdate: (details) {
                  // Interactive touch manual rotate fallback
                  _manualRotate(_currentDeviceDegree - details.delta.dx * 0.8);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Compass Ring
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 290,
                      height: 290,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        border: Border.all(
                          color: isAligned
                              ? AppColors.accentGold
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isAligned ? 4.5 : 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isAligned
                                ? AppColors.accentGold.withOpacity(0.4)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: isAligned ? 32 : 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),

                    // Inner Compass Dial that rotates with device heading
                    Transform.rotate(
                      angle: -_currentDeviceDegree * (math.pi / 180.0),
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Cardinal Points (Utara, Timur, Selatan, Barat)
                            Positioned(
                              top: 14,
                              child: Column(
                                children: [
                                  Text(
                                    'U',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Container(
                                    width: 3,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 14,
                              child: Text(
                                'S',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              child: Text(
                                'B',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              child: Text(
                                'T',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            // Minor ticks around ring
                            ...List.generate(12, (index) {
                              final deg = index * 30.0;
                              if (deg % 90 == 0) return const SizedBox.shrink();
                              final rad = deg * (math.pi / 180.0);
                              return Transform.translate(
                                offset: Offset(118 * math.sin(rad), -118 * math.cos(rad)),
                                child: Container(
                                  width: 2,
                                  height: 6,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              );
                            }),

                            // Dedicated Ka'bah Marker inside the compass ring
                            Transform.rotate(
                              angle: _qiblaDegree * (math.pi / 180.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    top: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: isAligned ? AppColors.accentGold : AppColors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isAligned ? AppColors.accentGold : AppColors.primary)
                                                .withOpacity(0.4),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.mosque_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Rotating Pointer to Ka'bah relative to phone
                    Transform.rotate(
                      angle: ((_qiblaDegree - _currentDeviceDegree) * (math.pi / 180.0)),
                      child: SizedBox(
                        width: 230,
                        height: 230,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Needle top pointer with glowing indicator
                            Positioned(
                              top: 2,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.navigation_rounded,
                                    size: 32,
                                    color: isAligned ? AppColors.accentGold : AppColors.primary,
                                  ),
                                  Text(
                                    'KIBLAT',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                      color: isAligned ? AppColors.accentGold : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Thin guide line
                            Container(
                              width: 3,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(
                                  colors: [
                                    isAligned ? AppColors.accentGold : AppColors.primary,
                                    (isAligned ? AppColors.accentGold : AppColors.primary)
                                        .withOpacity(0.1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Center Pivot Dot
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isAligned ? AppColors.accentGold : AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Degree Display
              Text(
                '${_currentDeviceDegree.toStringAsFixed(0)}°',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isAligned
                      ? AppColors.accentGold
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isAligned
                    ? '✨ Alhamdulillah, tepat menghadap arah Kiblat!'
                    : 'Putar HP hingga jarum kiblat berada di posisi atas.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: isAligned ? FontWeight.bold : FontWeight.normal,
                  color: isAligned
                      ? (isDark ? AppColors.accentGoldLight : AppColors.accentGold)
                      : Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // Quick Align Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isAligned ? AppColors.primary : Colors.grey.shade700,
                      side: BorderSide(
                        color: isAligned ? AppColors.primary : Colors.grey.shade400,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    icon: Icon(
                      isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                      size: 18,
                      color: isAligned ? AppColors.primary : null,
                    ),
                    label: Text(
                      isAligned ? 'Tepat Menghadap Kiblat' : 'Luruskan ke Arah Kiblat',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () {
                      _manualRotate(_qiblaDegree);
                      HapticFeedback.heavyImpact();
                    },
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalibrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.compass_calibration_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Kalibrasi Kompas',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agar arah kompas akurat:',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCalibrationStep('1', 'Pegang HP mendatar sejajar dengan permukaan tanah.'),
            _buildCalibrationStep('2', 'Jauhkan dari benda logam, magnet, laptop, atau speaker.'),
            _buildCalibrationStep('3', 'Gerakkan HP membentuk pola angka 8 (delapan) di udara beberapa kali.'),
            _buildCalibrationStep('4', 'Jika HP tidak memiliki sensor magnetik bawaan, Anda dapat memutar kompas secara manual dengan menggeser layar.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context, PrayerProvider prayerProv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Kota untuk Arah Kiblat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: PrayerService.defaultCities.length,
                  itemBuilder: (context, index) {
                    final city = PrayerService.defaultCities[index];
                    final isSelected = city.name == prayerProv.selectedCity.name;
                    final cityQibla = _prayerService.calculateQiblaDirection(
                        city.latitude, city.longitude);

                    return ListTile(
                      leading: Icon(
                        Icons.location_city_rounded,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      title: Text(
                        city.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      subtitle: Text(
                        'Kiblat: ${cityQibla.toStringAsFixed(1)}° Baratlaut',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        prayerProv.setCity(city);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

