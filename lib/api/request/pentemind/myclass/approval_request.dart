import 'dart:convert';

class ApprovalRequest {
  ApprovalRequest({
    required this.fromdate,
    required this.todate,
    required this.ReqType,
    required this.programID,
    required this.ApprovalStatus,
  });
  late final String fromdate;
  late final String todate;
  late final String ReqType;
  late final String programID;
  late final String ApprovalStatus;

  ApprovalRequest.fromJson(Map<String, dynamic> json){
    fromdate = json['fromdate'];
    todate = json['todate'];
    ReqType = json['ReqType'];
    programID = json['programID'];
    ApprovalStatus = json['ApprovalStatus'];
  }

  toJson() {
    return jsonEncode({
      'fromdate': this.fromdate,
      'todate': this.todate,
      'ReqType': this.ReqType,
      'programID': this.programID,
      'ApprovalStatus': this.ApprovalStatus,
    });
  }
}