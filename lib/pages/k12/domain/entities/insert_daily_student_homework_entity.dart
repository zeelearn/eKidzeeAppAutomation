/* {
    "username":"P2696362",
    "inputdata":[{"homework_id":1248,"upload_url":"https://www.ekidzee.com/RenewalCertificate.html?FId=1169&RFormId=2804"},{"homework_id":1081,"upload_url":"https://www.ekidzee.com/RenewalCertificate.html?FId=1169&RFormId=2804"}],
    "business_id":1,
    "student_id":0,
    "section_id":291949
} */

class InsertDailyStudentHomeworkEntity {
  String username;
  List<InputData> inputData;
  int businessId;
  int studentId;
  int sectionId;

  InsertDailyStudentHomeworkEntity({
    required this.username,
    required this.inputData,
    required this.businessId,
    required this.studentId,
    required this.sectionId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['business_id'] = businessId;
    data['student_id'] = studentId;
    data['section_id'] = sectionId;
    data['inputdata'] = inputData.map((v) => v.toJson()).toList();
    return data;
  }
}

class InputData {
  int homeworkId;
  String uploadUrl;

  InputData({
    required this.homeworkId,
    required this.uploadUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homework_id'] = homeworkId;
    data['upload_url'] = uploadUrl;
    return data;
  }
}
