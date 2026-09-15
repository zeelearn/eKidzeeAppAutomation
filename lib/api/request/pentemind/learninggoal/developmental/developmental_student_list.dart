import 'dart:convert';

class DevelopmentalStudentListRequest {
  DevelopmentalStudentListRequest({
    required this.UserID,
    required this.ProgramId,
    required this.LGDID,
    required this.ObservationType,
    required this.D,
  });
  late final String UserID;
  late final int ProgramId;
  late final int LGDID;
  late final String ObservationType;
  late final int D;

  DevelopmentalStudentListRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramId = json['Program_Id'];
    LGDID = json['LGDID'];
    ObservationType = json['ObservationType'];
    D = json['D'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_Id': this.ProgramId,
      'LGDID': this.LGDID,
      'ObservationType': this.ObservationType,
      'D': this.D,
    });
  }

}