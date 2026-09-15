import '../../../../../globals.dart';

class GetAcademicResponse {
  GetAcademicResponse({
    required this.success,
    required this.learningGoalModel,
  });
  late final int success;
  late final List<AcademicLearningGoalsModel> learningGoalModel;

  GetAcademicResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    learningGoalModel = List.from(json['data']).map((e)=>AcademicLearningGoalsModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = learningGoalModel.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AcademicLearningGoalsModel {
  AcademicLearningGoalsModel({
    required this.ClassName,
    required this.CulminationName,
    required this.C,
    required this.ALGCategoryName,
    required this.LearningGoals,
    required this.ClassId,
    required this.LGAID,
    required this.ALGCategoryID,
    required this.S1,
    required this.S2,
    required this.S3,
  });
  late final String ClassName;
  late final String CulminationName;
  late final int C;
  late final String ALGCategoryName;
  late final String LearningGoals;
  late final int ClassId;
  late final String LGAID;
  late final int ALGCategoryID;
  int S1=0;
  int S2=0;
  int S3=0;

  AcademicLearningGoalsModel.fromJson(Map<String, dynamic> json){
    ClassName = convertStringJson(json, 'Class_Name');//json['Class_Name'] ?? '';
    CulminationName = convertStringJson(json, 'Culmination_Name');//json['Culmination_Name'] ?? '';
    C = convertStringJson(json, 'C');//json['C'] ?? '';
    ALGCategoryName = convertStringJson(json, 'ALGCategoryName');//json['ALGCategoryName'] ?? '';
    LearningGoals = convertStringJson(json, 'LearningGoals');//json['LearningGoals'] ?? '';
    ClassId = convertStringJson(json, 'Class_Id');//json['Class_Id'] ?? '';
    LGAID = convertStringJson(json, 'LGAID');//json['LGAID'] ?? '';
    ALGCategoryID = convertStringJson(json, 'ALGCategoryID');//json['ALGCategoryID'] ?? '';
    S1 = convertintJson(json, 'S1');//json['S1'] ?? 0;
    S2 = convertintJson(json, 'S2');//json['S2'] ?? 0;
    S3 = convertintJson(json, 'S3');//json['S3'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Class_Name'] = ClassName;
    _data['Culmination_Name'] = CulminationName;
    _data['C'] = C;
    _data['ALGCategoryName'] = ALGCategoryName;
    _data['LearningGoals'] = LearningGoals;
    _data['Class_Id'] = ClassId;
    _data['LGAID'] = LGAID;
    _data['ALGCategoryID'] = ALGCategoryID;
    _data['S1'] = S1;
    _data['S2'] = S2;
    _data['S3'] = S3;
    return _data;
  }
}