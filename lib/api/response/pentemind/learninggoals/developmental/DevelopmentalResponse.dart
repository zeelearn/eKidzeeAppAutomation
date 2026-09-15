import '../../../../../globals.dart';

class DevelopmentalResponse {
  DevelopmentalResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final DevelopmentalModel data;

  DevelopmentalResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = DevelopmentalModel.fromJson(json['data']);
  }

  /*Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }*/
}

class DevelopmentalModel {
  DevelopmentalModel({
    required this.LogBookCompleted,
    required this.CName,
  });
  late final bool LogBookCompleted;
  late final List<CNameModel> CName;

  DevelopmentalModel.fromJson(Map<String, dynamic> json){
    LogBookCompleted = json['LogBookCompleted'];
    CName = List.from(json['CName']).map((e)=>CNameModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['LogBookCompleted'] = LogBookCompleted;
    _data['CName'] = CName.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CNameModel {
  CNameModel({
    required this.cName,
  });
  late final String cName;

  CNameModel.fromJson(Map<String, dynamic> json){
    cName = convertStringJson(json, 'CName');//json['CName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CName'] = cName;
    return _data;
  }
}