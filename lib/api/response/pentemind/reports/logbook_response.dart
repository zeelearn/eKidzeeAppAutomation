import '../../../../globals.dart';

class LogbookReportResponse {
  LogbookReportResponse({
    required this.success,
    required this.logbookModelList,
  });
  late final int success;
  late final List<LogbookModel> logbookModelList;

  LogbookReportResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    logbookModelList = List.from(json['data']).map((e)=>LogbookModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = logbookModelList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class LogbookModel {
  LogbookModel({
    required this.TeacherName,
    required this.ClassName,
    required this.CulminationName,
    required this.C,
    required this.W,
    required this.D,
    required this.CName,
    required this.SessionName,
    required this.Topic,
    required this.BroadFlowActivity,
    required this.KitMaterial,
    required this.OtherMaterial,
    required this.LearningOutcome,
    required this.Worksheet,
    required this.Observations,
    required this.StatusCode,
    this.Remarks,
    required this.CreatedDate,
  });
  late final String TeacherName;
  late final String ClassName;
  late final String CulminationName;
  late final int C;
  late final int W;
  late final int D;
  late final String CName;
  late final String SessionName;
  late final String Topic;
  late final String BroadFlowActivity;
  late final String KitMaterial;
  late final String OtherMaterial;
  late final String LearningOutcome;
  late final String Worksheet;
  late final String Observations;
  late final String StatusCode;
  late final String? Remarks;
  late final String CreatedDate;

  LogbookModel.fromJson(Map<String, dynamic> json){
    TeacherName = convertStringJson(json, 'Teacher_Name');//json['Teacher_Name'];
    ClassName = convertStringJson(json, 'Class_Name');//json['Class_Name'];
    CulminationName = convertStringJson(json, 'Culmination_Name');//json['Culmination_Name'];
    C = json['C']!=null ? int.parse(json['C']) ?? 0 : 0;
    W = json['W']!=null ? int.parse(json['W']) ?? 0 : 0;
    D = json['D']!=null ? int.parse(json['D']) ?? 0 : 0;
    CName = convertStringJson(json, 'CName');//json['CName'] ?? '';
    SessionName = convertStringJson(json, 'SessionName');//json['SessionName'] ?? '';
    Topic = convertStringJson(json, 'Topic');//json['Topic'] ?? '';
    BroadFlowActivity = convertStringJson(json, 'BroadFlowActivity');//json['BroadFlowActivity'] ?? '';
    KitMaterial = convertStringJson(json, 'Kit_Material');//json['Kit_Material'] ?? '';
    OtherMaterial = convertStringJson(json, 'Other_Material');//json['Other_Material'] ?? '';
    LearningOutcome = convertStringJson(json, 'LearningOutcome');//json['LearningOutcome'] ?? '';
    Worksheet = convertStringJson(json, 'Worksheet');//json['Worksheet'] ?? '';
    Observations = convertStringJson(json, 'Observations');//json['Observations'] ?? '';
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'] ?? '';
    Remarks = convertStringJson(json, 'Remarks');//json['Remarks'] ?? '';
    CreatedDate = convertStringJson(json, 'Created_Date');//json['Created_Date'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Teacher_Name'] = TeacherName;
    _data['Class_Name'] = ClassName;
    _data['Culmination_Name'] = CulminationName;
    _data['C'] = C;
    _data['W'] = W;
    _data['D'] = D;
    _data['CName'] = CName;
    _data['SessionName'] = SessionName;
    _data['Topic'] = Topic;
    _data['BroadFlowActivity'] = BroadFlowActivity;
    _data['Kit_Material'] = KitMaterial;
    _data['Other_Material'] = OtherMaterial;
    _data['LearningOutcome'] = LearningOutcome;
    _data['Worksheet'] = Worksheet;
    _data['Observations'] = Observations;
    _data['StatusCode'] = StatusCode;
    _data['Remarks'] = Remarks;
    _data['Created_Date'] = CreatedDate;
    return _data;
  }
}