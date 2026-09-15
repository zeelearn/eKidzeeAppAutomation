import 'dart:convert';
import 'dart:io';

class ApproveInductionRequestModel {
  int Franchisee_User_Id;
  int UserId;
  int Induction_Id;

  ApproveInductionRequestModel(
      {required this.Franchisee_User_Id,
        required this.UserId,
        required this.Induction_Id,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Franchisee_User_Id': Franchisee_User_Id,
      'UserId': UserId,
      'Induction_Id': Induction_Id,
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'Franchisee_User_Id': Franchisee_User_Id,
      'UserId': UserId,
      'Induction_Id': Induction_Id,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}