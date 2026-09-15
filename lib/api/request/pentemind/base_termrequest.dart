import 'dart:convert';

class BasePentemindTermRequest {
  late int Program_ID;
  late String userId;
  late String term;


  BasePentemindTermRequest({required this.Program_ID,
    required this.userId,required this.term});

  BasePentemindTermRequest.fromJson(Map<String, dynamic> json) {
    Program_ID = json['Program_ID'];
    userId = json['User_ID'];
    term = json['Term'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.Program_ID,
      'User_ID': this.userId,
      'Term': this.term,
    });
  }

}

