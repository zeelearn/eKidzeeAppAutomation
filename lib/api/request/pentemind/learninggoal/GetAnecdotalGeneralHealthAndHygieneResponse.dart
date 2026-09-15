import 'dart:convert';

class GetAnecdotalGeneralHealthAndHygieneResponse {
  GetAnecdotalGeneralHealthAndHygieneResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<HealthAndHygieneModel> data;

  GetAnecdotalGeneralHealthAndHygieneResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>HealthAndHygieneModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'success': this.success,
      'data': data.map((e)=>e.toJson()).toList(),
    });
  }

  /*Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }*/
}

class HealthAndHygieneModel {
  HealthAndHygieneModel({
    required this.RefKey,
    this.S1Count,
    this.S2Count,
    this.S3Count,
  });
  late final String RefKey;
  late final int? S1Count;
  late final int? S2Count;
  late final int? S3Count;

  HealthAndHygieneModel.fromJson(Map<String, dynamic> json){
    RefKey = json['RefKey'];
    S1Count = json['S1Count'];
    S2Count = json['S2Count'];
    S3Count = json['S3Count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['RefKey'] = RefKey;
    _data['S1Count'] = S1Count;
    _data['S2Count'] = S2Count;
    _data['S3Count'] = S3Count;
    return _data;
  }
}