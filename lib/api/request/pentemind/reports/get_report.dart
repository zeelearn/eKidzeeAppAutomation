import 'dart:convert';

class GetReportRequest {
  GetReportRequest({
    required this.ReportId,
    required this.UserID,
    required this.UserType,
    required this.EntityId,
    required this.ProgramID,
    required this.ClassId,
    required this.FeeType,
  });
  late final int ReportId;
  late final String UserID;
  late final String UserType;
  late final String EntityId;
  late final String ProgramID;
  late final String ClassId;
  late final String FeeType;

  GetReportRequest.fromJson(Map<String, dynamic> json){
    ReportId = json['Report_Id'];
    UserID = json['UserID'];
    UserType = json['User_Type'];
    EntityId = json['Entity_Id'];
    ProgramID = json['Program_ID'];
    ClassId = json['Class_Id'];
    FeeType = json['Fee_Type'];
  }

  toJson() {
    return jsonEncode({
      'Report_Id': this.ReportId,
      'UserID': this.UserID,
      'User_Type': this.UserType,
      'Entity_Id': this.EntityId,
      'Program_ID': this.ProgramID,
      'Class_Id': this.ClassId,
      'Fee_Type': this.FeeType,
    });
  }
}