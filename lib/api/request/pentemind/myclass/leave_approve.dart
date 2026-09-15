import 'dart:convert';

class LeaveApproveRequest {
  LeaveApproveRequest({
    required this.ID,
    required this.Status,
    required this.UserId,
  });
  late final String ID;
  late final String Status;
  late final String UserId;

  LeaveApproveRequest.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    Status = json['Status'];
    UserId = json['UserId'];
  }

  toJson() {
    return jsonEncode({
      'ID': this.ID,
      'Status': this.Status,
      'UserId': this.UserId,
    });
  }

  toKESJson() {
    return jsonEncode({
      'leave_record_id': this.ID,
      'status': this.Status,
      'username': this.UserId,
    });
  }
}
