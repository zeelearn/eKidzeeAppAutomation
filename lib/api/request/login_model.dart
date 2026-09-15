import 'dart:convert';

class LoginResponseModel {
  Root? root;
  LoginResponseModel({this.root});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    root = json['root'] != null ? Root.fromJson(json['root']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (root != null) {
      data['root'] = root!.toJson();
    }
    return data;
  }
}

class Root {
  Subroot? subroot;

  Root({required this.subroot});

  Root.fromJson(Map<String, dynamic> json) {
    subroot =
        (json['subroot'] != null ? Subroot.fromJson(json['subroot']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subroot != null) {
      data['subroot'] = subroot!.toJson();
    }
    return data;
  }
}

class Subroot {
  late UserInfo UserDetails;

  late String UserType;

  Subroot({
    required this.UserDetails,
    required this.UserType,
  });

  Subroot.fromJson(Map<String, dynamic> json) {
    UserDetails = UserInfo.fromJson(json['UserDetails']);
    //MenuList = List.from(json['MenuList']).map((e) => MenuList.fromJson(e)).toList();
    UserType = json['UserType'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['UserDetails'] = UserDetails.toJson();
    //_data['MenuList'] = MenuList.map((e) => e.toJson()).toList();
    data['UserType'] = UserType;
    return data;
  }
}

class UserInfo {
  late final String UserId;
  late final String USERNAME;
  late final String UserType;
  late final String mobileNo;
  //late final Null Remarks;
  late final String CurrentACADYear;
  late final String displayName;
  late final String countryName;
  late final String contactPerson;
  late final String emailId;
  late final String ZoneCode;
  late final String CanEdit;
  late final String StateId;
  late final String FranchiseeType;
  late final String IsExternalUser;
  late final String FranchiseeId;
  late final String lastLogin;
  late final String UserTypeName;
  late final String UID;
  late final String TierType;
  late final String TierName;
  late final String Priority;
  late final String isCenterSetupInProgress;
  late final String RequestedIllumeKit;
  late final String RequestedKGKit;
  late final String IsAgreementExpired;
  late final String Msg;
  late final String IsReset;
  late final String IsValid;
  late final String IsOTP;
  late final String IsAuthUser;

