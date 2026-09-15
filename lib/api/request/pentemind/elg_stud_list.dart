import 'dart:convert';

class ELGStudRequest {
  ELGStudRequest({
    required this.UserID,
    required this.ProgramId,
    required this.PCID,
    required this.C,
    required this.StudentID,
  });
  late final String UserID;
  late final String ProgramId;
  late final String PCID;
  late final int C;
  late final String StudentID;

  ELGStudRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramId = json['Program_Id'];
    PCID = json['PCID'];
    C = json['C'];
    StudentID = json['StudentID'];
  }

  toJson() {
    return jsonEncode({
      'Program_Id': this.ProgramId,
      'User_ID': this.UserID,
      'PCID': this.PCID,
      'C': this.C,
      'StudentID': this.StudentID,
    });
  }

}