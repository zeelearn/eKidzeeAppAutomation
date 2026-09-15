import 'package:ekidzee/pages/k12/data/models/myclass/attendance_model.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_student_list.dart';

abstract class MyclassRepository {
  Future<ClassMasterModel> getTerms();

  Future<StudentKesAttandanceResponse> getStudentAttendance(
      int sectinId, String userName, String date);

  Future<AttandanceDaysResponse> getAttandanceCalender(
      int sectionId, int month, int year);

  Future<String> saveAttendance(AttendanceModel attendance);
}
