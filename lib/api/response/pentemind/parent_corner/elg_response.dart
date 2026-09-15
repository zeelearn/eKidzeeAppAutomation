import 'dart:convert';

import '../../../../globals.dart';

class ElgResponse {
  ElgResponse({
    required this.success,
    required this.elgList,
  });
  late final int success;
  late final List<ElgModel> elgList;

  ElgResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    elgList = List.from(json['data']).map((e)=>ElgModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = elgList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ElgModel {
  ElgModel({
    required this.Title,
    required this.ImgName,
    required this.ActivityText,
    required this.D,
    required this.ND,
    required this.TransType,
    required this.PCID,
  });
  late final String Title;
  late final String ImgName;
  late final String ActivityText;
  late  int D;
  late final int ND;
  late final String TransType;
  late final String PCID;

  ElgModel.fromJson(Map<String, dynamic> json){
    Title = convertStringJson(json, 'Title');//json['Title']  ?? '';
    ImgName = convertStringJson(json, 'ImgName');//json['ImgName'] ?? '';
    ActivityText = convertStringJson(json, 'ActivityText');//json['ActivityText'] ?? '';
    D =  convertintJson(json, 'D');//json['D'] ?? 0;
    ND = convertintJson(json, 'ND');//json.containsKey('ND') ? json['ND'] ?? 0 : 0;
    TransType = convertStringJson(json, 'TransType');//json['TransType'] ?? '';
    PCID = convertStringJson(json, 'PCID');//json['PCID'] ?? '';
  }

  toJson() {
    return jsonEncode({
      'Title': this.Title,
      'ImgName': this.ImgName,
      'D': this.D,
      /*'ActivityText': this.ActivityText,*/
      'ND': this.ND,
      'TransType': this.TransType,
      'PCID': this.PCID,
    });
  }
}