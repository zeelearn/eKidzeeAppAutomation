import '../../../../globals.dart';

class GetReportResponse {
  GetReportResponse({
    required this.success,
    required this.reportModelList,
  });
  late final int success;
  late final List<ReportModel> reportModelList;

  GetReportResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    reportModelList = List.from(json['data']).map((e)=>ReportModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = reportModelList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ReportModel {
  ReportModel({
    required this.ClassName,
    required this.CulminationName,
    required this.C,
    required this.W,
    required this.D,
    required this.CName,
    required this.SessionName,
    required this.DomainCode,
    required this.DomainName,
    required this.SkillName,
    required this.LearningGoals,
    required this.TeacherName,
    required this.StudentID,
    required this.StudentName,
    required this.Rating,
    required this.ObservationType,
    required this.OnDay,
  });
  late final String ClassName;
  late final String CulminationName;
  late final int C;
  late final int W;
  late final int D;
  late final String CName;
  late final String SessionName;
  late final String DomainCode;
  late final String DomainName;
  late final String SkillName;
  late final String LearningGoals;
  late final String TeacherName;
  late final String StudentID;
  late final String StudentName;
  late final String Rating;
  late final String ObservationType;
  late final int OnDay;

  ReportModel.fromJson(Map<String, dynamic> json){
    ClassName = convertStringJson(json, 'Class_Name');//json['Class_Name'];
    CulminationName = convertStringJson(json, 'Culmination_Name');//json['Culmination_Name'];
    C = json['C']!=null ? json['C'] is int ? json['C'] : int.parse(json['C']) ?? 0 : 0;
    W = json['W']!=null ? json['W'] is int ? json['W'] : int.parse(json['W']) ?? 0 : 0;
    D = json['D']!=null ? json['D'] is int ? json['D'] : int.parse(json['D']) ?? 0 : 0;
    CName = convertStringJson(json, 'CName');//json['CName'] ?? '';
    SessionName = convertStringJson(json, 'SessionName');//json['SessionName'] ?? '';
    DomainCode = convertStringJson(json, 'DomainCode');//json['DomainCode'] ?? '';
    DomainName = convertStringJson(json, 'DomainName');//json['DomainName'] ?? '';
    SkillName = convertStringJson(json, 'SkillName');//json['SkillName'] ?? '';
    LearningGoals = convertStringJson(json, 'LearningGoals');//json['LearningGoals'] ?? '';
    TeacherName = convertStringJson(json, 'Teacher_Name');//json['Teacher_Name'] ?? '';
    StudentID = convertStringJson(json, 'StudentID');//json['StudentID'] ?? '';
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'] ?? '';
    Rating = convertStringJson(json, 'Rating');//json['Rating'] ?? '';
    ObservationType = convertStringJson(json, 'ObservationType');//json['ObservationType'] ?? '';
    OnDay = convertintJson(json, 'OnDay');//json['OnDay'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Class_Name'] = ClassName;
    _data['Culmination_Name'] = CulminationName;
    _data['C'] = C;
    _data['W'] = W;
    _data['D'] = D;
    _data['CName'] = CName;
    _data['SessionName'] = SessionName;
    _data['DomainCode'] = DomainCode;
    _data['DomainName'] = DomainName;
    _data['SkillName'] = SkillName;
    _data['LearningGoals'] = LearningGoals;
    _data['Teacher_Name'] = TeacherName;
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Rating'] = Rating;
    _data['ObservationType'] = ObservationType;
    _data['OnDay'] = OnDay;
    return _data;
  }
}