import 'dart:convert';

class GetParentCornerArtsyStudentListRequest {
  GetParentCornerArtsyStudentListRequest({
    required this.UserID,
    required this.ProgramID,
    required this.PCID,
  });
  late final String UserID;
  late final int ProgramID;
  late final String PCID;

  GetParentCornerArtsyStudentListRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramID = json['Program_ID'];
    PCID = json['PCID'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_ID': this.ProgramID,
      'PCID': this.PCID,
    });
  }
  
}