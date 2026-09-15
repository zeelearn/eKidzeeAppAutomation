import 'package:ekidzee/pages/k12/data/data_sources/attendance_remote_data_source.dart';
import 'package:ekidzee/pages/k12/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<String>> getTerms() async {
    try {
      final terms = await remoteDataSource.fetchTerms();
      return terms;
    } catch (e) {
      // Handle error (e.g., logging, rethrowing, or returning a default value)
      throw Exception('Failed to load terms');
    }
  }

  @override
  Future<List<String>> getMonths() async {
    try {
      final months = await remoteDataSource.fetchMonths();
      return months;
    } catch (e) {
      // Handle error (e.g., logging, rethrowing, or returning a default value)
      throw Exception('Failed to load months');
    }
  }

  @override
  Future<Map<String, bool>> getAttendanceDays(String term, String month) async {
    try {
      final attendanceDays =
          await remoteDataSource.fetchAttendanceDays(term, month);
      return attendanceDays;
    } catch (e) {
      // Handle error (e.g., logging, rethrowing, or returning a default value)
      throw Exception('Failed to load attendance days');
    }
  }

  @override
  Future<Map<String, bool>> getStudentAttendance(String date) async {
    try {
//       debugPrint('in 47 ------get Student attendance');
      final studentAttendance =
          await remoteDataSource.fetchStudentAttendance(date);
      return studentAttendance;
    } catch (e) {
      // Handle error (e.g., logging, rethrowing, or returning a default value)
      throw Exception('Failed to load student attendance');
    }
  }
}
