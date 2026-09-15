class SecureLoginResponseModel {
  final LoginData? data;
  final String? token;

  SecureLoginResponseModel({this.data, this.token});

  factory SecureLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return SecureLoginResponseModel(
      data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
      token: json["token"] ?? "",
    );
  }
}

class LoginData {
  final String? userId;
  final String? userName;
  final String? userType;
  final String? mobileNo;
  final String? remarks;
  final int? resetPassword;
  final int? currentACADYear;
  final String? displayName;
  final String? contactPerson;
  final String? emailId;
  final String? zoneCode;
  final int? canEdit;
  final int? stateId;
  final String? franchiseeType;
  final String? franchiseeCode;
  final int? isExternalUser;
  final int? franchiseeId;
  final String? lastLogin;
  final String? userTypeName;
  final String? uid;
  final String? tierType;
  final String? tierName;
  final int? priority;
  final int? studentId;
  final String? profileURL;
  final bool? requestedIllumeKit;
  final bool? requestedKGKit;
  final bool? isAgreementExpired;
  final bool? isTempPartner;
  final String? country;
  final String? msg;
  final bool? isReset;
  final bool? isValid;
  final bool? isOTP;
  final bool? isAuthUser;
  final int? statusCode;
  final String? userTypeCode;
  List<ProgramModel>? program;

  LoginData({
    this.userId,
    this.userName,
    this.userType,
    this.mobileNo,
    this.remarks,
    this.resetPassword,
    this.currentACADYear,
    this.displayName,
    this.contactPerson,
    this.emailId,
    this.zoneCode,
    this.canEdit,
    this.stateId,
    this.franchiseeType,
    this.isExternalUser,
    this.franchiseeId,
    this.franchiseeCode,
    this.lastLogin,
    this.userTypeName,
    this.uid,
    this.tierType,
    this.tierName,
    this.studentId,
    this.priority,
    this.requestedIllumeKit,
    this.requestedKGKit,
    this.isAgreementExpired,
    this.isTempPartner,
    this.country,
    this.msg,
    this.isReset,
    this.isValid,
    this.isOTP,
    this.isAuthUser,
    this.statusCode,
    this.userTypeCode,
    this.program,
    this.profileURL
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userId: '${json["userId"]}',
      userName: json["userName"],
      userType: json["userType"],
      mobileNo: json["mobile_no"] ?? "",
      remarks: json["Remarks"],
      resetPassword: json["resetPassword"],
      currentACADYear: json["currentAcadYear"],
      displayName: json["displayName"],
      contactPerson: json["contactPerson"],
      emailId: json["emailId"] ?? "",
      zoneCode: json["zoneCode"],
      canEdit: json["canEdit"],
      stateId: json["stateId"],
      franchiseeType: json["franchiseeType"],
      isExternalUser: json["isExternalUser"],
      franchiseeCode: json['franchiseeCode'],
      franchiseeId: json["franchiseeId"],
      lastLogin: json["lastLogin"] ?? '',
      userTypeName: json["userTypeName"],
      uid: '${json["uId"]}',
      tierType: json["tierType"],
      tierName: json["tierName"],
      priority: json["priority"],
      requestedIllumeKit: json["requestedIllumeKit"],
      requestedKGKit: json["requestedKGKit"],
      isAgreementExpired: json["isAgreementExpired"],
      isTempPartner: json["isTempPartner"],
      studentId : json["studentId"] ?? 0,
      profileURL : json['profileURL'] ?? '',
      country: json["country"],
      msg: json["msg"],
      isReset: json["isReset"],
      isValid: json["isValid"],
      isOTP: json["isOTP"],
      isAuthUser: json["isAuthUser"],
      statusCode: json["statusCode"],
      userTypeCode: json["userType"],
      program: json["Program"] != null
          ? List<ProgramModel>.from(
          json["Program"].map((e) => ProgramModel.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "userType": userType,
      "mobile_no": mobileNo,
      "Remarks": remarks,
      "resetPassword": resetPassword,
      "currentAcadYear": currentACADYear,
      "displayName": displayName,
      "contact_person": contactPerson,
      "email_id": emailId,
      "zoneCode": zoneCode,
      "canEdit": canEdit,
      "stateId": stateId,
      "franchiseeType": franchiseeType,
      "isExternalUser": isExternalUser,
      "franchiseeId": franchiseeId,
      "franchiseeCode" : franchiseeCode,
      "last_Login": lastLogin,
      "userTypeName": userTypeName,
      "uId": uid,
      "tierType": tierType,
      "tierName": tierName,
      "priority": priority,
      "requestedIllumeKit": requestedIllumeKit,
      "requestedKGKit": requestedKGKit,
      "isAgreementExpired": isAgreementExpired,
      "isTempPartner": isTempPartner,
      "country": country,
      "studentId" : studentId,
      "profileURL" : profileURL,
      "msg": msg,
      "isReset": isReset,
      "isValid": isValid,
      "isOTP": isOTP,
      "isAuthUser": isAuthUser,
      "statusCode": statusCode,
      "userType": userTypeCode,
      "Program": program?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProgramModel {
  final String? programName;
  final int? programId;
  final String? className;
  final int? classId;
  final String? feeType;
  final String? term;
  //final int? franchiseeId;
  final String? curriculumType;

  ProgramModel({
    this.programName,
    this.programId,
    this.className,
    this.classId,
    this.feeType,
    this.term,
    //this.franchiseeId,
    this.curriculumType,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      programName: json["programName"],
      programId: json["programId"],
      className: json["className"],
      classId: json["classId"],
      feeType: json["feeType"],
      term: json["term"],
      //franchiseeId: json["franchiseeId"],
      curriculumType: json["curriculumType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "programName": programName,
      "programId": programId,
      "className": className,
      "classId": classId,
      "feeType": feeType,
      "term": term,
      //"franchiseeId": franchiseeId,
      "curriculumType": curriculumType,
    };
  }
}


class SecureLoginFailuarResponse {
  final SecureLoginFailuarData? data;
  final String? token;

  SecureLoginFailuarResponse({this.data, this.token});

  factory SecureLoginFailuarResponse.fromJson(Map<String, dynamic> json) {
    return SecureLoginFailuarResponse(
      data:
      json["data"] != null ? SecureLoginFailuarData.fromJson(json["data"]) : null,
      token: json["token"] ?? "",
    );
  }
}

class SecureLoginFailuarData {
  final String? msg;
  final bool? isReset;
  final bool? isValid;
  final bool? isOTP;
  final bool? isAuthUser;
  final int? statusCode;
  final String? userType;

  SecureLoginFailuarData({
    this.msg,
    this.isReset,
    this.isValid,
    this.isOTP,
    this.isAuthUser,
    this.statusCode,
    this.userType,
  });

  factory SecureLoginFailuarData.fromJson(Map<String, dynamic> json) {
    return SecureLoginFailuarData(
      msg: json["msg"],
      isReset: json["isReset"],
      isValid: json["isValid"],
      isOTP: json["isOTP"],
      isAuthUser: json["isAuthUser"],
      statusCode: json["statusCode"],
      userType: json["userType"],
    );
  }
}
