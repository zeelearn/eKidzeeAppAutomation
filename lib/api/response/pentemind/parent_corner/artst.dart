import '../../../../globals.dart';

class ArtsyResponse {
  ArtsyResponse({
    required this.success,
    required this.artsyList,
  });
  late final int success;
  late final List<ArtsyModel> artsyList;

  ArtsyResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    artsyList = List.from(json['data']).map((e)=>ArtsyModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = artsyList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ArtsyModel {
  ArtsyModel({
    required this.Title,
    required this.MediaUrl,
    required this.ParentMediaUrl,
    required this.ActivityText,
    required this.D,
    required this.ND,
    required this.TransType,
    required this.PCID,
    required this.FeeType,
  });
  late final String Title;
  late final String MediaUrl;
  String ParentMediaUrl='';
  late final String ActivityText;
  late final int D;
  late final int ND;
  late final String TransType;
  late final String PCID;
  late final String FeeType;

  ArtsyModel.fromJson(Map<String, dynamic> json){
    Title = convertStringJson(json, 'Title');//json['Title'] ?? '';
    MediaUrl = convertStringJson(json, 'MediaUrl');//json['MediaUrl'] ?? '';
    ParentMediaUrl = convertStringJson(json, 'ParentMediaUrl');//json['ParentMediaUrl'] ?? '';
    ActivityText = convertStringJson(json, 'ActivityText');//json['ActivityText'] ?? '';
    D =  convertintJson(json, 'D');//json['D'] ?? 0;
    ND =  convertintJson(json, 'ND');//json['ND'] ?? 0;
    TransType = convertStringJson(json, 'TransType');//json['TransType'] ?? '';
    PCID = convertStringJson(json, 'PCID');//json['PCID'] ?? '';
    FeeType =  convertStringJson(json, 'Fee_Type');//json['Fee_Type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Title'] = Title;
    _data['MediaUrl'] = MediaUrl;
    _data['ParentMediaUrl'] = ParentMediaUrl;
    _data['ActivityText'] = ActivityText;
    _data['D'] = D;
    _data['ND'] = ND;
    _data['TransType'] = TransType;
    _data['PCID'] = PCID;
    _data['Fee_Type'] = FeeType;
    return _data;
  }
}