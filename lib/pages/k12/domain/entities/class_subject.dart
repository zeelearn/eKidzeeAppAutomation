import 'package:equatable/equatable.dart';

class ClassSubject extends Equatable {
  final int classId;
  final String className;
  final List<Subject> subjects;

  ClassSubject({
    required this.classId,
    required this.className,
    required this.subjects,
  });

  @override
  List<Object?> get props => [classId, className, subjects];
}

class Subject extends Equatable {
  final int subjectId;
  final String subjectName;
  final int classId;

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.classId,
  });

  @override
  List<Object?> get props => [subjectId, subjectName, classId];
}
