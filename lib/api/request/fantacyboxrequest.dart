import 'dart:convert';

class FantacyBoxRequest {
  FantacyBoxRequest({
    required this.userType,
    required this.userId,
    required this.classes,
  });
  late final String userType;
  late final int userId;
  late final List<FantacyBoxClasses> classes;

  FantacyBoxRequest.fromJson(Map<String, dynamic> json){
    userType = json['userType'];
    userId = json['userId'];
    classes = List.from(json['classes']).map((e)=>FantacyBoxClasses.fromJson(e)).toList();
  }


  toJson() {
    return jsonEncode({
      'userType': this.userType,
      'userId': this.userId,
      'classes': this.classes.map((e)=>e.toJson()).toList()
    });
  }

}

class FantacyBoxClasses {
  FantacyBoxClasses({
    required this.className,
    required this.culminations,
  });
  late final String className;
  late final List<Culminations> culminations;

  FantacyBoxClasses.fromJson(Map<String, dynamic> json){
    className = json['className'];
    culminations = List.from(json['culminations']).map((e)=>Culminations.fromJson(e)).toList();
  }

  getClassName(){
    return this.className.replaceAll(" ", "");
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['className'] = className;
    _data['culminations'] = culminations.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Culminations {
  Culminations({
    required this.culmination,
    required this.status,
  });
  late final String culmination;
  late int status;

  Culminations.fromJson(Map<String, dynamic> json){
    culmination = json['culmination'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['culmination'] = culmination;
    _data['status'] = status;
    return _data;
  }
}