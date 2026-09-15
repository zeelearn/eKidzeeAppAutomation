// lib/data/models/logbook_model.dart
import 'dart:convert';

import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';

class KESLogbookModel {
  // final List<LogbookPeriod> periods;
  // final List<LogbookClass> classes;
  // final List<LogbookSubject> subjects;
  final List<LogbookAcademics> academics;

  KESLogbookModel(
      {/*required this.periods, required this.classes, required this.subjects,*/ required this.academics});

  factory KESLogbookModel.fromJson(Map<String, dynamic> json) {
    try {
      // debugPrint(json['data'][0]);

      if (json['data'] != null) {
        List<LogbookAcademics> data = <LogbookAcademics>[];
        json['data'].forEach((v) {
          data!.add(new LogbookAcademics.fromJson(v));
        });
        return KESLogbookModel(
          academics: data,
        );
      }

//       debugPrint('--${json['data'][0]['class_id']}');

      return KESLogbookModel(
        //periods: json['data']['period']==null ? [] : List<LogbookPeriod>.from(json['data']['period'].map((x) => LogbookPeriod.fromJson(x))),
        //classes: json['data']['class']==null ? [] : List<LogbookClass>.from(json['data']['class'].map((x) => LogbookClass.fromJson(x))),
        //subjects: json['data']['subject']==null ? [] : List<LogbookSubject>.from(json['data']['subject'].map((x) => LogbookSubject.fromJson(x))),
        academics: json['data'] == null
            ? []
            : List<LogbookAcademics>.from(
                json['data'][0].map((x) => LogbookAcademics.fromJson(x))),
      );
    } catch (e) {
      // debugPrint(e.toString());
      return KESLogbookModel(academics: []);
    }
  }

  toJson() {
    return jsonEncode({'academics': academics.map((e) => e.toJson()).toList()});
  }

  LogbookEntity toEntity() {
    return LogbookEntity(
      // periods: periods.map((period) => period.toEntity()).toList(),
      // classes: classes.map((classModel) => classModel.toEntity()).toList(),
      // subjects: subjects.map((subjectModel) => subjectModel.toEntity()).toList(),
      academic:
          academics.map((academicModel) => academicModel.toEntity()).toList(),
    );
  }
}

class LogbookPeriod {
  int? periodId;
  String? periodName;

  LogbookPeriod({this.periodId, this.periodName});

  LogbookPeriod.fromJson(Map<String, dynamic> json) {
    periodId = json['period_id'];
    periodName = json['period_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period_id'] = this.periodId;
    data['period_name'] = this.periodName;
    return data;
  }

  LogbookPeriod toEntity() {
    return LogbookPeriod(periodId: periodId, periodName: periodName);
  }
}

class LogbookClass {
  int? classId;
  String? className;

  LogbookClass({this.classId, this.className});

  LogbookClass.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    return data;
  }

  LogbookClass toEntity() {
    return LogbookClass(classId: classId!, className: className!);
  }
}

class LogbookSubject {
  int? subjectId;
  String? subjectName;

  LogbookSubject({this.subjectId, this.subjectName});

  LogbookSubject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    return data;
  }

  LogbookSubject toEntity() {
    return LogbookSubject(subjectId: subjectId, subjectName: subjectName);
  }
}

class LogbookAcademics {
  int? classId;
  String? className;
  int? subjectId;
  String? subjectName;
  List<LogbookChapter>? chapter;

  LogbookAcademics(
      {this.classId,
      this.className,
      this.subjectId,
      this.subjectName,
      this.chapter});

  LogbookAcademics.fromJson(Map<dynamic, dynamic> json) {
//     debugPrint('in 123 -----${json}');
    classId = json['class_id'];
    className = json['class_name'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    if (json['chapter'] != null) {
      chapter = <LogbookChapter>[];
      json['chapter'].forEach((v) {
        chapter!.add(new LogbookChapter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    if (this.chapter != null) {
      data['chapter'] = this.chapter!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  LogbookAcademics toEntity() {
    return LogbookAcademics(
      classId: classId ?? 0, // Handle nullable values appropriately
      className: className ?? '',
      subjectId: subjectId ?? 0,
      subjectName: subjectName ?? '',
      chapter: chapter!.map((chapter) => chapter.toEntity()).toList() ?? [],
    );
  }
}

class LogbookChapter {
  int? chapterId;
  String? chapterName;
  List<LogbookTopic> topic = [];
  List<LearningOutcome>? learningOutcome;

  LogbookChapter(
      {this.chapterId,
      this.chapterName,
      required this.topic,
      this.learningOutcome});

  LogbookChapter.fromJson(Map<String, dynamic> json) {
//     debugPrint('Chapters ${json}');
    chapterId = json['chapter_id'];
    chapterName = json['chapter_name'];
    topic = <LogbookTopic>[];
    if (json['topic'] != null) {
      json['topic'].forEach((v) {
        topic!.add(new LogbookTopic.fromJson(v));
      });
    }
    learningOutcome = <LearningOutcome>[];
    if (json.containsKey('learning_outcome')) {
      json['learning_outcome'].forEach((v) {
        learningOutcome!.add(new LearningOutcome.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_id'] = this.chapterId;
    data['chapter_name'] = this.chapterName;
    if (this.topic != null) {
      data['topic'] = this.topic!.map((v) => v.toJson()).toList();
    }
    if (this.learningOutcome != null) {
      data['learning_outcome'] =
          this.learningOutcome!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  LogbookChapter toEntity() {
    return LogbookChapter(
      chapterId: chapterId,
      chapterName: chapterName,
      learningOutcome:
          learningOutcome!.map((chapter) => chapter.toEntity()).toList() ?? [],
      topic: topic,
    );
  }
}

class LogbookTopic {
  int? topicId;
  String? topicName;
  List<LogbookClosure>? closure;

  LogbookTopic({this.topicId, this.topicName, this.closure});

  LogbookTopic.fromJson(Map<String, dynamic> json) {
    topicId = json['topic_id'];
    topicName = json['topic_name'];
    if (json['closure'] != null) {
      closure = <LogbookClosure>[];
      json['closure'].forEach((v) {
        closure!.add(new LogbookClosure.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_id'] = this.topicId;
    data['topic_name'] = this.topicName;
    if (this.closure != null) {
      data['closure'] = this.closure!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LogbookClosure {
  int? closureId;
  String? closureName;
  bool? isChecked;

  LogbookClosure({this.closureId, this.closureName, this.isChecked});

  LogbookClosure.fromJson(Map<String, dynamic> json) {
    closureId = json['closure_id'];
    closureName = json['closure_name'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['closure_id'] = this.closureId;
    data['closure_name'] = this.closureName;
    return data;
  }
}

class LearningOutcome {
  int? loId;
  String? loName;
  bool? isChecked;

  LearningOutcome({this.loId, this.loName});

  LearningOutcome.fromJson(Map<String, dynamic> json) {
    loId = json['lo_id'];
    loName = json['lo_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lo_id'] = this.loId;
    data['lo_name'] = this.loName;
    return data;
  }

  LearningOutcome toEntity() {
    return LearningOutcome(loId: loId, loName: loName);
  }
}
