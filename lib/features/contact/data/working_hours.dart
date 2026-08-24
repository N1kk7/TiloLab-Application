import 'package:flutter/material.dart';

class WorkingHoursRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const WorkingHoursRange(this.start, this.end);

  String get label =>
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} – '
      '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
}

// DateTime.weekday: 1 = понеділок ... 7 = неділя
final Map<int, WorkingHoursRange?> workingHours = {
  DateTime.monday: const WorkingHoursRange(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 19, minute: 0)),
  DateTime.tuesday: const WorkingHoursRange(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 19, minute: 0)),
  DateTime.wednesday: const WorkingHoursRange(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 19, minute: 0)),
  DateTime.thursday: const WorkingHoursRange(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 19, minute: 0)),
  DateTime.friday: const WorkingHoursRange(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 19, minute: 0)),
  DateTime.saturday: const WorkingHoursRange(TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 16, minute: 0)),
  DateTime.sunday: null,
};

const List<String> weekdayLabels = [
  'Понеділок',
  'Вівторок',
  'Середа',
  'Четвер',
  "П'ятниця",
  'Субота',
  'Неділя',
];

bool isStoreOpenNow() {
  final now = DateTime.now();
  final todayRange = workingHours[now.weekday];
  if (todayRange == null) return false;

  final nowMinutes = now.hour * 60 + now.minute;
  final startMinutes = todayRange.start.hour * 60 + todayRange.start.minute;
  final endMinutes = todayRange.end.hour * 60 + todayRange.end.minute;

  return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
}