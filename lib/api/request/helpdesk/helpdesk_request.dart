import 'dart:convert';
import 'dart:io';

class HelpdeskRequest {
  int user_id;
  String Answer;
  String search_Text;
  int FeatureQuestionAnswer_Id;
  int PageNo;
  int PageSize;

  HelpdeskRequest(
      {required this.user_id,
        required this.FeatureQuestionAnswer_Id,
        required this.Answer,
        required this.PageNo,
        required this.search_Text,
        required this.PageSize,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': user_id,
      'FeatureQuestionAnswer_Id': FeatureQuestionAnswer_Id,
      'Answer': Answer,
      'PageNo': PageNo,
      'search_Text': search_Text,
      'PageSize': PageSize,
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'user_id': user_id,
      'FeatureQuestionAnswer_Id': FeatureQuestionAnswer_Id,
      'Answer': Answer,
      'PageNo': PageNo,
      'search_Text': search_Text,
      'PageSize': PageSize,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}