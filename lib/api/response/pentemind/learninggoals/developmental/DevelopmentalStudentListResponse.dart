import '../../../../../globals.dart';

class DevelopmentalStudentListResponse {
  DevelopmentalStudentListResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late List<DevelopmentalStudentModel> data;

  DevelopmentalStudentListResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>DevelopmentalStudentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DevelopmentalStudentModel {
  DevelopmentalStudentModel({
    required this.D,
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.Rating,
    required this.LGDID,
    required this.enumRating,
    required this.IsPresent,
  });
  late final int D;
  late final String StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  String? Rating;
  int? LGDID;
  late final String enumRating;
  late final bool IsPresent;

  DevelopmentalStudentModel.fromJson(Map<String, dynamic> json){
    D = convertintJson(json, 'D');//json['D']  ?? '';
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID']  ?? '';
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name']  ?? '';
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name']  ?? '';
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No']  ?? '';
    Rating = convertStringJson(json, 'Rating');//json['Rating'] ?? '';
    enumRating = convertStringJson(json, 'enum_rating');//json['enum_rating']  ?? '';
    IsPresent = json['IsPresent']  ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['D'] = D  ?? '';
    _data['StudentID'] = StudentID  ?? '';
    _data['Student_Name'] = StudentName  ?? '';
    _data['Parent_Name'] = ParentName  ?? '';
    _data['Mobile_No'] = MobileNo  ?? '';
    _data['Rating'] = Rating  ?? '';
    _data['LGDID'] = LGDID  ?? '';
    _data['enum_rating'] = enumRating  ?? '';
    _data['IsPresent'] = IsPresent  ?? false;
    return _data;
  }
}