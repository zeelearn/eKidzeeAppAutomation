import 'dart:convert';

class ArtsyRequest {
  ArtsyRequest({
    required this.ProgramID,
    required this.C,
    required this.FeeType,
    required this.UserID,
    required this.StudentID,
  });
  late final int ProgramID;
  late final String C;
  late final String FeeType;
  late final String UserID;
  late final int StudentID;

  ArtsyRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    C = json['C'];
    FeeType = json['Fee_Type'];
    UserID = json['User_ID'];
    StudentID = json['StudentID'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'C': this.C,
      'Fee_Type': this.FeeType,
      'User_ID': this.UserID,
      'StudentID': this.StudentID,
    });
  }

}