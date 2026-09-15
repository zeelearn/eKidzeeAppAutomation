import 'dart:convert';

import '../../../../globals.dart';
import '../../../response/pentemind/dailyactivity/homestudentlist.dart';

class UpdateHomeworkStudentRequest {
  UpdateHomeworkStudentRequest({
    required this.HomeworkID,
    required this.TransType,
    required this.TeacherID,
    required this.UserID,
    required this.ProgramID,
    required this.InputDate,
    required this.InputData,
  });
  late final String HomeworkID;
  late final String TransType;
  late final String TeacherID;
  late final String UserID;
  late final String ProgramID;
  late final String InputDate;
  late final List<HomeWorkStudentModel> InputData;

  UpdateHomeworkStudentRequest.fromJson(Map<String, dynamic> json){
    HomeworkID = json['HomeworkID'];
    TransType = json['TransType'];
    TeacherID = json['TeacherID'];
    UserID = json['User_ID'];
    ProgramID = json['Program_ID'];
    InputDate = json['InputDate'];
    InputData = List.from(json['InputData']).map((e)=>HomeWorkStudentModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'HomeworkID': this.HomeworkID,
      'TransType': this.TransType,
      'TeacherID': this.TeacherID,
      'User_ID': this.UserID,
      'Program_ID': this.ProgramID,
      'InputDate': this.InputDate,
      'InputData': InputData.map((e)=>e.toUpdateJson()).toList(),
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

}
