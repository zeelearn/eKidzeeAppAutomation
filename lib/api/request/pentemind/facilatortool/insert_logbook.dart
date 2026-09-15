import 'dart:convert';

import '../../../../globals.dart';
import '../../../response/pentemind/facilatortool/logbookResponse.dart';

class InsertLogbookRequest {
  InsertLogbookRequest({
    required this.TeacherId,
    required this.UserId,
    required this.ProgramID,
    required this.CID,
    required this.InputDate,
    required this.remarkModel,
  });
  late final String TeacherId;
  late final String UserId;
  late final String ProgramID;
  late final String CID;
  late final String InputDate;
  late final LogbookModel remarkModel;

  InsertLogbookRequest.fromJson(Map<String, dynamic> json){
    TeacherId = json['TeacherId'];
    UserId = json['UserId'];
    ProgramID = json['Program_ID'];
    CID = json['CID'];
    InputDate = json['InputDate'];
    remarkModel = LogbookModel.fromJson(json['InputData']);
  }

  toJson() {
    return jsonEncode({
      'TeacherId': this.TeacherId,
      'UserId': this.UserId,
      'Program_ID': this.ProgramID,
      'CID': this.CID,
      'InputDate': this.InputDate,
      'InputData': this.remarkModel.toJson(),
      'Business_id': AppFlavor == 'mlzs' ? 2 : 1,
    });
  }
}
