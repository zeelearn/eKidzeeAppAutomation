import 'package:ekidzee/pages/k12/domain/entities/get_homework_student_entity.dart';

class GetHomeworkStudentModel extends GetHomeworkStudentEntity {
  GetHomeworkStudentModel(
      {required super.businessID,
      required super.homeworkID,
      required super.sectionID,
      required super.username});

  Map<String, dynamic> toMapApi() {
    return {
      'section_id': sectionID,
      'username': username,
      'homework_id': homeworkID,
      'business_id': businessID
    };
  }

  GetHomeworkStudentModel.fromJson(Map<String, dynamic> json,
      {required super.businessID,
      required super.homeworkID,
      required super.sectionID,
      required super.username}) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? teacherId;
  int? studentId;
  String? studentName;
  int? classId;
  String? className;
  int? homeworkId;
  String? uploadUrl;
  String? statusCode;
  String? remarks;
  bool? isChecked;
  bool? isCorrect;
  String? remark;
  int? is_teacher_homework_checked;

  Data(
      {this.teacherId,
      this.studentId,
      this.studentName,
      this.classId,
      this.className,
      this.homeworkId,
      this.uploadUrl,
      this.statusCode,
      this.remarks,
      this.isChecked,
      this.isCorrect,
      this.is_teacher_homework_checked});

  Data.fromJson(
    Map<String, dynamic> json,
  ) {
    teacherId = json['teacher_id'];
    studentId = json['student_id'];
    studentName = json['Student_Name'];
    classId = json['Class_Id'];
    className = json['Class_Name'];
    homeworkId = json['homework_id'];
    uploadUrl = json['upload_url'];
    statusCode = json['status_code'];
    remarks = json['remarks'];
    is_teacher_homework_checked = json['is_teacher_homework_checked'];
    isChecked = json['status_code'] != null && json['status_code'].isNotEmpty;
    isCorrect = json['status_code'] == 'C'
        ? true
        : json['status_code'] == 'W'
            ? false
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['student_id'] = studentId;
    data['Student_Name'] = studentName;
    data['Class_Id'] = classId;
    data['Class_Name'] = className;
    data['homework_id'] = homeworkId;
    data['upload_url'] = uploadUrl;
    data['status_code'] = statusCode;
    data['remarks'] = remarks;
    data['is_checked'] = isChecked;
    data['is_correct'] = isCorrect;
    data['is_teacher_homework_checked'] = is_teacher_homework_checked;
    return data;
  }
}
