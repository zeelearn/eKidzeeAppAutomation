import 'dart:convert';

class GetDayRequest {
  GetDayRequest({
    required this.ProgramId,
    required this.AttendanceDate,
    required this.D,
    required this.CName,
  });
  late final String ProgramId;
  late final String AttendanceDate;
  late final int D;
  late final String CName;

  GetDayRequest.fromJson(Map<String, dynamic> json){
    ProgramId = json['Program_Id'];
    AttendanceDate = json['AttendanceDate'] ?? '';
    D = json['D'] ?? '';
    CName = json['CName'] ?? '';
  }

  toJson() {
    return jsonEncode({
      'Program_Id': this.ProgramId,
      'AttendanceDate': this.AttendanceDate,
      'D': this.D,
      'CName': this.CName,
    });
  }

}