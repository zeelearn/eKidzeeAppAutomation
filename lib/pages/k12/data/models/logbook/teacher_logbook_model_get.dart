// data/models/teacher_logbook_model.dart

import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';

class GetTeacherLogbookModel {
  final int classId;
  final String className;
  final int subjectId;
  final String subjectName;
  final int chapterId;
  final String chapterName;
  final int topicId;
  final String topicName;
  final String activity;
  final String teachingAids;
  final String classwork;
  final String homework;
  final List<LogbookClosure> closure;
  final List<LearningOutcome> learningOutcome;
  final String remarks;

  GetTeacherLogbookModel({
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
    required this.topicId,
    required this.topicName,
    required this.activity,
    required this.teachingAids,
    required this.classwork,
    required this.homework,
    required this.closure,
    required this.learningOutcome,
    required this.remarks,
  });

  factory GetTeacherLogbookModel.fromJson(Map<String, dynamic> json) {
    // debugPrint(json);
    var closures = (json['closure'] as List)
        .map((c) => LogbookClosure.fromJson(c))
        .toList();
    //var learningOutcomes = (json['learning_outcome'] as List).map((lo) => LearningOutcome.fromJson(lo)).toList();
    var learningOutcomes = List<LearningOutcome>.from(
        json['learning_outcome'].map((x) => LearningOutcome.fromJson(x)));
//     debugPrint('in 45----------------${learningOutcomes}');
    //var closures = List<LogbookClosure>.from(json['closure'].map((x) => LogbookClosure.fromJson(x)));

    return GetTeacherLogbookModel(
      classId: json['class_id'],
      className: json['class_name'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      chapterId: json['chapter_id'],
      chapterName: json['chapter_name'],
      topicId: json['topic_id'],
      topicName: json['topic_name'],
      activity: json['activity'],
      teachingAids: json['teaching_aids'],
      classwork: json['classwork'],
      homework: json['homework'],
      closure: closures,
      learningOutcome: learningOutcomes,
      remarks: json['remarks'],
    );
  }
}
