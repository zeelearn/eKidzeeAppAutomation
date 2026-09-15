import 'dart:convert';

class GetAcademicRequest {
  GetAcademicRequest({
    required this.ProgramID,
    required this.D,
    required this.LGAID,
    required this.UserID,
  });
  late final int ProgramID;
  late final String D;
  late final String LGAID;
  late final int UserID;

  GetAcademicRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    D = json['D'];
    LGAID = json['LGAID'];
    UserID = json['User_ID'];
  }

   toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'LGAID': this.LGAID,
      'D': this.D,
      'User_ID': this.UserID,
    });
  }

  getStudentList() {
    return jsonEncode({
      'Program_Id': this.ProgramID,
      'LGAID': this.LGAID,
      'User_ID': this.UserID,
    });
  }
}