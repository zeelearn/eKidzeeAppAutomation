// lib/data/models/teacher_logbook_model.dart
import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';

class TeacherLogbookModel {
  final String username;
  final int businessId;
  final String date;
  final int periodId;
  final int sectionId;
  final int classId;
  final int subjectId;
  final TeacherLogbookData inputData;

  TeacherLogbookModel({
    required this.username,
    required this.businessId,
    required this.date,
    required this.periodId,
    required this.sectionId,
    required this.classId,
    required this.subjectId,
    required this.inputData,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "business_id": businessId,
      "date": date,
      "period_id": periodId,
      "section_id": sectionId,
      "class_id": classId,
      "subject_id": subjectId,
      "input_data": inputData.toJson(),
    };
  }
}

class TeacherLogbookData {
  final int chapterId;
  final int topicId;
  final String activity;
  final String teachingAids;
  final String classwork;
  final String homework;
  final List<LogbookClosure> closure;
  final List<LearningOutcome> learningOutcome;
  final String remarks;

  TeacherLogbookData({
    required this.chapterId,
    required this.topicId,
    required this.activity,
    required this.teachingAids,
    required this.classwork,
    required this.homework,
    required this.closure,
    required this.learningOutcome,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      "chapter_id": chapterId,
      "topic_id": topicId,
      "activity": activity,
      "teaching_aids": teachingAids,
      "classwork": classwork,
      "homework": homework,
      "closure": closure.map((co) => co.toJson()).toList(),//closure.toJson(),
      "learning_outcome": learningOutcome.map((lo) => lo.toJson()).toList(),
      "remarks": remarks,
    };
  }
}

// class Closure {
//   final int closureId;
//   final String closureName;

//   Closure({required this.closureId, required this.closureName});

//   Map<String, dynamic> toJson() {
//     return {
//       "closure_id": closureId,
//       "closure_name": closureName,
//     };
//   }
// }

// class LearningOutcome {
//   final int loId;
//   final String loName;

//   LearningOutcome({required this.loId, required this.loName});

//   Map<String, dynamic> toJson() {
//     return {
//       "lo_id": loId,
//       "lo_name": loName,
//     };
//   }
// }
