import '../../../../globals.dart';

class StudentListResponse {
  int success = 0;
  List<StudentInfoModel> data = [];

  StudentListResponse({required this.success, required this.data});

  StudentListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StudentInfoModel>[];
      json['data'].forEach((v) {
        data.add(new StudentInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class StudentInfoModel {
  late String studentID;
  late String studentName;
  late String parentName;
  late String mobileNo;
  late bool isPresent;
  late String cName;
  late String Remarks;
  late String studentprofileURL;
  late int d;
  late int BackDateAttendance;

  StudentInfoModel(
      {required this.studentID,
      required this.studentName,
      required this.parentName,
      required this.mobileNo,
      required this.isPresent,
      required this.studentprofileURL,
      required this.cName,
      required this.Remarks,
      required this.BackDateAttendance,
      required this.d});

  StudentInfoModel.fromJson(Map<String, dynamic> json) {
    studentID = convertStringJson(json,
        'StudentID'); // json.containsKey('studentID') && json['studentID']!=null ?  json['StudentID'] ?? '' : '';
    studentName = convertStringJson(json,
        'Student_Name'); //json.containsKey('Student_Name') && json['Student_Name']!=null ? json['Student_Name'] ?? '' : '';
    parentName = convertStringJson(json,
        'Parent_Name'); //json.containsKey('Parent_Name') && json['Parent_Name']!=null ? json['Parent_Name'] ?? '' : '';
    mobileNo = convertStringJson(json,
        'Mobile_No'); //json.containsKey('Mobile_No') && json['Mobile_No']!=null ? json['Mobile_No'] ?? '' : '';
    studentprofileURL = convertStringJson(json,
        'studentprofileURL'); //json.containsKey('studentprofileURL') && json['studentprofileURL']!=null ? json['studentprofileURL'] ?? '' : '';
    isPresent = json['IsPresent'] ?? false;
    cName = convertStringJson(json,
        'CName'); //json.containsKey('CName') && json['CName']!=null ? json['CName'] ?? '' : '';
    d = convertintJson(json,
        'D'); //json.containsKey('D') && json['D']!=null ? json['D'] : 0 ?? 0;
    BackDateAttendance = json.containsKey('isEditable')
        ? convertintJson(json, 'isEditable')
        : 0; //json.containsKey('D') && json['D']!=null ? json['D'] : 0 ?? 0;
    Remarks = convertStringJson(json,
        'Remarks'); //json.containsKey('Remarks') && json['Remarks']!=null ? json['Remarks'] : '' ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentID'] = this.studentID;
    data['Student_Name'] = this.studentName;
    data['Parent_Name'] = this.parentName;
    data['Mobile_No'] = this.mobileNo;
    data['studentprofileURL'] = this.studentprofileURL;
    data['IsPresent'] = this.isPresent;
    data['CName'] = this.cName;
    data['D'] = this.d;
    data['BackDateAttendance'] = this.BackDateAttendance;
    data['Remarks'] = this.Remarks;
    return data;
  }
}

class FloatingDayModel {
  late String cName;
  late int d;

  FloatingDayModel({required this.cName, required this.d});

  FloatingDayModel.fromJson(Map<String, dynamic> json) {
    cName = json.containsKey('CName') ? json['CName'] ?? '' : '';
    d = json.containsKey('D') ? int.parse(json['D'].toString()) : 0 ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CName'] = this.cName;
    data['D'] = this.d;
    return data;
  }
}
