import 'dart:convert' show jsonEncode;

class KesSimpleRequest {
  String? username;
  int? sectionId;

  KesSimpleRequest({this.username, this.sectionId});

  KesSimpleRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    sectionId = json['section_id'];
  }
  toJson(){
    return jsonEncode( {
      'username': this.username,
      'section_id': this.sectionId
    });
  }

  toMLZSJson(){
    return jsonEncode( {
      'userId': this.username,
      'section_id': this.sectionId
    });
  }

}