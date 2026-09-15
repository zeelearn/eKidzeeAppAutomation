import 'dart:convert';

import '../../../../globals.dart';
import '../../../response/pentemind/dailyactivity/student_list.dart';

class UpdateDailyWorkbookRequest {
  UpdateDailyWorkbookRequest({
    required this.LogBookID,
    required this.UserId,
    required this.ProgramID,
    required this.InputDate,
    required this.InputData,
  });
  late final String LogBookID;
  late final String UserId;
  late final String ProgramID;
  late final String InputDate;
  late final List<DAStudentInfo> InputData;

  UpdateDailyWorkbookRequest.fromJson(Map<String, dynamic> json){
    LogBookID = json['LogBookID'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    InputDate = json['InputDate'];
    InputData = List.from(json['InputData']).map((e)=>DAStudentInfo.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'LogBookID': this.LogBookID,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'InputDate': this.InputDate,
      'InputData': InputData.map((e)=>e.toJson()).toList(),
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }


}