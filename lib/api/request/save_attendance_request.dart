import 'dart:convert';

class SaveAttendanceRequest {
  late int yearID;
  late int batchID;
  late  int teacherID;
  late String date;
  late int franchiseeID;
  late String createdBy;
  late  List<AttendanceList> attendanceList;

  SaveAttendanceRequest(
      {required this.yearID,
        required this.batchID,
        required this.teacherID,
        required this.date,
        required this.franchiseeID,
        required this.createdBy,
        required this.attendanceList});

  SaveAttendanceRequest.fromJson(Map<String, dynamic> json) {
    yearID = json['YearID'];
    batchID = json['BatchID'];
    teacherID = json['TeacherID'];
    date = json['Date'];
    franchiseeID = json['FranchiseeID'];
    createdBy = json['CreatedBy'];
    if (json['AttendanceList'] != null) {
      attendanceList = <AttendanceList>[];
      json['AttendanceList'].forEach((v) {
        attendanceList.add(new AttendanceList.fromJson(v));
      });
    }
  }

  toJson(){
    return jsonEncode( {
      'YearID': this.yearID,
      'BatchID': this.batchID,
      'TeacherID': this.teacherID,
      'Date': this.date,
      'FranchiseeID': this.franchiseeID,
      'CreatedBy': this.createdBy,
      'AttendanceList': this.attendanceList
    });
  }

}

class AttendanceList {
  late String id;
  late String studentID;
  String? studentName;
  bool? isPresent;
  bool? isSMSSent;
  bool? isLateMark;
  late String  parentID;
  String? parentName;
  String? phone1;
  String? phone2;
  String? date;
  String? batchYear;
  String? lastSMS;

  AttendanceList(
      {required this.id,
        required this.studentID,
        required this.studentName,
        required this.isPresent,
        required this.isSMSSent,
        required this.isLateMark,
        required this.parentID,
        required this.parentName,
        required this.phone1,
        required this.phone2,
        required this.date,
        required this.batchYear,
        required this.lastSMS});

  AttendanceList.fromJson(Map<String, dynamic> json) {

    studentID = json['StudentID'];
    studentName = json['StudentName'];
    isPresent = json['IsPresent'];
    isSMSSent = json['IsSMSSent'];
    isLateMark = json['IsLateMark'];
    parentID = json['ParentID'];
    parentName = json['ParentName'];
    phone1 = json['Phone1'];
    phone2 = json['Phone2'];
    date = json['Date'];
    batchYear = json['Batch_year'];
    lastSMS = json['lastSMS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['StudentID'] = this.studentID;
    data['StudentName'] = this.studentName;
    data['IsPresent'] = this.isPresent;
    data['IsSMSSent'] = this.isSMSSent;
    data['IsLateMark'] = this.isLateMark;
    data['ParentID'] = this.parentID;
    data['ParentName'] = this.parentName;
    data['Phone1'] = this.phone1;
    data['Phone2'] = this.phone2;
    data['Date'] = this.date;
    data['Batch_year'] = this.batchYear;
    data['lastSMS'] = this.lastSMS;
    return data;
  }
}
