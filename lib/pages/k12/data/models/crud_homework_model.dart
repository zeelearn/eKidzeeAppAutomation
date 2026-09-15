import 'package:ekidzee/pages/k12/domain/entities/crud_homework_entity.dart';

class CrudHomeworkModel extends CrudHomeworkEntity {
  CrudHomeworkModel(
      {required super.homeworkId,
      required super.sectionId,
      required super.subjectId,
      required super.chapterId,
      super.userId,
      required super.message,
      required super.fileUrl,
      required super.assignDate,
      required super.submissionDate,
      required super.isPublish,
      required super.createdBy,
      required super.username});

  CrudHomeworkModel.fromJson(Map<String, dynamic> json,
      {required super.homeworkId,
      required super.sectionId,
      required super.subjectId,
      required super.chapterId,
      super.userId,
      required super.message,
      required super.assignDate,
      required super.createdBy,
      required super.fileUrl,
      required super.isPublish,
      required super.submissionDate,
      required super.username}) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMapApi() {
    return {
      "HomeworkID": homeworkId,
      "sectionID": sectionId,
      "SubjectID": subjectId,
      "ChapterID": chapterId,
      "UserId": userId,
      "Message": message,
      "FileURL": fileUrl,
      "Assigndate": assignDate,
      "Submissiondate": submissionDate,
      "IsPublish": isPublish,
      "PublishedDate": '',
      "CreatedBy": createdBy,
      "username": username
    };
  }
}

class Data {
  String? msg;

  Data({this.msg});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    return data;
  }
}
