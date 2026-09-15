abstract class AttendanceRepository {
  Future<List<String>> getTerms();
  Future<List<String>> getMonths();
  Future<Map<String, bool>> getAttendanceDays(String term, String month);
  Future<Map<String, bool>> getStudentAttendance(String date);
}
