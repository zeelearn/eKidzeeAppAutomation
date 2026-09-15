import 'dart:convert';

import 'package:intl/intl.dart';

class KESLeaveRequest {
  String? username;
  int? sectionId;
  String? subject;
  String? body;
  String? fromdate;
  String? todate;

  KESLeaveRequest(
      {this.username,
      this.sectionId,
      this.subject,
      this.body,
      this.fromdate,
      this.todate});

  KESLeaveRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    sectionId = json['section_id'];
    subject = json['subject'];
    body = json['body'];
    fromdate = json['fromdate'];
    todate = json['todate'];
  }
  toJson() {
    return jsonEncode({
      'username': this.username,
      'section_id': this.sectionId,
      'subject': this.subject,
      'body': this.body,
      'fromdate': DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd-MMM-yyyy').parse(this.fromdate!)),
      'todate': DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd-MMM-yyyy').parse(this.todate!))
    });
  }
}

class AddLeaveRequest {
  AddLeaveRequest({
    required this.ProgramID,
    required this.UserId,
    required this.InputData,
  });
  late final String ProgramID;
  late final String UserId;
  late final List<LeaveRequestModel> InputData;

  AddLeaveRequest.fromJson(Map<String, dynamic> json) {
    ProgramID = json['Program_ID'];
    UserId = json['UserId'];
    InputData = List.from(json['InputData'])
        .map((e) => LeaveRequestModel.fromJson(e))
        .toList();
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'UserId': this.UserId,
      'InputData': InputData.map((e) => e.toJson()).toList()
    });
  }

  toMlzsJson() {
    return jsonEncode({
      'programId': this.ProgramID,
      'body': InputData[0].Body,
      'UserId': this.UserId,
      'subject': InputData[0].Subject,
      'fromdate': InputData[0].Leavedate,
      'studentId': InputData[0].StudentID,
      'todate': InputData[0].toDate,
    });
  }
}

class LeaveRequestModel {
  LeaveRequestModel(
      {required this.StudentID,
      required this.Subject,
      required this.Body,
      required this.RequestType,
      required this.MsgType,
      required this.Leavedate,
      required this.toDate});
  late final int StudentID;
  late final String Subject;
  late final String Body;
  late final String RequestType;
  late final String MsgType;
  late final String Leavedate;
  late final String toDate;

  LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    StudentID = json['StudentID'];
    Subject = json['Subject'];
    Body = json['Body'];
    RequestType = json['RequestType'];
    MsgType = json['Msg_Type'];
    Leavedate = json['LeaveFromDate'];
    toDate = json['LeaveToDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Subject'] = Subject;
    _data['Body'] = Body;
    _data['RequestType'] = RequestType;
    _data['Msg_Type'] = MsgType;
    _data['LeaveFromDate'] = Leavedate;
    _data['LeaveToDate'] = toDate;
    return _data;
  }

  toKESJson() {
    return jsonEncode({
      'StudentID': this.StudentID,
      'Subject': this.Subject,
      'Body': this.Body,
      'RequestType': this.RequestType,
      'Msg_Type': this.MsgType,
      'LeaveFromDate': this.Leavedate,
      'LeaveToDate': this.toDate,
    });
  }
}
