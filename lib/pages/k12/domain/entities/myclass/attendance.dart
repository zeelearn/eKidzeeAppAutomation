class Attendance {
  final int teacherId;
  final String userName;
  final int sectionId;
  final List<AttendanceRecord> inputData;

  Attendance({
    required this.teacherId,
    required this.userName,
    required this.sectionId,
    required this.inputData,
  });
}

class AttendanceRecord {
  final int ccId;
  final int studentId;
  final String rating;

  AttendanceRecord({
    required this.ccId,
    required this.studentId,
    required this.rating,
  });
}
