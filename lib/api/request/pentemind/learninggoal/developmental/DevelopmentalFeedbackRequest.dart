import 'dart:convert';

import '../../../../response/pentemind/learninggoals/developmental/DevelopmentalStudentListResponse.dart';

class DevelopmentalFeedbackRequest {
  DevelopmentalFeedbackRequest({
    required this.TeacherId,
    required this.UserId,
    required this.ProgramID,
    required this.ObservationType,
    required this.feedbackList,
  });
  late final String TeacherId;
  late final String UserId;
  late final int ProgramID;
  late final String ObservationType;
  late final List<DevelopmentalStudentModel> feedbackList;

  DevelopmentalFeedbackRequest.fromJson(Map<String, dynamic> json){
    TeacherId = json['TeacherId'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    ObservationType = json['ObservationType'];
    feedbackList = List.from(json['InputData']).map((e)=>DevelopmentalStudentModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.TeacherId,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'ObservationType': this.ObservationType,
      'InputData': feedbackList.map((e)=>e.toJson()).toList(),
    });
  }


}
