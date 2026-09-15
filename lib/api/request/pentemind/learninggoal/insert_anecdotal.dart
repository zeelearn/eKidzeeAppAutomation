import 'dart:convert';

class InsertAnecdotalRequest {
  InsertAnecdotalRequest({
    required this.TeacherId,
    required this.UserId,
    required this.ProgramID,
    required this.InputType,
    required this.anecdotalModel,
  });
  late final String TeacherId;
  late final String UserId;
  late final int ProgramID;
  late final String InputType;
  late final List<AnecdotalModel> anecdotalModel;

  InsertAnecdotalRequest.fromJson(Map<String, dynamic> json){
    TeacherId = json['TeacherId'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    InputType = json['InputType'];
    anecdotalModel = List.from(json['InputData']).map((e)=>AnecdotalModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.TeacherId,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'InputType': this.InputType,
      'InputData': this.anecdotalModel.map((e)=>e.toJson()).toList(),
    });
  }
}

class AnecdotalModel {
  AnecdotalModel({
    required this.RefKey,
    required this.RefValue,
    required this.StudentID,
    required this.Term,
  });
  String RefKey='';
  String RefValue='';
  int StudentID=0;
  String Term='';

  AnecdotalModel.fromJson(Map<String, dynamic> json){
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
    _data['Term'] = Term;
    return _data;
  }
}