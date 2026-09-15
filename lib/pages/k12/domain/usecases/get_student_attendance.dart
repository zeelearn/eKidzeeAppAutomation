import '../repositories/attendance_repository.dart';

class GetStudentAttendance {
  final AttendanceRepository repository;

  GetStudentAttendance(this.repository);

  Future<Map<String, bool>> getStudentAttendance(String date) async {
    try {
      // Fetch the student attendance from the repository for the given date
      final studentAttendance = await repository.getStudentAttendance(date);
      return studentAttendance;
    } catch (e) {
      // Handle any errors that may occur and rethrow or return a default value
      // For example, you might rethrow the error or handle it accordingly
      throw Exception('Failed to get student attendance: $e');
    }
  }
}
