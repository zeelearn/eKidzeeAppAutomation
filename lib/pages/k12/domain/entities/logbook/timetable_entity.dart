// lib/domain/entities/attendance_entity.dart
class TimeTableEntity {
  final int periodId;
  final String periodName;
  final String className;
  final String subjectName;

  TimeTableEntity({
    required this.periodId,
    required this.periodName,
    required this.className,
    required this.subjectName,
  });
}
