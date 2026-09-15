
import 'dart:convert';

import '../../../../response/pentemind/learninggoals/academic/GetAcademicStudentListResponse.dart';

class AcademicFeedbackRequest {
  AcademicFeedbackRequest({
    required this.TeacherId,
    required this.UserId,
    required this.ProgramID,
    required this.studentInfo,
  });
  late final String TeacherId;
  late final String UserId;
  late final int ProgramID;
  late final List<AcademicStudentInfo> studentInfo;

  AcademicFeedbackRequest.fromJson(Map<String, dynamic> json){
    TeacherId = json['TeacherId'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    studentInfo = List.from(json['InputData']).map((e)=>AcademicStudentInfo.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.TeacherId,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'InputData': studentInfo.map((e)=>e.toJson()).toList()
    });
  }


}