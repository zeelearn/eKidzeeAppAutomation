class GetDayResponse {
  GetDayResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final GetDayResponseModel data;

  GetDayResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = GetDayResponseModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }
}

class GetDayResponseModel {
  GetDayResponseModel({
    required this.D,
    required this.CName,
    required this.C,
  });
  late int D;
  late String CName;
  late String C;

  getCulmination(){
    try{
      return int.parse(C);
    }catch(e){
      return 1;
    }
  }
  GetDayResponseModel.fromJson(Map<String, dynamic> json){
    D = json['D'] ?? 0;
    CName = json['CName'] ?? '';
    C = json['C'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['D'] = D;
    _data['CName'] = CName;
    _data['C'] = C;
    return _data;
  }
}