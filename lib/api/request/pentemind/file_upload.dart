import 'dart:convert';

class FileUploadModel {
  FileUploadModel({
    required this.mTaskId,
    required this.path,
    required this.userId,
    required this.request,
  });
  late final String path;
  late final String mTaskId;
  late final String userId;
  late final dynamic request;

  FileUploadModel.fromJson(Map<String, dynamic> json){
    path = json['path'];
    mTaskId = json['mTaskId'] ?? '';
    userId = json['userId'] ?? '';
    request = json['request'] ?? '';

  }

  toJson() {
    return jsonEncode({
      'path': this.path,
      'mTaskId': this.mTaskId,
      'userId': this.userId,
      'request': this.request,
    });
  }

}