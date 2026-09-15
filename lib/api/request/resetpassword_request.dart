import 'dart:convert';

class ResetPasswordRequest{
  late final String userName;
  late final String oldPassword;
  late final String newPassword;
  late final String userType;


  ResetPasswordRequest({
    required this.userName,
    required this.oldPassword,
    required this.newPassword,
    required this.userType,
  });

  ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    userName = json['Username'];
    oldPassword = json['OldPassword'];
    newPassword = json['newPassword'];
    userType = json['userType'];
  }

  toJson() {
    return jsonEncode({
      'Username': this.userName,
      'OldPassword': this.oldPassword,
      'newPassword': this.newPassword,
      'userType': this.userType,
    });
  }

}