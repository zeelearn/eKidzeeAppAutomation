import 'dart:convert';

class LearningMaterialRequest {
  LearningMaterialRequest({
    required this.ProgramID,
    required this.D,
    required this.ContentCategory,
    required this.UserID,
  });
  late final String ProgramID;
  late final String D;
  late final String ContentCategory;
  late final String UserID;

  LearningMaterialRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    D = json['D'];
    ContentCategory = json['ContentCategory'];
    UserID = json['User_ID'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'ContentCategory': this.ContentCategory,
      'D': this.D,
      'User_ID': this.UserID,
    });
  }

}