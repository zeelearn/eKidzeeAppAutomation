import 'dart:convert';

class UpdateHomeWorkRequest {
  UpdateHomeWorkRequest({
    required this.HomeworkID,
    required this.TransType,
    required this.TeacherID,
    required this.UserID,
    required this.ProgramID,
    required this.InputDate,
    required this.InputData,
  });
  late final String HomeworkID;
  late final String TeacherID;
  late final String TransType;
  late final String UserID;
  late final String ProgramID;
  late final String InputDate;
  late final List<UploadHomwworkData> InputData;

  UpdateHomeWorkRequest.fromJson(Map<String, dynamic> json){
    HomeworkID = json['HomeworkID'];
    TransType = json['TransType'];
    TeacherID =  json['TeacherID'];
    UserID = json['User_ID'];
    ProgramID = json['Program_ID'];
    InputDate = json['InputDate'];
    InputData = List.from(json['InputData']).map((e)=>UploadHomwworkData.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'HomeworkID': this.HomeworkID,
      'TransType': this.TransType,
      'TeacherID': this.TeacherID,
      'User_ID': this.UserID,
      'Program_ID': this.ProgramID,
      'InputDate': this.InputDate,
      'InputData': this.InputData.map((e)=>e.toJson()).toList(),
    });
  }


}

class UploadHomwworkData {
  UploadHomwworkData({
    required this.UploadUrl,
    required this.StudentID,
    required this.PStatusCode,
    required this.Remarks,
  });
  String UploadUrl='';
  late final String StudentID;
  late final String PStatusCode;
  late final String Remarks;

  UploadHomwworkData.fromJson(Map<String, dynamic> json){
    UploadUrl = json['UploadUrl'];
    StudentID = json['StudentID'];
    PStatusCode = json['P_StatusCode'];
    Remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['UploadUrl'] = UploadUrl;
    _data['StudentID'] = StudentID;
    _data['P_StatusCode'] = PStatusCode;
    _data['Remarks'] = Remarks;
    return _data;
  }
}