import '../../../../globals.dart';

class LessonPlanResponse {
  LessonPlanResponse({
    required this.success,
    required this.lessonPlanModelList,
  });
  late final int success;
  late final List<LessonPlanModel> lessonPlanModelList;

  LessonPlanResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    lessonPlanModelList = List.from(json['data']).map((e)=>LessonPlanModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = lessonPlanModelList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class LessonPlanModel {
  LessonPlanModel({
    required this.CName,
    required this.ContentDescription,
    required this.WebUrl,
    required this.MediaType,
    required this.AppUrl,
    required this.Urlkey,
    required this.DecryptKey,
    required this.RefKey,
    required this.RefValue,
  });
  late final String CName;
  late final String ContentDescription;
  late final String WebUrl;
  late final String MediaType;
  late final String AppUrl;
  late final String Urlkey;
  late final String DecryptKey;
  late final String RefKey;
  late final String RefValue;

  LessonPlanModel.fromJson(Map<String, dynamic> json){
    CName = convertStringJson(json, 'CName');//json['CName'] ?? '';
    ContentDescription = convertStringJson(json, 'ContentDescription');//json['ContentDescription'] ?? '';
    WebUrl = convertStringJson(json, 'WebUrl');//json['WebUrl'] ?? '';
    MediaType = convertStringJson(json, 'MediaType');//json['MediaType'] ?? '';
    AppUrl = convertStringJson(json, 'AppUrl');//json['AppUrl'] ?? '';
    Urlkey =convertStringJson(json, 'Urlkey');//json['Urlkey'] ?? '';
    DecryptKey = convertStringJson(json, 'DecryptKey');//json['DecryptKey'] ?? '';
    RefKey = convertStringJson(json, 'RefKey');//json['RefKey'] ?? '';
    RefValue = convertStringJson(json, 'RefValue');//json['RefValue'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CName'] = CName ?? '';
    _data['ContentDescription'] = ContentDescription ?? '';
    _data['WebUrl'] = WebUrl ?? '';
    _data['MediaType'] = MediaType ?? '';
    _data['AppUrl'] = AppUrl ?? '';
    _data['Urlkey'] = Urlkey ?? '';
    _data['Decrypt_Key'] = DecryptKey ?? '';
    _data['RefKey'] = RefKey ?? '';
    _data['RefValue'] = RefValue ?? '';
    return _data;
  }
}