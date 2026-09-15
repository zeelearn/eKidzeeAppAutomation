// lib/domain/entities/teacher_logbook.dart
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model.dart';

class TeacherLogbook {
  final String username;
  final int businessId;
  final String date;
  final int periodId;
  final int sectionId;
  final int classId;
  final int subjectId;
  final TeacherLogbookData inputData;

  TeacherLogbook({
    required this.username,
    required this.businessId,
    required this.date,
    required this.periodId,
    required this.sectionId,
    required this.classId,
    required this.subjectId,
    required this.inputData,
  });
}
