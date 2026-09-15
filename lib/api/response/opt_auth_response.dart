class OTPAuthResponse{
  OTPAuthResponse({
    required this.Msg,
    required this.IsReset,
    required this.IsValid,
    required this.IsOTP,
  });
  late final String Msg;
  late final bool IsReset;
  late final bool IsValid;
  late final bool IsOTP;


  OTPAuthResponse.fromJson(Map<String, dynamic> json){
    Msg = json['Msg'];
    IsReset = json['IsReset'];
    IsValid = json['IsValid'];
    IsOTP = json['IsOTP'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Msg'] = Msg;
    _data['IsReset'] = IsReset;
    _data['IsValid'] = IsValid;
    _data['IsOTP'] = IsOTP;

    return _data;
  }
}