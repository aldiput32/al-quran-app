import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  double _qiblaDegree = 295.2; // Default for Jakarta/Indonesia
  double _currentDeviceDegree = 0.0;

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
    });
  }

  void _simulateCompassRotate(double newDegree) {
    setState(() {
      _currentDeviceDegree = newDegree;
    });
    // Check if facing Ka'bah within 3 degrees
    final diff = (_currentDeviceDegree - _qiblaDegree).abs();
    if (diff < 3.0 || diff > 357.0) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerProv = context.watch<PrayerProvider>();
    final city = prayerProv.selectedCity;

    final diff = (_currentDeviceDegree - _qiblaDegree).abs();
    final isAligned = diff < 5.0 || diff > 355.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kompas Arah Kiblat'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Location Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Arah Kiblat: ${_qiblaDegree.toStringAsFixed(1)}° Baratlaut',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAligned
                            ? AppColors.primaryContainer
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAligned ? 'Tepat Menghadap' : 'Putar HP',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isAligned ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Compass Dial
              GestureDetector(
                onPanUpdate: (details) {
                  // Interactive touch rotation simulation
                  _simulateCompassRotate(
                    (_currentDeviceDegree + details.delta.dx) % 360,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Compass Ring
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        border: Border.all(
                          color: isAligned
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isAligned ? 4 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isAligned
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),

                    // Cardinal Points (Utara, Timur, Selatan, Barat)
                    Positioned(
                      top: 14,
                      child: Text(
                        'U',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.redAccent,
                        ),
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

                    // Rotating Compass Needle pointing to Ka'bah
                    Transform.rotate(
                      angle: ((_qiblaDegree - _currentDeviceDegree) *
                              (math.pi / 180)),
                      child: SizedBox(
                        width: 240,
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ka'bah Indicator Icon at top of needle
                            Positioned(
                              top: 8,
                              child: Column(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isAligned
                                          ? AppColors.accentGold
                                          : AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.accentGold
                                              .withOpacity(0.4),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.mosque_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'KIBLAT',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Needle Line
                            Container(
                              width: 3,
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.1),
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
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                '${_qiblaDegree.toStringAsFixed(0)}°',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isAligned
                      ? AppColors.primary
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Letakkan ponsel di permukaan datar dan jauhkan dari benda logam/magnet.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
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
                  isAligned ? Icons.check_circle_rounded : Icons.compass_calibration_rounded,
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
                  setState(() {
                    _currentDeviceDegree = _qiblaDegree;
                  });
                  HapticFeedback.heavyImpact();
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
