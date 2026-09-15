import '../repositories/attendance_repository.dart';

class GetAttendanceDays {
  final AttendanceRepository repository;

  GetAttendanceDays(this.repository);

  Future<Map<String, bool>> call(String term, String month) async {
    try {
      // Fetch the attendance days from the repository
      final attendanceDays = await repository.getAttendanceDays(term, month);
      return attendanceDays;
    } catch (e) {
      // Handle any errors that may occur and rethrow or return a default value
      // For example, you might rethrow the error or handle it accordingly
      throw Exception('Failed to get attendance days: $e');
    }
  }
}
