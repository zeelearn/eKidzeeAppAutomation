import 'package:ekidzee/globals.dart';

class GetHomeworkStudentResponse {
  GetHomeworkStudentResponse({
    required this.success,
    required this.studentList,
  });
  late final int success;
  late final List<HomeWorkStudentModel> studentList;

  GetHomeworkStudentResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    studentList = List.from(json['data']).map((e)=>HomeWorkStudentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = studentList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class HomeWorkStudentModel {
  HomeWorkStudentModel({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.UploadUrl,
    required this.PStatusCode,
    required this.TStatusCode,
    required this.Remarks,
  });
  late final String StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late final String UploadUrl;
  late final String PStatusCode;
  late String TStatusCode;
  late String Remarks;

  HomeWorkStudentModel.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'] ?? '';
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'] ?? '';
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name'] ?? '';
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'] ?? '';
    UploadUrl = convertStringJson(json, 'UploadUrl');//json['UploadUrl'] ?? '';
    PStatusCode = convertStringJson(json, 'P_StatusCode');//json['P_StatusCode'] ?? '';
    TStatusCode = convertStringJson(json, 'T_StatusCode');//json['T_StatusCode'] ?? '';
    Remarks = convertStringJson(json, 'Remarks');//json['Remarks'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['UploadUrl'] = UploadUrl;
    _data['P_StatusCode'] = PStatusCode;
    _data['T_StatusCode'] = TStatusCode;
    _data['Remarks'] = Remarks;
    return _data;
  }

  Map<String, dynamic> toUpdateJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['T_StatusCode'] = TStatusCode;
    _data['Remarks'] = Remarks;
    return _data;
  }
}