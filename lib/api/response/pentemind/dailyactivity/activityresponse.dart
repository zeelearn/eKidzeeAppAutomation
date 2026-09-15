import 'package:ekidzee/globals.dart';

class DailyActivityResponse {
  DailyActivityResponse({
    required this.success,
    required this.activityModel,
  });
  late final int success;
  late final List<DailyActivityModel> activityModel;

  DailyActivityResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    activityModel = List.from(json['data']).map((e)=>DailyActivityModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = activityModel.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DailyActivityModel {
  DailyActivityModel({
    required this.CName,
    required this.LogBookID,
    required this.SessionName,
    required this.LogDate,
    required this.Worksheet,
    required this.C,
    required this.PC,
    required this.NC,
    required this.LogBookStatusCode,
  });
  late final String CName;
  late final String LogBookID;
  late final String SessionName;
  late final String LogDate;
  late final String Worksheet;
  late final int C;
  late final int PC;
  late final int NC;
  late final String LogBookStatusCode;

  DailyActivityModel.fromJson(Map<String, dynamic> json){
    CName = convertStringJson(json, 'CName');//json['CName'];
    LogBookID = convertStringJson(json, 'LogBookID');//json['LogBookID'];
    SessionName = convertStringJson(json, 'SessionName');//json['SessionName'];
    LogDate = convertStringJson(json, 'LogDate');//json['LogDate'];
    Worksheet = convertStringJson(json, 'Worksheet');//json['Worksheet'];
    C = convertintJson(json, 'C');//json['C'] ?? 0;
    PC = convertintJson(json, 'PC');//json['PC'] ?? 0;
    NC = convertintJson(json, 'NC');//json['NC'] ?? 0;
    LogBookStatusCode = convertStringJson(json, 'LogBookStatusCode');//json['LogBookStatusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CName'] = CName;
    _data['LogBookID'] = LogBookID;
    _data['SessionName'] = SessionName;
    _data['LogDate'] = LogDate;
    _data['Worksheet'] = Worksheet;
    _data['C'] = C;
    _data['PC'] = PC;
    _data['NC'] = NC;
    _data['LogBookStatusCode'] = LogBookStatusCode;
    return _data;
  }
}