import '../../../../globals.dart';

class ApprovalResponse {
  ApprovalResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<ApprovalData> data;

  ApprovalResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>ApprovalData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ApprovalData {
  ApprovalData({
    required this.ID,
    required this.Subject,
    required this.Body,
    required this.ApprovalStatus,
  });
  late final int ID;
  late final String Subject;
  late final String Body;
  late final String ApprovalStatus;
  late final String StudentName;
  late bool isApprove=false;

  ApprovalData.fromJson(Map<String, dynamic> json){
    ID = convertintJson(json, 'ID');//json['ID'];
    Subject = convertStringJson(json, 'Subject');//json['Subject'];
    Body = convertStringJson(json, 'Body');//json['Body'];
    ApprovalStatus = convertStringJson(json, 'ApprovalStatus');//json['ApprovalStatus'];
    StudentName = convertStringJson(json, 'StudentName');//json['ApprovalStatus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['Subject'] = Subject;
    _data['Body'] = Body;
    _data['ApprovalStatus'] = ApprovalStatus;
    _data['StudentName'] = StudentName;
    return _data;
  }
}