  UserInfo({
    required this.UserId,
    required this.USERNAME,
    required this.UserType,
    required this.mobileNo,
    //this.Remarks,
    required this.CurrentACADYear,
    required this.displayName,
    required this.countryName,
    required this.contactPerson,
    required this.emailId,
    required this.ZoneCode,
    required this.CanEdit,
    required this.StateId,
    required this.FranchiseeType,
    required this.IsExternalUser,
    required this.FranchiseeId,
    required this.lastLogin,
    required this.UserTypeName,
    required this.UID,
    required this.TierType,
    required this.TierName,
    required this.Priority,
    required this.isCenterSetupInProgress,
    required this.RequestedIllumeKit,
    required this.RequestedKGKit,
    required this.IsAgreementExpired,
    required this.Msg,
    required this.IsReset,
    required this.IsValid,
    required this.IsOTP,
    required this.IsAuthUser,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    UserId = json['User_Id'] ?? '';
    USERNAME = json['USER_NAME'] ?? '';
    UserType = json['User_Type'] ?? '';
    mobileNo = json['mobile_no'] ?? '';
    countryName = json.containsKey('Country') ? json['Country'] : '';
    //Remarks = null;
    CurrentACADYear = json['CurrentACADYear'] ?? '';
    displayName = json['display_name'] ?? '';
    contactPerson = json['contact_person'] ?? '';
    emailId = json['email_id'] ?? '';
    ZoneCode = json['Zone_Code'] ?? '';
    CanEdit = json['CanEdit'] ?? '';
    StateId = json['State_id'] ?? '';
    FranchiseeType = json['Franchisee_Type'] ?? '';
    IsExternalUser = json['IsExternalUser'] ?? '';
    FranchiseeId = json['Franchisee_Id'] ?? '';
    lastLogin = json['last_Login'] ?? '';
//     debugPrint('last login  ');
    UserTypeName = json['User_TypeName'] ?? '';
    UID = json['UID'] ?? '';
//     debugPrint('UID response');
    TierType = json['TierType'] ?? '';
    TierName = json['TierName'] ?? '';
    Priority = json['Priority'] ?? '';
    isCenterSetupInProgress = json['Is_Temp_partner'] ?? '';
    RequestedIllumeKit = json['Requested_IllumeKit'] ?? '';
    RequestedKGKit = json['Requested_KGKit'] ?? '';
    IsAgreementExpired = json['Is_agreement_Expired'] ?? '';
    Msg = json['Msg'];
//     debugPrint('message in resopinbser');
    IsReset = json['IsReset'] ?? '';
    IsValid = json['IsValid'] ?? '';
//     debugPrint('IsValid in resopinbser');
    IsOTP = json['IsOTP'] ?? '';
    IsAuthUser = json['IsAuthUser'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['User_Id'] = UserId;
    data['USER_NAME'] = USERNAME;
    data['User_Type'] = UserType;
    data['mobile_no'] = mobileNo;
    data['Country'] = countryName;
    //_data['Remarks'] = Remarks;
    data['CurrentACADYear'] = CurrentACADYear;
    data['display_name'] = displayName;
    data['contact_person'] = contactPerson;
    data['email_id'] = emailId;
    data['Zone_Code'] = ZoneCode;
    data['CanEdit'] = CanEdit;
    data['State_id'] = StateId;
    data['Franchisee_Type'] = FranchiseeType;
    data['IsExternalUser'] = IsExternalUser;
    data['Franchisee_Id'] = FranchiseeId;
    data['last_Login'] = lastLogin;
    data['User_TypeName'] = UserTypeName;
    data['UID'] = UID;
    data['TierType'] = TierType;
    data['TierName'] = TierName;
    data['Priority'] = Priority;
    data['Is_Temp_partner'] = isCenterSetupInProgress;
    data['Requested_IllumeKit'] = RequestedIllumeKit;
    data['Requested_KGKit'] = RequestedKGKit;
    data['Is_agreement_Expired'] = IsAgreementExpired;
    data['Msg'] = Msg;
    data['IsReset'] = IsReset;
    data['IsValid'] = IsValid;
    data['IsOTP'] = IsOTP;
    data['IsAuthUser'] = IsAuthUser;
    return data;
  }
}

class MenuList {
  String mobilemenuID = "";
  String menuName = "";
  String userType = "";

  MenuList(
      {required this.mobilemenuID,
      required this.menuName,
      required this.userType});

  MenuList.fromJson(Map<String, dynamic> json) {
    mobilemenuID = json['mobilemenuID'];
    menuName = json['MenuName'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobilemenuID'] = mobilemenuID;
    data['MenuName'] = menuName;
    data['userType'] = userType;
    return data;
  }
}

class BranchList {
  String? branchId;
  String? branchName;
  BatchList? batchList;

  BranchList({this.branchId, this.branchName, this.batchList});

  BranchList.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    batchList = json['batch_list'] != null
        ? BatchList.fromJson(json['batch_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    if (batchList != null) {
      data['batch_list'] = batchList!.toJson();
    }
    return data;
  }
}

class BatchList {
  String? batchName;
  String? batchId;

  BatchList({this.batchName, this.batchId});

  BatchList.fromJson(Map<String, dynamic> json) {
    batchName = json['batch_name'];
    batchId = json['batch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['batch_name'] = batchName;
    data['batch_id'] = batchId;
    return data;
  }
}

class LoginRequestModel {
  String User_Name;
  String User_Password;
  String Device_id;
  String Otp;

  LoginRequestModel(
      {required this.User_Name,
      required this.User_Password,
      required this.Device_id,
      required this.Otp});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'User_Name': User_Name.trim(),
      'User_Password': User_Password.trim(),
      'Device_id': Device_id.trim(),
      'Otp': Otp.trim(),
    };

    return map;
  }

  toJson() {
    return jsonEncode({
      "User_Name": User_Name.trim(),
      "User_Password": User_Password.trim(),
      "Device_id": Device_id.trim(),
      "Otp": Otp.trim(),
      "Business_Id": 1
    });
  }
}

class TokenResponseModel {
  late final String token;
  late final String Status;

  TokenResponseModel({required this.token, required this.Status});

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      token: json["Message"] ?? "",
      Status: json["Status"] ?? "",
    );
  }
}
