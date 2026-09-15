import '../../../../globals.dart';

class GetParentCornerArtsyStudentListResponse {
  GetParentCornerArtsyStudentListResponse({
    required this.success,
    required this.studentList,
  });
  late final int success;
  late final List<ArtsyStudentModel> studentList;

  GetParentCornerArtsyStudentListResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    studentList = List.from(json['data']).map((e)=>ArtsyStudentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = studentList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ArtsyStudentModel {
  ArtsyStudentModel({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.ParentMediaUrl,
    required this.StatusCode,
  });
  late final int StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late final String ParentMediaUrl;
  late final String StatusCode;

  ArtsyStudentModel.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'];
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'];
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name'];
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'];
    ParentMediaUrl = convertStringJson(json, 'ParentMediaUrl');//json['ParentMediaUrl'];
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['ParentMediaUrl'] = ParentMediaUrl;
    _data['StatusCode'] = StatusCode;
    return _data;
  }
}