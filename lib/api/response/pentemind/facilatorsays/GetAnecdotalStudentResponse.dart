import '../../../../globals.dart';

class GetAnecdotalStudentResponse {
  GetAnecdotalStudentResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<AnecdotalStudentModel> data;

  GetAnecdotalStudentResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>AnecdotalStudentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AnecdotalStudentModel {
  AnecdotalStudentModel({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.RefKey,
    required this.RefValue,
    required this.Remarks,
    required this.group,
  });
  late final String StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late final String RefKey;
  String RefValue='';
  late final String Remarks;
  late int group = 0;

  AnecdotalStudentModel.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'];
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'] ?? '';
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name'] ?? '';
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'] ?? '';
    RefKey = convertStringJson(json, 'RefKey');//json['RefKey'] ?? '';
    RefValue = convertStringJson(json, 'RefValue');//json['RefValue'] ?? '';
    Remarks = convertStringJson(json, 'Remarks');//json['Remarks'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['RefKey'] = RefKey;
    _data['RefValue'] = RefValue;
    _data['Remarks'] = Remarks;
    return _data;
  }
}