import 'dart:convert';

class UpdateArtsyRequest {
  UpdateArtsyRequest({
    required this.ProgramID,
    required this.ClassId,
    required this.StudentID,
    required this.UserID,
    required this.InputData,
  });
  late final String ProgramID;
  late final String ClassId;
  late final String StudentID;
  late final String UserID;
  late final UpdateParentArtsyModel InputData;

  UpdateArtsyRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    ClassId = json['Class_Id'];
    StudentID = json['StudentID'];
    UserID = json['User_ID'];
    InputData = UpdateParentArtsyModel.fromJson(json['InputData']);
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'Class_Id': this.ClassId,
      'StudentID': this.StudentID,
      'User_ID': this.UserID,
      'InputData': InputData.toJson()
    });
  }


}

class UpdateParentArtsyModel {
  UpdateParentArtsyModel({
    required this.PCID,
    required this.StatusCode,
    required this.ParentMediaUrl,
    required this.TransType,
  });
  late final String PCID;
  late final String StatusCode;
  String ParentMediaUrl='';
  late final String TransType;

  UpdateParentArtsyModel.fromJson(Map<String, dynamic> json){
    PCID = json['PCID'];
    StatusCode = json['StatusCode'];
    ParentMediaUrl = json['ParentMediaUrl'];
    TransType = json['TransType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PCID'] = PCID;
    _data['StatusCode'] = StatusCode;
    _data['ParentMediaUrl'] = ParentMediaUrl;
    _data['TransType'] = TransType;
    return _data;
  }
}