// lib/data/models/attendance_model.dart
import 'dart:convert';

class LogbookTimeTableModel {
  final int periodId;
  final String periodName;
  final int classId;
  final String className;
  final int subjectId;
  final String subjectName;
  final int sectionId;

  LogbookTimeTableModel({
    required this.periodId,
    required this.periodName,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.sectionId,
  });

  factory LogbookTimeTableModel.fromJson(Map<String, dynamic> json) {
    return LogbookTimeTableModel(
      periodId: json['period_id'],
      periodName: json['period_name'],
      classId: json['class_id'],
      className: json['class_name'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      sectionId: json['section_id'],
    );
  }
}
