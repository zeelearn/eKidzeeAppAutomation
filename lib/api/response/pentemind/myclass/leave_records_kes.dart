import '../../../../globals.dart';

class KESLeaveResponse {
  int? success;
  List<KESLeaveResponseData>? data;

  KESLeaveResponse({this.success, this.data});

  KESLeaveResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <KESLeaveResponseData>[];
      json['data'].forEach((v) {
        data!.add(new KESLeaveResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KESLeaveResponseData {
  int? leaveRecordId;
  String? body;
  String? leaveStatus;
  String? createdDate;

  KESLeaveResponseData(
      {this.leaveRecordId, this.body, this.leaveStatus, this.createdDate});

  KESLeaveResponseData.fromJson(Map<String, dynamic> json) {
    leaveRecordId = json['leave_record_id'];
    body = json['body'];
    leaveStatus = json['leave_status'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leave_record_id'] = this.leaveRecordId;
    data['body'] = this.body;
    data['leave_status'] = this.leaveStatus;
    data['created_date'] = this.createdDate;
    return data;
  }
}

class LeaveRecordResponse {
  LeaveRecordResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<LeaveResponseModel> data;

  LeaveRecordResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = List.from(json['data'])
        .map((e) => LeaveResponseModel.fromJson(e))
        .toList();
  }
  LeaveRecordResponse.from1Json(Map<String, dynamic> json) {
    success = json['success'];
    data = [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class LeaveResponseModel {
  LeaveResponseModel({
    required this.Leave,
    required this.Notification,
  });
  late final List<LeaveInfoModel> Leave;
  late final List<LeaveNotificationModel> Notification;

  LeaveResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Leave'))
      Leave = List.from(json['Leave'])
          .map((e) => LeaveInfoModel.fromJson(e))
          .toList();
    else
      Leave = [];
    if (json.containsKey('Notification')) {
      Notification = List.from(json['Notification'])
          .map((e) => LeaveNotificationModel.fromJson(e))
          .toList();
    } else
      Notification = [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Leave'] = Leave.map((e) => e.toJson()).toList();
    _data['Notification'] = Notification.map((e) => e.toJson()).toList();
    return _data;
  }
}

class LeaveInfoModel {
  LeaveInfoModel({
    required this.ID,
    required this.Subject,
    required this.Body,
    required this.Date,
    required this.ApprovalStatus,
  });
  late final int ID;
  late final String Subject;
  late final String Body;
  late final String Date;
  late String ApprovalStatus;

  LeaveInfoModel.fromJson(Map<String, dynamic> json) {
    ID = convertintJson(json, 'ID'); //json['ID'];
    Subject = convertStringJson(json, 'Subject'); //json['Subject'];
    Body = convertStringJson(json, 'Body'); //json['Body'];
    Date = convertStringJson(json, 'created_date'); //json['Date'];
    ApprovalStatus =
        convertStringJson(json, 'ApprovalStatus'); //json['ApprovalStatus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['Subject'] = Subject;
    _data['Body'] = Body;
    _data['Date'] = Date;
    _data['ApprovalStatus'] = ApprovalStatus;
    return _data;
  }
}

class LeaveNotificationModel {
  LeaveNotificationModel({
    required this.Subject,
    required this.Body,
    required this.Date,
  });
  late final String Subject;
  late final String Body;
  late final String Date;

  LeaveNotificationModel.fromJson(Map<String, dynamic> json) {
    Subject = convertStringJson(json, 'Subject'); //json['Subject'];
    Body = convertStringJson(json, 'Body'); //json['Body'];
    Date = convertStringJson(json, 'Date'); //json['Date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Subject'] = Subject;
    _data['Body'] = Body;
    _data['Date'] = Date;
    return _data;
  }
}
