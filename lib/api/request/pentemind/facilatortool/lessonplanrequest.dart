import 'dart:convert';

class LessonPlanRequest {
  LessonPlanRequest({
    required this.ClassId,
    required this.D,
    required this.UserID,
    required this.termType,
  });
  late final String ClassId;
  late final String D;
  late final String UserID;
  late final String termType;

  LessonPlanRequest.fromJson(Map<String, dynamic> json){
    ClassId = json['Class_Id'];
    D = json['D'];
    UserID = json['User_ID'];
    termType = json['Class_Term_Type'];
  }

  toJson() {
    return jsonEncode({
      'Class_Id': this.ClassId,
      'D': this.D,
      'User_ID': this.UserID,
      'Class_Term_Type': this.termType,
    });
  }
  toGuidelineJson() {
    return jsonEncode({
      'Class_Id': this.ClassId,
      'User_ID': this.UserID,
      'Class_Term_Type': this.termType,
    });
  }
}