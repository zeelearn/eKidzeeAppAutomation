import 'dart:convert';

class AttandanceRequest {
  late String teacherId;
  late String userId;
  late String programID;
  late String d;
  late String inputDate;
  late String remarks;
  late List<AttandanceModel> attandanceList;

  AttandanceRequest({required this.teacherId,
    required this.userId,
    required this.programID,
    required this.d,
    required this.inputDate,
    required this.remarks,
    required this.attandanceList});

  AttandanceRequest.fromJson(Map<String, dynamic> json) {
    teacherId = json['TeacherId'];
    userId = json['UserId'];
    programID = json['Program_ID'];
    d = json['D'];
    inputDate = json['InputDate'];
    remarks = json.containsKey('Remarks') ? json['Remarks'] ?? '' : '';
    if (json['InputData'] != null) {
      attandanceList = <AttandanceModel>[];
      json['InputData'].forEach((v) {
        attandanceList.add(new AttandanceModel.fromJson(v));
      });
    }
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.teacherId,
      'UserId': this.userId,
      'Program_ID': this.programID,
      'D': this.d,
      'InputDate': this.inputDate,
      'InputData': this.attandanceList,
      'Remarks': this.remarks,
    });
  }

}

class AttandanceModel {
  late String studentID;
  late bool isPresent;

  AttandanceModel({ required this.studentID,required this.isPresent});

  AttandanceModel.fromJson(Map<String, dynamic> json) {
    studentID = json['StudentID'];
    isPresent = json['IsPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentID'] = this.studentID;
    data['IsPresent'] = this.isPresent;
    return data;
  }
}
