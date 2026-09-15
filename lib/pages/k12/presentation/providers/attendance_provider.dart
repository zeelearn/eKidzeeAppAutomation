

import 'package:ekidzee/pages/k12/data/data_sources/attendance_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/repository/attendance_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/usecases/get_attendance_days.dart';
import 'package:ekidzee/pages/k12/domain/usecases/get_months.dart';
import 'package:ekidzee/pages/k12/domain/usecases/get_student_attendance.dart';
import 'package:ekidzee/pages/k12/domain/usecases/get_terms.dart';

class AttendanceProvider {
  static final _dataSource = AttendanceRemoteDataSource();
  static final _repository = AttendanceRepositoryImpl(_dataSource);

  static final getTerms = GetTerms(_repository).call;
  static final getMonths = GetMonths(_repository).call;
  static final getAttendanceDays = GetAttendanceDays(_repository).call;
  static final getStudentAttendance = GetStudentAttendance(_repository).getStudentAttendance;
}
