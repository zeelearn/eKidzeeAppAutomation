import 'dart:convert';

import '../../../../../globals.dart';

class ChildInformationResponse {
  ChildInformationResponse({
    required this.success,
    required this.childInformationList,
  });
  late final int success;
  late final List<ChildInformationList> childInformationList;

  ChildInformationResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    childInformationList = List.from(json['data']).map((e)=>ChildInformationList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = childInformationList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ChildInformationList {
  ChildInformationList({
    required this.StudentID,
    required this.StudentName,
    required this.StartTermHeight,
    required this.StartTermWeight,
    required this.EndTermHeight,
    required this.EndTermWeight,
    required this.isEdit
  });
  late final String StudentID;
  late final String StudentName;
  String StartTermHeight='';
  String StartTermWeight='';
  String EndTermHeight='';
  String EndTermWeight='';
  bool isEdit=false;

  ChildInformationList.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'];
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'];
    StartTermHeight = convertStringJson(json, 'StartTermHeight');//json['StartTermHeight'] ?? '';
    StartTermWeight = convertStringJson(json, 'StartTermWeight');//json['StartTermWeight'] ?? '';
    EndTermHeight = convertStringJson(json, 'EndTermHeight');//json['EndTermHeight'] ?? '';
    EndTermWeight = convertStringJson(json, 'EndTermWeight');//json['EndTermWeight'] ?? '';
  }

  toJson() {
    return jsonEncode({
      'StudentID': this.StudentID,
      'Student_Name': this.StudentName,
      'StartTermHeight': this.StartTermHeight,
      'StartTermWeight': this.StartTermWeight,
      'StartTermWeight': this.StartTermWeight,
      'Student_Name': this.StudentName,
    });
  }

}