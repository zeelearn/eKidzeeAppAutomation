
import 'dart:convert';


class InductionStatusResponse {

  late int ID;
  late String Status;
  late bool Result;
  late String ContentID;
  late String Indent_status;

  InductionStatusResponse(
      {
        required this.ID,
        required this.Status,
        required this.Result,
        required this.ContentID,
        required this.Indent_status,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'ID': ID,
      'Status': Status.trim(),
      'Result': Result,
      'ContentID': ContentID,
      'Indent_status': Indent_status,
    };

    return map;
  }

  InductionStatusResponse.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    Status = json['Status'] ?? '';
    Result = json['Result'] ?? '';
    ContentID = json['ContentID'] ?? '';
    Indent_status = json['Indent_status'] ?? '';

  }


  getJson(){
    return jsonEncode( {
      'ID': ID,
      'Status': Status,
      'Result': Result,
      'ContentID': ContentID,
      'Indent_status': Indent_status,
    });
  }
}