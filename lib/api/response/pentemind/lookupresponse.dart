class LookUpResponse {
  LookUpResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<Data> data;

  LookUpResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.LookupID,
    required this.LookupType,
    required this.LookupCode,
    required this.LookupName,
  });
  late final int LookupID;
  late final String LookupType;
  late final String LookupCode;
  late final String LookupName;

  Data.fromJson(Map<String, dynamic> json){
    LookupID = json['LookupID'];
    LookupType = json['LookupType'];
    LookupCode = json['LookupCode'];
    LookupName = json['LookupName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['LookupID'] = LookupID;
    _data['LookupType'] = LookupType;
    _data['LookupCode'] = LookupCode;
    _data['LookupName'] = LookupName;
    return _data;
  }
}