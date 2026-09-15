class OtpAuthRequest{
  late final String User_Name;
  late final String Otp;


  OtpAuthRequest({
    required this.User_Name,
    required this.Otp,
  });

  OtpAuthRequest.fromJson(Map<String, dynamic> json) {
    User_Name = json['User_Name'];
    Otp = json['Otp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['User_Name'] = User_Name;
    _data['Otp'] = Otp;
    return _data;
  }
}