class StudentAttendanceList{

  late List<StudentAttendanceInfo> data;

  StudentAttendanceList({ required this.data});

  StudentAttendanceList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StudentAttendanceInfo>[];
      json['data'].forEach((v) {
        data.add(StudentAttendanceInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }


}
class StudentAttendanceInfo {
  late String id;
  late double studentID;
  late String studentName;
  late bool isPresent;
  late bool isSMSSent;
  late double parentID;
  late String parentName;
  late String phone1;
  late String phone2;
  late String date;
  late String batchYear;
  late String lastSMS;
  late bool isLateMark;

  StudentAttendanceInfo(
      {
        required this.id,
        required this.studentID,
        required this.studentName,
        required this.isPresent,
        required this.isSMSSent,
        required this.parentID,
        required this.parentName,
        required this.phone1,
        required this.phone2,
        required this.date,
        required this.batchYear,
        required this.lastSMS,
        required this.isLateMark});

  StudentAttendanceInfo.fromJson(Map<String, dynamic> json) {
    id = '0';
    studentID = json['StudentID'];
    studentName = json['StudentName'];
    isPresent = json['IsPresent'];
    isSMSSent = json['IsSMSSent'];
    parentID = json['ParentID'];
    parentName = json['ParentName'];
    phone1 = json['Phone1']==null ? '' :json['Phone1'];
    phone2 = json['Phone2']==null ? '' :json['Phone2'];
    date = json['Date']==null ? '' :json['Date'];
    batchYear = json['Batch_year'];
    lastSMS = json['lastSMS']==null ? '' :json['lastSMS'];
    isLateMark = json['IsLateMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = '0';
    data['StudentID'] = this.studentID;
    data['StudentName'] = this.studentName;
    data['IsPresent'] = this.isPresent;
    data['IsSMSSent'] = this.isSMSSent;
    data['ParentID'] = this.parentID;
    data['ParentName'] = this.parentName;
    data['Phone1'] = this.phone1;
    data['Phone2'] = this.phone2;
    data['Date'] = this.date;
    data['Batch_year'] = this.batchYear;
    data['lastSMS'] = this.lastSMS;
    data['IsLateMark'] = this.isLateMark;
    return data;
  }
}