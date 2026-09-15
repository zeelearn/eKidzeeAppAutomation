class ChangePasswordRequest{
  late final String Username;
  late final String OldPassword;
  late final String newPassword;
  late final String userType;


  ChangePasswordRequest({
    required this.Username,
    required this.OldPassword,
    required this.newPassword,
    required this.userType
  });

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    Username = json['Username'];
    OldPassword = json['OldPassword'];
    newPassword = json['newPassword'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Username'] = Username;
    _data['OldPassword'] = OldPassword;
    _data['newPassword'] = newPassword;
    _data['userType'] = userType;
    return _data;
  }
}