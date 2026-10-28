import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/prayer_setting_model.dart';
import '../providers/prayer_provider.dart';
import '../services/prayer_service.dart';
import '../theme/app_colors.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerProv = context.watch<PrayerProvider>();
    final times = prayerProv.todayPrayerTimes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat & Adzan'),
        actions: [
          IconButton(
            tooltip: 'Ganti Kota',
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => _showCityPicker(context, prayerProv),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          // City & Date Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _showCityPicker(context, prayerProv),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        prayerProv.selectedCity.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              Text(
                DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.now()),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Countdown Card to Next Prayer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Menuju Waktu ${prayerProv.nextPrayerName}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(prayerProv.timeUntilNextPrayer),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Standar Perhitungan Kementerian Agama RI',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Prayer Times List with On/Off Alarm Toggles
          Text(
            'WAKTU SHOLAT HARI INI',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          if (times != null) ...[
            _buildPrayerItem(
              context,
              name: 'Subuh',
              timeStr: _formatTime(times.fajr),
              isAlarmOn: prayerProv.settings.subuhAlarm,
              onToggle: () => prayerProv.toggleAlarm('subuh'),
              icon: Icons.brightness_2_outlined,
            ),
            _buildPrayerItem(
              context,
              name: 'Terbit',
              timeStr: _formatTime(times.sunrise),
              isAlarmOn: false,
              hasToggle: false,
              icon: Icons.wb_sunny_outlined,
            ),
            _buildPrayerItem(
              context,
              name: 'Dzuhur',
              timeStr: _formatTime(times.dhuhr),
              isAlarmOn: prayerProv.settings.dzuhurAlarm,
              onToggle: () => prayerProv.toggleAlarm('dzuhur'),
              icon: Icons.wb_sunny_rounded,
            ),
            _buildPrayerItem(
              context,
              name: 'Ashar',
              timeStr: _formatTime(times.asr),
              isAlarmOn: prayerProv.settings.asharAlarm,
              onToggle: () => prayerProv.toggleAlarm('ashar'),
              icon: Icons.wb_twilight_rounded,
            ),
            _buildPrayerItem(
              context,
              name: 'Maghrib',
              timeStr: _formatTime(times.maghrib),
              isAlarmOn: prayerProv.settings.maghribAlarm,
              onToggle: () => prayerProv.toggleAlarm('maghrib'),
              icon: Icons.nights_stay_outlined,
            ),
            _buildPrayerItem(
              context,
              name: 'Isya',
              timeStr: _formatTime(times.isha),
              isAlarmOn: prayerProv.settings.isyaAlarm,
              onToggle: () => prayerProv.toggleAlarm('isya'),
              icon: Icons.bedtime_outlined,
            ),
          ],

          const SizedBox(height: 24),

          // Adzan Sound Customization & Preview Card
          Text(
            'PENGATURAN SUARA ADZAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volume_up_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Pilihan Suara Adzan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...PrayerService.adzanAudios.entries.map((entry) {
                  final key = entry.key;
                  final title = entry.value['title']!;
                  final hasAudio = entry.value['url']!.isNotEmpty;
                  final isSelected =
                      prayerProv.settings.selectedAdzanSound == key;
                  final isPlayingThis =
                      prayerProv.isTestingAdzan && prayerProv.testingAdzanKey == key;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer.withOpacity(isDark ? 0.2 : 0.4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      leading: Radio<String>(
                        value: key,
                        groupValue: prayerProv.settings.selectedAdzanSound,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          if (val != null) prayerProv.setAdzanSound(val);
                        },
                      ),
                      title: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: hasAudio
                          ? IconButton(
                              icon: Icon(
                                isPlayingThis
                                    ? Icons.stop_circle_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: isPlayingThis
                                    ? Colors.redAccent
                                    : AppColors.primary,
                                size: 28,
                              ),
                              tooltip: isPlayingThis
                                  ? 'Hentikan Contoh'
                                  : 'Dengarkan Contoh Adzan',
                              onPressed: () {
                                prayerProv.testPlayAdzan(key);
                              },
                            )
                          : null,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(
    BuildContext context, {
    required String name,
    required String timeStr,
    required bool isAlarmOn,
    required IconData icon,
    VoidCallback? onToggle,
    bool hasToggle = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
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
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          if (hasToggle && onToggle != null)
            IconButton(
              iconSize: 22,
              tooltip: isAlarmOn ? 'Matikan Suara Adzan' : 'Nyalakan Suara Adzan',
              icon: Icon(
                isAlarmOn ? Icons.notifications_active : Icons.notifications_off_outlined,
                color: isAlarmOn
                    ? AppColors.primary
                    : (isDark ? Colors.grey : Colors.grey.shade400),
              ),
              onPressed: onToggle,
            )
          else
            const SizedBox(width: 40),
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
                child: Text(
                  'Pilih Kota di Indonesia',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: PrayerService.defaultCities.length,
                  itemBuilder: (context, index) {
                    final city = PrayerService.defaultCities[index];
                    final isSelected = city.name == prayerProv.selectedCity.name;

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
