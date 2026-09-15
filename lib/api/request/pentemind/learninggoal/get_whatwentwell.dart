import 'dart:convert';

class WhatWentWellRequest {
  WhatWentWellRequest({
    required this.ProgramID,
    required this.InputType,
    required this.UserID,
  });
  late final int ProgramID;
  late final String InputType;
  late final String UserID;

  WhatWentWellRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    InputType = json['InputType'];
    UserID = json['User_ID'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'InputType': this.InputType,
      'User_ID': this.UserID,
    });
  }
  
}