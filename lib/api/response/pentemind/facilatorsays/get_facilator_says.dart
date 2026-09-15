import 'package:ekidzee/globals.dart';

class FacilatorSaysResponse {
  FacilatorSaysResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<FacilatorSaysModel> data;

  FacilatorSaysResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>FacilatorSaysModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FacilatorSaysModel {
  FacilatorSaysModel({
    required this.Mind,
    required this.ImgName,
    required this.Observation,
  });
  late final String Mind;
  late final String ImgName;
  late final List<FacilatorObservation> Observation;

  FacilatorSaysModel.fromJson(Map<String, dynamic> json){
    Mind = json['Mind'];
    ImgName = json['Img_name'];
    Observation = List.from(json['Observation']).map((e)=>FacilatorObservation.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Mind'] = Mind;
    _data['Img_name'] = ImgName;
    _data['Observation'] = Observation.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FacilatorObservation {
  FacilatorObservation({
    required this.RefKey,
    required this.RefCount,
    required this.Remarks,
    required this.isChecked,
  });
  late final String RefKey;
  late final int RefCount;
  late final String Remarks;
  bool isChecked=false;

  FacilatorObservation.fromJson(Map<String, dynamic> json){
    RefKey = convertStringJson(json, 'RefKey');// json['RefKey'];
    RefCount = convertStringJson(json, 'RefCount');// json['RefCount'];
    Remarks = convertStringJson(json, 'Remarks');// json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['RefKey'] = RefKey;
    _data['RefCount'] = RefCount;
    _data['Remarks'] = Remarks;
    return _data;
  }
}