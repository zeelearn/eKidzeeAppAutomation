import 'dart:convert';

class AddLeaveRequest {
  AddLeaveRequest({
    required this.ProgramID,
    required this.UserId,
    required this.InputData,
  });
  late final String ProgramID;
  late final String UserId;
  late final List<LeaveRequestModel> InputData;

  AddLeaveRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    UserId = json['UserId'];
    InputData = List.from(json['InputData']).map((e)=>LeaveRequestModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'UserId': this.UserId,
      'InputData': InputData.map((e)=>e.toJson()).toList()
    });
  }

}

class LeaveRequestModel {
  LeaveRequestModel({
    required this.StudentID,
    required this.Subject,
    required this.Body,
    required this.RequestType,
    required this.MsgType,
    required this.Leavedate,
  });
  late final int StudentID;
  late final String Subject;
  late final String Body;
  late final String RequestType;
  late final String MsgType;
  late final String Leavedate;

  LeaveRequestModel.fromJson(Map<String, dynamic> json){
    StudentID = json['StudentID'];
    Subject = json['Subject'];
    Body = json['Body'];
    RequestType = json['RequestType'];
    MsgType = json['Msg_Type'];
    Leavedate = json['Leavedate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Subject'] = Subject;
    _data['Body'] = Body;
    _data['RequestType'] = RequestType;
    _data['Msg_Type'] = MsgType;
    _data['Leavedate'] = Leavedate;
    return _data;
  }
}