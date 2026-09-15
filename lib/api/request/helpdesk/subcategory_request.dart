import 'dart:convert';
import 'dart:io';

class HelpdeskSubCategoryRequest {
  int ID;


  HelpdeskSubCategoryRequest(
      {required this.ID,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'ID': ID,
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'ID': ID,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}