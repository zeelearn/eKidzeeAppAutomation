import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/teacher_logbook.dart';

abstract class LogbookRepository {
  Future<List<KESLogbookModel>> getLogbook(String date);

   Future<List<LogbookTimeTableModel>> getTimeTable(String username, String date);

  Future<void> saveTeacherLogbook(TeacherLogbook logbook);
}
