import 'dart:convert';

class UpdateFcmRequest{
  late final String FCM_Reg_ID;
  late final String User_ID;
  late final String App_Version_Code;
  late final String User_Type;
  late final String login_source;
  late final String mobile_imei;
  late final String DeviceId;
  late final String Ip_Address;
  late final String Buinsess_type;


  UpdateFcmRequest({
    required this.FCM_Reg_ID,
    required this.User_ID,
    required this.App_Version_Code,
    required this.User_Type,
    required this.login_source,
    required this.mobile_imei,
    required this.DeviceId,
    required this.Ip_Address,
    required this.Buinsess_type,
  });

  UpdateFcmRequest.fromJson(Map<String, dynamic> json) {
    FCM_Reg_ID = json['FCM_Reg_ID'];
    User_ID = json['User_ID'];
    User_Type = json['User_Type'];
    App_Version_Code = json['App_Version_Code'];
    login_source = json['login_source'];
    mobile_imei = json['mobile_imei'];
    DeviceId = json['DeviceId'];
    Ip_Address = json['Ip_Address'];
    Buinsess_type = json['Buinsess_type'];
  }

  toJson() {
    return jsonEncode({
      'FCM_Reg_ID': this.FCM_Reg_ID,
      'User_ID': this.User_ID,
      'User_Type': this.User_Type,
      'App_Version_Code': this.App_Version_Code,
      'login_source': this.login_source,
      'mobile_imei': this.mobile_imei,
      'DeviceId': this.DeviceId,
      'Ip_Address': this.Ip_Address,
      'Buinsess_type': this.Buinsess_type,
    });
  }

}