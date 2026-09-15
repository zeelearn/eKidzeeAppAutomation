class DiaryResponse{

  late List<DiaryInfo> data;

  DiaryResponse({ required this.data});

  DiaryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DiaryInfo>[];
      json['data'].forEach((v) {
        data.add(DiaryInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class DiaryInfo {
  int diaryID=0;
  String diaryTitle='';
  String diaryMessage='';
  String diaryDate='';
  String diaryCreatedBy='';
  String teacherName='';
  int diaryStudentID=0;
  int studentID=0;
  String studentName='';
  String remark='';
  String remarkDate='';
  bool isRemarked=false;

  DiaryInfo(
      {required this.diaryID,
        required this.diaryTitle,
        required this.diaryMessage,
        required this.diaryDate,
        required this.diaryCreatedBy,
        required this.teacherName,
        required this.diaryStudentID,
        required this.studentID,
        required this.studentName,
        required this.remark,
        required this.remarkDate,
        required this.isRemarked});

  DiaryInfo.fromJson(Map<String, dynamic> json) {
    diaryID = json['Diary_ID'];
    diaryTitle = json['Diary_Title'];
    diaryMessage = json['Diary_Message'];
    diaryDate = json['Diary_Date'];
    diaryCreatedBy = json['Diary_Created_By'];
    teacherName = json['Teacher_Name'];
    diaryStudentID = json['Diary_Student_ID'];
    studentID = json['Student_ID'];
    studentName = json['Student_Name'];
    remark = json['Remark'];
    remarkDate = json['Remark_Date'];
    isRemarked = json['is_Remarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Diary_ID'] = this.diaryID;
    data['Diary_Title'] = this.diaryTitle;
    data['Diary_Message'] = this.diaryMessage;
    data['Diary_Date'] = this.diaryDate;
    data['Diary_Created_By'] = this.diaryCreatedBy;
    data['Teacher_Name'] = this.teacherName;
    data['Diary_Student_ID'] = this.diaryStudentID;
    data['Student_ID'] = this.studentID;
    data['Student_Name'] = this.studentName;
    data['Remark'] = this.remark;
    data['Remark_Date'] = this.remarkDate;
    data['is_Remarked'] = this.isRemarked;
    return data;
  }
}
