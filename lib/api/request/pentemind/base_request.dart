import 'dart:convert';


class BasePentemindRequest {
  late int Program_ID;
  late String userId;


  BasePentemindRequest({required this.Program_ID,
    required this.userId});

  BasePentemindRequest.fromJson(Map<String, dynamic> json) {
    Program_ID = json['Program_ID'];
    userId = json['User_ID'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.Program_ID,
      'User_ID': this.userId,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }
  getTrackerJson() {
    return jsonEncode({
      'Program_Id': this.Program_ID,
      'User_ID': this.userId,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

  toDayJson(String day) {
    return jsonEncode({
      'Program_ID': this.Program_ID,
      'User_ID': this.userId,
      'D': day,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

  toTrackerJson(String studentid) {
    return jsonEncode({
      'Program_Id': this.Program_ID,
      'User_ID': this.userId,
      'StudentID': studentid,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

  toReport() {
    return jsonEncode({
      'Program_Id': this.Program_ID,
      'Student_id': this.userId,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

    toHomeWork(String studentId) {
    return jsonEncode({
      'Program_ID': this.Program_ID,
      'User_ID': this.userId,
      'StudentID': studentId,
      //'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

}

