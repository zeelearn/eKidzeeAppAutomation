class AttendanceEntity {
  final String term;
  final String month;
  final Map<String, bool> studentAttendance;

  AttendanceEntity({
    required this.term,
    required this.month,
    required this.studentAttendance,
  });
}
