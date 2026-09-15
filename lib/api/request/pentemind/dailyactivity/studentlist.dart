import 'dart:convert';

import '../../../../globals.dart';

class DailyActivityStudListRequest {
  DailyActivityStudListRequest({
    required this.UserID,
    required this.ProgramId,
    required this.LogBookID,
    required this.D,
    required this.DWSType,
  });
  late final String UserID;
  late final String ProgramId;
  late final String LogBookID;
  late final int D;
  late final String DWSType;

  DailyActivityStudListRequest.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramId = json['Program_Id'];
    LogBookID = json['LogBookID'];
    D = json['D'];
    DWSType = json['DWSType'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_Id': this.ProgramId,
      'D': this.D,
      'LogBookID': this.LogBookID,
      'DWSType': this.DWSType,
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }

}