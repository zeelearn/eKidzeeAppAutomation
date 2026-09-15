import '../../../../../globals.dart';

class GetAcademicStudentListResponse {
  GetAcademicStudentListResponse({
    required this.success,
    required this.studentInfo,
  });
  late final int success;
  late final List<AcademicStudentInfo> studentInfo;

  GetAcademicStudentListResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    studentInfo = List.from(json['data']).map((e)=>AcademicStudentInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = studentInfo.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AcademicStudentInfo {
  AcademicStudentInfo({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.Rating,
    required this.enumRating,
    required this.LGAID,
  });
  late final String StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late String? Rating;
  late final String enumRating;
  late String? LGAID;

  AcademicStudentInfo.fromJson(Map<String, dynamic> json){
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'];
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'];
    ParentName = convertStringJson(json, 'Parent_Name');//json['Parent_Name'];
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'];
    Rating = convertStringJson(json, 'Rating');//json['Rating'];
    enumRating = convertStringJson(json, 'enum_rating');//json['enum_rating'];
    LGAID = convertStringJson(json, 'LGAID');
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['Rating'] = Rating;
    _data['enum_rating'] = enumRating;
    _data['LGAID'] = LGAID;
    return _data;
  }
}