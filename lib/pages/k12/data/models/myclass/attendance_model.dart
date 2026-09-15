import 'dart:convert';

class AttendanceModel {
  final String teacherId;
  final String userName;
  final int sectionId;
  final String attendanceDate;
  final int termId;
  final List<StudentAttandanceModel> attandance;
  final String? remarks;
  final int BusinessId;

  AttendanceModel({
    required this.teacherId,
    required this.sectionId,
    required this.userName,
    required this.attendanceDate,
    required this.termId,
    required this.attandance,
    required this.remarks,
    required this.BusinessId
  });

  Map<String, dynamic> toJson() {
    return {
      "TeacherId": null,
      "Section_ID": sectionId,
      "UserName": userName,
      "AttendanceDate": attendanceDate,
      "Term_Id": termId,
      "InputData": attandance.map((e) => e.toJson()).toList(),
      "Remarks": remarks,
      "BusinessId" : BusinessId
    };
  }
}

class StudentAttandanceModel {
  final int studentId;
  final int isPresent;

  StudentAttandanceModel({
    required this.studentId,
    required this.isPresent,
  });

  Map<String, dynamic> toJson() {
    return {
      "StudentID": studentId,
      "IsPresent": isPresent,
    };
  }
}
