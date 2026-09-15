import 'dart:convert';
import 'dart:io';

class InductionStatusRequest {
  String UserId;
  int Induction_Id;

  InductionStatusRequest(
      {required this.UserId,
        required this.Induction_Id,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'UserId': UserId,
      'Induction_Id': Induction_Id,
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'UserId': UserId,
      'Induction_Id': Induction_Id,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}