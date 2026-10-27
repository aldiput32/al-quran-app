class PrayerSettingModel {
  bool subuhAlarm;
  bool dzuhurAlarm;
  bool asharAlarm;
  bool maghribAlarm;
  bool isyaAlarm;
  String selectedAdzanSound; // 'makkah', 'madinah', 'egypt', 'short_beep', 'vibrate'
  int reminderMinutesBefore; // 0 = exactly on time, 5 = 5 mins before, 10 = 10 mins before

  PrayerSettingModel({
    this.subuhAlarm = true,
    this.dzuhurAlarm = true,
    this.asharAlarm = true,
    this.maghribAlarm = true,
    this.isyaAlarm = true,
    this.selectedAdzanSound = 'makkah',
    this.reminderMinutesBefore = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'subuhAlarm': subuhAlarm,
      'dzuhurAlarm': dzuhurAlarm,
      'asharAlarm': asharAlarm,
      'maghribAlarm': maghribAlarm,
      'isyaAlarm': isyaAlarm,
      'selectedAdzanSound': selectedAdzanSound,
      'reminderMinutesBefore': reminderMinutesBefore,
    };
  }

  factory PrayerSettingModel.fromJson(Map<String, dynamic> json) {
    return PrayerSettingModel(
      subuhAlarm: json['subuhAlarm'] ?? true,
      dzuhurAlarm: json['dzuhurAlarm'] ?? true,
      asharAlarm: json['asharAlarm'] ?? true,
      maghribAlarm: json['maghribAlarm'] ?? true,
      isyaAlarm: json['isyaAlarm'] ?? true,
      selectedAdzanSound: json['selectedAdzanSound'] ?? 'makkah',
      reminderMinutesBefore: json['reminderMinutesBefore'] ?? 0,
    );
  }
}

class CityLocation {
  final String name;
  final double latitude;
  final double longitude;

  const CityLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
