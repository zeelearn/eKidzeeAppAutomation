import 'dart:convert';

class SaveWhatWentWellRequest {
  SaveWhatWentWellRequest({
    required this.TeacherId,
    required this.UserId,
    required this.ProgramID,
    required this.InputType,
    required this.wwwModel,
  });
  late final String TeacherId;
  late final String UserId;
  late final int ProgramID;
  late final String InputType;
  late final List<SaveWhatWentWellModel> wwwModel;

  SaveWhatWentWellRequest.fromJson(Map<String, dynamic> json){
    TeacherId = json['TeacherId'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    InputType = json['InputType'];
    wwwModel = List.from(json['InputData']).map((e)=>SaveWhatWentWellModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.TeacherId,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'InputType': this.InputType,
      'InputData': wwwModel.map((e)=>e.toJson()).toList(),
    });
  }
}

class SaveWhatWentWellModel {
  SaveWhatWentWellModel({
    required this.RefKey,
    required this.RefValue,
    required this.StudentID,
    required this.Remarks,
    required this.Term,
  });
  late final String RefKey;
  String? RefValue;
  String? Remarks;
  late final int StudentID;
  late final String Term;

  SaveWhatWentWellModel.fromJson(Map<String, dynamic> json){
    RefKey = json['RefKey'];
    RefValue = json['RefValue'];
    StudentID = json['StudentID'];
    Term = json['Term'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['RefKey'] = RefKey;
    _data['RefValue'] = RefValue;
    _data['StudentID'] = StudentID;
    _data['Remarks'] = Remarks;
    _data['Term'] = Term;
    return _data;
  }
}