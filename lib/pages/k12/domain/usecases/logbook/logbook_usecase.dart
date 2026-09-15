

import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model_get.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:ekidzee/pages/k12/data/repository/logbook_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/teacher_logbook.dart';

class GetLogbook {
  final LogbookRepository repository;

  GetLogbook(this.repository);

  Future<LogbookEntity> getKESLogbook(int classId, int subjectId, String userName, int franchiseeId) {
    return repository.getLogbook(classId, subjectId, userName, franchiseeId);
  }

  Future<GeneralResponse> insertTeacherLogbook(TeacherLogbookModel logbook) {
    return repository.saveTeacherLogbook(logbook);
  }

  Future<List<LogbookTimeTableModel>> getTimeTable(String username, String date) {
    return repository.fetchTimeTable(username,date);
  }

  Future<GetTeacherLogbookModel> getTeachersLogbook(String userName,int businessId,String date,int periodId,int sectionId) {
    return repository.getTeacherLogbook(userName,businessId,date,periodId,sectionId);
  }
}
