
class LoginFailuarResponse {
  LoginFailuarResponse({
    required this.root,
  });
  late final Root root;

  LoginFailuarResponse.fromJson(Map<String, dynamic> json){
    root = Root.fromJson(json['root']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['root'] = root.toJson();
    return _data;
  }
}

class Root {
  Root({
    required this.subroot,
  });
  late final Subroot subroot;

  Root.fromJson(Map<String, dynamic> json){
    subroot = Subroot.fromJson(json['subroot']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['subroot'] = subroot.toJson();
    return _data;
  }
}

class Subroot {
  Subroot({
    required this.UserDetails,
    this.UserType,
  });
  late final UserDetail UserDetails;
  late final Null UserType;

  Subroot.fromJson(Map<String, dynamic> json){
    UserDetails = UserDetail.fromJson(json['UserDetails']);
    UserType = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['UserDetails'] = UserDetails.toJson();
    _data['UserType'] = UserType;
    return _data;
  }
}

class UserDetail {
  UserDetail({
    required this.Msg,
    required this.IsReset,
    required this.IsValid,
    required this.IsOTP,
    required this.IsAuthUser,
  });
  late final String Msg;
  late final String IsReset;
  late final String IsValid;
  late final String IsOTP;
  late final String IsAuthUser;

  UserDetail.fromJson(Map<String, dynamic> json){
    Msg = json['Msg'];
    IsReset = json['IsReset'];
    IsValid = json['IsValid'];
    IsOTP = json['IsOTP'];
    IsAuthUser = json['IsAuthUser'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Msg'] = Msg;
    _data['IsReset'] = IsReset;
    _data['IsValid'] = IsValid;
    _data['IsOTP'] = IsOTP;
    _data['IsAuthUser'] = IsAuthUser;
    return _data;
  }
}