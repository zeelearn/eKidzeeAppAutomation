// lib/domain/entities/logbook_entity.dart
import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';

class LogbookEntity {
  // final List<LogbookPeriod> periods;
  // final List<LogbookClass> classes;
  // final List<LogbookSubject> subjects;
  final List<LogbookAcademics> academic;

  LogbookEntity({/*required this.periods, required this.classes, required this.subjects,*/required this.academic});
}

class ClassEntity {
  final int classId;
  final String className;

  ClassEntity({required this.classId, required this.className});
}

class Subject {
  final int subjectId;
  final String subjectName;

  Subject({required this.subjectId, required this.subjectName});
}



