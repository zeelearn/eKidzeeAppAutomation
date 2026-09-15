import 'dart:convert';
import 'dart:io';

class InductionRequestModel {
  String Franchisee_Id;
  String Year;

  InductionRequestModel(
      {required this.Franchisee_Id,
        required this.Year,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Franchisee_Id': Franchisee_Id.trim(),
      'Year': Year.trim(),
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'Franchisee_Id': Franchisee_Id,
      'Year': Year,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}