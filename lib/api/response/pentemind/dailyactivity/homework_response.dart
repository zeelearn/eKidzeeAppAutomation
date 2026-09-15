import '../../../../globals.dart';

class GetHomeworkResponse {
  GetHomeworkResponse({
    required this.success,
    required this.homeWorkList,
  });
  late final int success;
  late final List<HomeWorkModel> homeWorkList;

  GetHomeworkResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    homeWorkList = List.from(json['data']).map((e)=>HomeWorkModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = homeWorkList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class HomeWorkModel {
  HomeWorkModel({
    required this.HomeworkID,
    required this.CName,
    required this.AssignedDate,
    required this.Worksheet,
    required this.solution,
    required this.notification,
    required this.C,
    required this.PC,
    required this.NC,
  });
  late final String HomeworkID;
  late final String CName;
  late final String AssignedDate;
  late final String Worksheet;
  late final String solution;
  late final String notification;
  late final int C;
  late final int PC;
  late final int NC;

  HomeWorkModel.fromJson(Map<String, dynamic> json){
    HomeworkID = convertStringJson(json, 'HomeworkID');//json['HomeworkID'];
    CName = convertStringJson(json, 'CName');//json['CName'];
    AssignedDate = convertStringJson(json, 'AssignedDate');//json['AssignedDate'];
    Worksheet = convertStringJson(json, 'Worksheet');//json['Worksheet'];
    solution = convertStringJson(json, 'solution');//json['solution'];
    notification = convertStringJson(json, 'notification');//json['notification'] ?? '';
    C =  convertintJson(json, 'C');//json['C'] ?? 0;
    PC =  convertintJson(json, 'PC');//json['PC'] ?? 0;
    NC =  convertintJson(json, 'NC');//json['NC'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['HomeworkID'] = HomeworkID;
    _data['CName'] = CName;
    _data['AssignedDate'] = AssignedDate;
    _data['Worksheet'] = Worksheet;
    _data['solution'] = solution;
    _data['notification'] = notification;
    _data['C'] = C;
    _data['PC'] = PC;
    _data['NC'] = NC;
    return _data;
  }
}