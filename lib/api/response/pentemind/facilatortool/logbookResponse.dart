import 'dart:convert';

import '../../../../globals.dart';

class LogbookResponse {
  LogbookResponse({
    required this.success,
    required this.logbookModel,
  });
  late final int success;
  late List<LogbookModel> logbookModel;

  LogbookResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    logbookModel = List.from(json['data']).map((e)=>LogbookModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = logbookModel.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class LogbookModel {
  LogbookModel({
    required this.CName,
    required this.SessionName,
    required this.Topic,
    required this.BroadFlowActivity,
    required this.KitMaterial,
    required this.OtherMaterial,
    required this.LearningOutcome,
    required this.Observations,
    required this.Worksheet,
    required this.StatusCode,
    required this.Remarks,
    required this.LogBookID,
  });
  late final String CName;
  late final String SessionName;
  late final String Topic;
  late final String BroadFlowActivity;
  late final String KitMaterial;
  late final String OtherMaterial;
  late final String LearningOutcome;
  late final String Observations;
  late final String Worksheet;
  late String StatusCode;
  late String? Remarks;
  late final String LogBookID;

  LogbookModel.fromJson(Map<String, dynamic> json){
    CName = convertStringJson(json, 'CName');//json['CName'];
    SessionName = convertStringJson(json, 'SessionName');//json['SessionName'];
    Topic = convertStringJson(json, 'Topic');//json['Topic'];
    BroadFlowActivity = convertStringJson(json, 'BroadFlowActivity');//json['BroadFlowActivity'];
    KitMaterial = convertStringJson(json, 'Kit_Material');//json['Kit_Material'];
    OtherMaterial = convertStringJson(json, 'Other_Material');//json['Other_Material'];
    LearningOutcome = convertStringJson(json, 'LearningOutcome');//json['LearningOutcome'];
    Observations = convertStringJson(json, 'Observations');//json['Observations'];
    Worksheet = convertStringJson(json, 'Worksheet');//json['Worksheet'];
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'];
    Remarks = convertStringJson(json, 'Remarks');//json['Remarks'];
    LogBookID = convertStringJson(json, 'LogBookID');//json['LogBookID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CName'] = CName;
    _data['SessionName'] = SessionName;
    _data['Topic'] = Topic;
    _data['BroadFlowActivity'] = BroadFlowActivity;
    _data['Kit_Material'] = KitMaterial;
    _data['Other_Material'] = OtherMaterial;
    _data['LearningOutcome'] = LearningOutcome;
    _data['Observations'] = Observations;
    _data['Worksheet'] = Worksheet;
    _data['StatusCode'] = StatusCode;
    _data['Remarks'] = Remarks;
    _data['LogBookID'] = LogBookID;
    return _data;
  }

/*  toJson() {
    return jsonEncode({
      'CName': this.CName,
      'SessionName': this.SessionName,
      'Topic': this.Topic,
      'BroadFlowActivity': this.BroadFlowActivity,
      'Kit_Material': this.KitMaterial,
      'Other_Material': this.OtherMaterial,
      'LearningOutcome': this.LearningOutcome,
      'Observations': this.Observations,
      'Worksheet': this.Worksheet,
      'StatusCode': this.StatusCode,
      'Remarks': this.Remarks,
      'LogBookID': this.LogBookID,
    });

  }*/

  getInsertLogbookBody() {
    return jsonEncode({
      'LogBookID': this.LogBookID,
      'StatusCode': this.StatusCode,
      'Remarks': Remarks,
    });
  }
}