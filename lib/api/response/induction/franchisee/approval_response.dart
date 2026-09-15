
import 'dart:convert';


class InductionApprovalResponse {

  late String Status;
  late String Result;

  InductionApprovalResponse(
      {required this.Status,
        required this.Result,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Status': Status.trim(),
      'Result': Result.trim(),
    };

    return map;
  }

  InductionApprovalResponse.fromJson(Map<String, dynamic> json) {
    //id = json['$id'];
    Status = json['Status'] ?? '';
    Result = json['Result'] ?? '';

  }


  getJson(){
    return jsonEncode( {
      'Status': Status,
      'Result': Result,
    });
  }
}