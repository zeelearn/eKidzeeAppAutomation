import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_student_list.dart';
import 'package:ekidzee/pages/k12/domain/repositories/myclass/myclass_repository.dart';

class MyclassUsecases {
  final MyclassRepository repository;

  MyclassUsecases(this.repository);

  Future<ClassMasterModel> getTerms() {
    return repository.getTerms();
  }

  Future<StudentKesAttandanceResponse> getKesStudentAttandance(
      int sectinId, String userName, String date) {
    return repository.getStudentAttendance(sectinId, userName, date);
  }

  Future<AttandanceDaysResponse> getAttandanceCalender(
      int sectionId, int month, int year) {
    return repository.getAttandanceCalender(sectionId, month, year);
  }
}
