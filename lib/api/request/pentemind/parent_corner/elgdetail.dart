import 'dart:convert';

class ElgDetailsRequest {
  ElgDetailsRequest({
    required this.UserID,
    required this.ProgramId,
    required this.PCID,
    required this.C,
    required this.StudentID,
  });
  late final String UserID;
  late final String ProgramId;
  late final String PCID;
  late final String C;
  late final int StudentID;

  ElgDetailsRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramId = json['Program_Id'];
    PCID = json['PCID'];
    C = json['C'];
    StudentID = json['StudentID'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_Id': this.ProgramId,
      'PCID': this.PCID,
      'C': this.C,
      'StudentID': this.StudentID,
    });
  }

}