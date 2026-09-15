import '../../../../../globals.dart';

class GetLearningGoalDevelopmentalResponse {
  GetLearningGoalDevelopmentalResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final Data data;

  GetLearningGoalDevelopmentalResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.LogBookCompleted,
    required this.CName,
    required this.learningGoal,
  });
  late final bool LogBookCompleted;
  late final List<CulminationModel> CName;
  late final List<LearningGoal> learningGoal;

  Data.fromJson(Map<String, dynamic> json){
    LogBookCompleted = json['LogBookCompleted'];
    CName = json.containsKey('CName') ? List.from(json['CName']).map((e)=>CulminationModel.fromJson(e)).toList() : [];
    try {
      learningGoal = json.containsKey('LG') ?
          List.from(json['LG']).map((e) => LearningGoal.fromJson(e)).toList() : [];
    }catch(e){
      learningGoal = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['LogBookCompleted'] = LogBookCompleted;
    _data['CName'] = CName.map((e)=>e.toJson()).toList();
    _data['LG'] = learningGoal.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CulminationModel {
  CulminationModel({
    required this.CName,
  });
  late final String CName;

  CulminationModel.fromJson(Map<String, dynamic> json){
    CName = convertStringJson(json, 'CName');//json['CName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CName'] = CName;
    return _data;
  }
}

class LearningGoal {
  LearningGoal({
    required this.D,
    required this.LGDID,
    required this.SessionID,
    required this.SessionName,
    required this.DomainID,
    required this.DomainName,
    required this.SkillID,
    required this.SkillName,
    required this.LearningGoals,
    required this.ObservationType,
    required this.tlg,
  });
  late  int D;
  late final int LGDID;
  late final int SessionID;
  late final String SessionName;
  late final int DomainID;
  late final String DomainName;
  late final int SkillID;
  late final String SkillName;
  late final String LearningGoals;
  late final String ObservationType;
  late final List<Tlg> tlg;

  bool isContains(String search){
    if(SessionName.toLowerCase().contains(search.toLowerCase()) || DomainName.toLowerCase().contains(search.toLowerCase()) ||
      SkillName.toLowerCase().contains(search.toLowerCase()) || ObservationType.toLowerCase().contains(search.toLowerCase()) || LearningGoals.toLowerCase().contains(search.toLowerCase())){
      return true;
    }
    return false;
  }

  LearningGoal.fromJson(Map<String, dynamic> json){
    D = convertintJson(json, 'D');//json['D'] ?? '';
    LGDID = convertintJson(json, 'LGDID');//json['LGDID'] ?? '';
    SessionID = convertintJson(json, 'SessionID');//json['SessionID'] ?? '';
    SessionName = convertStringJson(json, 'SessionName');//json['SessionName'] ?? '';
    DomainID = convertintJson(json, 'DomainID');//json['DomainID'] ?? '';
    DomainName = convertStringJson(json, 'DomainName');//json['DomainName'] ?? '';
    SkillID = convertintJson(json, 'SkillID');//json['SkillID'] ?? '';
    SkillName = convertStringJson(json, 'SkillName');//json['SkillName'] ?? '';
    LearningGoals = convertStringJson(json, 'LearningGoals');//json['LearningGoals'] ?? '';
    ObservationType = convertStringJson(json, 'ObservationType');//json['LearningGoals'] ?? '';
    tlg = List.from(json['tlg']).map((e)=>Tlg.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['D'] = D;
    _data['LGDID'] = LGDID;
    _data['SessionID'] = SessionID;
    _data['SessionName'] = SessionName;
    _data['DomainID'] = DomainID;
    _data['DomainName'] = DomainName;
    _data['SkillID'] = SkillID;
    _data['SkillName'] = SkillName;
    _data['LearningGoals'] = LearningGoals;
    _data['ObservationType'] = ObservationType;
    _data['tlg'] = tlg.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Tlg {
  Tlg({
    required this.P,
    required this.E,
    required this.N,
  });
  late  int P;
  late  int E;
  late  int N;

  Tlg.fromJson(Map<String, dynamic> json){
    P = json['P'] ?? 0;
    E = json['E'] ?? 0;
    N = json['N'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['P'] = P;
    _data['E'] = E;
    _data['N'] = N;
    return _data;
  }
}