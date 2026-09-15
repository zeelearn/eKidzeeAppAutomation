class OtpRequest{
  late final String Mode;
  late final String MobileNo;


  OtpRequest({
    required this.Mode,
    required this.MobileNo,
  });

  OtpRequest.fromJson(Map<String, dynamic> json) {
    Mode = json['Mode'];
    MobileNo = json['MobileNo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Mode'] = Mode;
    _data['MobileNo'] = MobileNo;
    return _data;
  }
}