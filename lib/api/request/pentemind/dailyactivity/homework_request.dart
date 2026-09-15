import 'dart:convert';

import '../../../../globals.dart';

class GetHomeworkRequest {
  GetHomeworkRequest({
    required this.ProgramID,
    required this.UserID,
    required this.TransType,
  });
  late final String ProgramID;
  late final String UserID;
  late final String TransType;

  GetHomeworkRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    UserID = json['User_ID'];
    TransType = json['TransType'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'User_ID': this.UserID,
      'TransType': this.TransType,
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

}