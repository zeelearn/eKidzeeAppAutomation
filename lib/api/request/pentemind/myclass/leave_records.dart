import 'dart:convert';

class LeaveRecordRequest {
  LeaveRecordRequest({
    required this.UserId,
    required this.ProgramId,
    required this.TeacherId,
    required this.StudentID,
  });
  late final String UserId;
  late final String ProgramId;
  late final String TeacherId;
  late final String StudentID;

  LeaveRecordRequest.fromJson(Map<String, dynamic> json) {
    UserId = json['UserId'];
    ProgramId = json['Program_Id'];
    TeacherId = json['TeacherId'];
    StudentID = json['StudentID'];
  }

  toJson() {
    return jsonEncode({
      'UserId': this.UserId,
      'Program_Id': this.ProgramId,
      'TeacherId': this.TeacherId,
      'StudentID': this.StudentID,
    });
  }

  toKESJson() {
    return jsonEncode(
        {'username': this.UserId, 'section_id': this.ProgramId, 'search': ''});
  }
}
