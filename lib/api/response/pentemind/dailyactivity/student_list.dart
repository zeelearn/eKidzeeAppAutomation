import 'dart:convert';

import 'package:ekidzee/globals.dart';

class DailyActivityStudListResponse {
  DailyActivityStudListResponse({
    required this.success,
    required this.studentList,
  });
  late final int success;
  late final List<DAStudentInfo> studentList;

  DailyActivityStudListResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    studentList = List.from(json['data']).map((e)=>DAStudentInfo.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'success': this.success,
      'data': studentList.map((e)=>e.toJson()).toList(),

    });
  }

}

class DAStudentInfo {
  DAStudentInfo({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.StatusCode,
    required this.IsPresent,
    required this.LogBookStatusCode,
  });
  late final String StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late String StatusCode;
  late bool IsPresent;
  late String LogBookStatusCode;
  late String DWSType;

  DAStudentInfo.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'] ?? '';
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'] ?? '';
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name'] ?? '';
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'] ?? '';
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'] ?? '';
    IsPresent = json['IsPresent'] ?? false;
    LogBookStatusCode = convertStringJson(json, 'LogBookStatusCode');//json['LogBookStatusCode'] ?? '';
    DWSType = '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['StatusCode'] = StatusCode;
    _data['IsPresent'] = IsPresent;
    _data['LogBookStatusCode'] = LogBookStatusCode;
    _data['DWSType'] = DWSType;
    return _data;
  }
}