/* {
    "username":"T192335",
    "business_id":1,
    "section_id":291949,
    "homework_id":1248,
    "inputdata":[{"student_id":63323,"status_code":"C","remarks":"test save correction"}]
} */

class UpdateDailyHomeworkEntity {
  String username;
  int businessId;
  int sectionId;
  int homeworkId;
  List<InputData> inputData;

  UpdateDailyHomeworkEntity({
    required this.username,
    required this.businessId,
    required this.sectionId,
    required this.homeworkId,
    required this.inputData,
  });
}

class InputData {
  int studentId;
  String statusCode;
  String remarks;

  InputData({
    required this.studentId,
    required this.statusCode,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['status_code'] = statusCode;
    data['remarks'] = remarks;
    return data;
  }
}
