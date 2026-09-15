import 'dart:convert';

import '../../../../globals.dart';

class GetHomeworkStudentRequest {
  GetHomeworkStudentRequest({
    required this.UserID,
    required this.ProgramID,
    required this.HomeworkID,
    required this.TransType,
    required this.StudentID,
  });
  late final String UserID;
  late final String ProgramID;
  late final String HomeworkID;
  late final String TransType;
  late final String StudentID;

  GetHomeworkStudentRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramID = json['Program_ID'];
    HomeworkID = json['HomeworkID'];
    TransType = json['TransType'];
    StudentID = json['StudentID'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_ID': this.ProgramID,
      'HomeworkID': this.HomeworkID,
      'TransType': this.TransType,
      'StudentID': this.StudentID,
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }
}