import 'dart:convert';
import 'dart:io';

class HelpdeskLogRequest {
  int HelpdeskID;
  int UserID;


  HelpdeskLogRequest(
      {required this.HelpdeskID,
        required this.UserID

      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'HelpdeskID': HelpdeskID,
      'UserID': UserID
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'HelpdeskID': HelpdeskID,
      'UserID': UserID,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}