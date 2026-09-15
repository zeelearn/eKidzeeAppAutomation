import 'dart:convert';

import 'package:ekidzee/pages/k12/domain/entities/get_homework_entity.dart';
import 'package:flutter/material.dart';

class GetHomeworkModel extends GetHomeworkEntity {
  GetHomeworkModel(
      {required super.sectionId,
      required super.userId,
      required super.username});

  GetHomeworkModel.fromJson(Map<String, dynamic> json,
      {required super.sectionId,
      required super.userId,
      required super.username}) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMapApi() {
    return {'sectionID': sectionId, 'userId': userId, 'username': username};
  }
}

class Data {
  // String? subject;
  List<Subject>? subject;
  List<Homework>? homework;

  Data({this.subject, this.homework});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Subject'] != null) {
      try {
        String data = json['Subject'];

        data = data.replaceAll("\\n", "");
        data = data.replaceAll('\\r', '');
        data = data.replaceAll('\\', '');
        subject = <Subject>[];

        jsonDecode(data).forEach((v) {
          subject!.add(Subject.fromJson(v));
        });
      } catch (e) {
        subject = [];
        debugPrint('Error is - $e');
      }
    }
    if (json['Homework'] != null) {
      try {
        String data = json['Homework'];
        data.replaceAll('\\', '');
        homework = <Homework>[];

        jsonDecode(json['Homework']).forEach((v) {
          homework!.add(Homework.fromJson(v));
        });
      } catch (e) {
        homework = [];
        debugPrint('Error is - $e');
      }
    }
    // subject = json['Subject'];
    // homework = json['Homework'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (homework != null) {
      data['Subject'] = subject!.map((v) => v.toJson()).toList();
    }
    if (homework != null) {
      data['Homework'] = homework!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Homework {
  int? homeworkID;
  int? classID;
  int? subjectID;
  String? subjectName;
  String? chapterName;
  int? chapterID;
  int? userId;
  String? message;
  String? fileURL;
  String? assigndate;
  String? submissiondate;
  bool? isPublish;
  String? publishedDate;
  bool? isActive;
  String? createdBy;
  String? createddate;
  String? modifiedBy;
  String? modifiedDate;
  int? total;
  int? completed;
  String? statusCode;
  String? remarks;
  int? is_student_homework_uploaded;
  int? homework_attempt;
  String? upload_url;

  Homework(
      {this.homeworkID,
      this.classID,
      this.subjectName,
      this.chapterName,
      this.subjectID,
      this.chapterID,
      this.userId,
      this.message,
      this.fileURL,
      this.assigndate,
      this.submissiondate,
      this.isPublish,
      this.publishedDate,
      this.isActive,
      this.createdBy,
      this.createddate,
      this.modifiedBy,
      this.modifiedDate,
      this.total,
      this.completed,
      this.upload_url});

  Homework.fromJson(Map<String, dynamic> json) {
    homeworkID = json['HomeworkID'];
    classID = json['ClassID'];
    subjectName = json['subject_name'];
    chapterName = json['chapter_name'];
    subjectID = json['SubjectID'];
    chapterID = json['ChapterID'];
    userId = json['UserId'];
    message = json['Message'];
    fileURL = json['FileURL'];
    assigndate = json['Assigndate'];
    submissiondate = json['Submissiondate'];
    isPublish = json['IsPublish'];
    publishedDate = json['PublishedDate'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createddate = json['Createddate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    total = json['total'];
    completed = json['completed'];
    homework_attempt = json['homework_attempt'];
    is_student_homework_uploaded = json['is_student_homework_uploaded'];
    remarks = json['remarks'];
    statusCode = json['status_code'];
    upload_url = json['upload_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HomeworkID'] = homeworkID;
    data['ClassID'] = classID;
    data['SubjectID'] = subjectID;
    data['ChapterID'] = chapterID;
    data['UserId'] = userId;
    data['Message'] = message;
    data['FileURL'] = fileURL;
    data['Assigndate'] = assigndate;
    data['Submissiondate'] = submissiondate;
    data['IsPublish'] = isPublish;
    data['PublishedDate'] = publishedDate;
    data['IsActive'] = isActive;
    data['CreatedBy'] = createdBy;
    data['Createddate'] = createddate;
    data['ModifiedBy'] = modifiedBy;
    data['ModifiedDate'] = modifiedDate;
    data['total'] = total;
    data['completed'] = completed;
    data['status_code'] = statusCode;
    data['remarks'] = remarks;
    data['is_student_homework_uploaded'] = is_student_homework_uploaded;
    data['homework_attempt'] = homework_attempt;
    data['upload_url'] = upload_url;
    return data;
  }
}

class Subject {
  int? subjectId;
  String? subjectName;
  int? classId;
  List<Chapter>? chapter;

  Subject({this.subjectId, this.subjectName, this.classId, this.chapter});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    //subjectName = subjectName!.replaceAll('\n', '');
    classId = json['class_id'];
    if (json['Chapter'] != null) {
      chapter = <Chapter>[];
      json['Chapter'].forEach((v) {
        chapter!.add(Chapter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['class_id'] = classId;
    if (chapter != null) {
      data['Chapter'] = chapter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chapter {
  int? chapterId;
  String? chapterName;
  String? description;

  Chapter({this.chapterId, this.chapterName, this.description});

  Chapter.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapter_id'];
    chapterName = json['chapter_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapter_id'] = chapterId;
    data['chapter_name'] = chapterName;
    data['description'] = description;
    return data;
  }
}
