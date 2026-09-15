import 'dart:convert';

import '../../../../globals.dart';

class WhatWentWellResponse {
  WhatWentWellResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<WhatWentWellResponseModel> data;

  WhatWentWellResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>WhatWentWellResponseModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class WhatWentWellResponseModel {
  WhatWentWellResponseModel({
    required this.StudentID,
    required this.StudentName,
    required this.whatwentwellModel,
  });
  late final int StudentID;
  late final String StudentName;
  late final String studentprofileURL;
  late final bool iSphoto;
  late final List<WhatWentWellModel> whatwentwellModel;

  WhatWentWellResponseModel.fromJson(Map<String, dynamic> json){
    StudentID = json['StudentID'];
    StudentName = json['Student_Name'];
    studentprofileURL = convertStringJson(json, 'studentprofileURL');
    iSphoto = json.containsKey('Isphoto') ? json['Isphoto'] : false;
    whatwentwellModel = List.from(json['WWW']).map((e)=>WhatWentWellModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'StudentID': this.StudentID,
      'Student_Name': this.StudentName,
      'studentprofileURL': this.studentprofileURL,
      'Isphoto': this.iSphoto,
      'WWW': whatwentwellModel.map((e)=>e.toJson()).toList(),
    });
  }
}

class WhatWentWellModel {
  WhatWentWellModel({
    required this.RefKey,
    required this.Term,
    required this.RefValue,
  });
  late final String RefKey;
  late final String Term;
  late final String RefValue;

  WhatWentWellModel.fromJson(Map<String, dynamic> json){
    RefKey =  convertStringJson(json, 'RefKey');//json['RefKey'];
    Term =  convertStringJson(json, 'Term');//json['Term'];
    RefValue =  convertStringJson(json, 'RefValue');//json['RefValue'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['RefKey'] = RefKey;
    _data['Term'] = Term;
    _data['RefValue'] = RefValue;
    return _data;
  }
}