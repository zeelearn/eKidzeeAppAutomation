import 'dart:convert';

class ForgotPasswordRequest{
  late final String User_Name;


  ForgotPasswordRequest({
    required this.User_Name,
  });

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    User_Name = json['User_name'];
  }

  toJson() {
    return jsonEncode({
      'User_Name': this.User_Name,
    });
  }

}