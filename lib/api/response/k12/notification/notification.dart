class GetNotificationResponse {
  int? success;
  List<Data>? data;

  GetNotificationResponse({this.success, this.data});

  GetNotificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  List<StudentList>? studentList;
  List<NotificationList>? notificationList;

  Data({this.studentList, this.notificationList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['student_list'] != null) {
      studentList = <StudentList>[];
      json['student_list'].forEach((v) {
        studentList!.add(new StudentList.fromJson(v));
      });
    }
    if (json['notification_list'] != null) {
      notificationList = <NotificationList>[];
      json['notification_list'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentList != null) {
      data['student_list'] = this.studentList!.map((v) => v.toJson()).toList();
    }
    if (this.notificationList != null) {
      data['notification_list'] =
          this.notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentList {
  int? studentId;
  String? studentName;
  int? userRoleId;
  int? sectionId;
  bool isPresent = false;
  String? userType;

  StudentList(
      {this.studentId,
      this.studentName,
      this.userRoleId,
      this.sectionId,
      isPresent,
      this.userType});

  StudentList.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    userRoleId = json['user_role_id'];
    sectionId = json['section_id'];
    userType = json['User_Type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.studentId;
    //data['student_name'] = this.studentName;
    data['user_role_id'] = this.userRoleId;
    data['section_id'] = this.sectionId;

    return data;
  }

  Map<String, dynamic> toMlzsJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.studentId;
    //data['student_name'] = this.studentName;
    data['user_type'] = this.userType;
    data['section_id'] = this.sectionId;

    return data;
  }
}

class NotificationList {
  int? nId;
  String? subject;
  String? msgType;
  String? msgBody;
  String? requestType;
  String? publishDate;
  String? approvalStatus;
  String? attachment;
  List<ToList>? toList;

  NotificationList(
      {this.nId,
      this.subject,
      this.msgType,
      this.msgBody,
      this.requestType,
      this.publishDate,
      this.approvalStatus,
      this.attachment,
      this.toList});

  NotificationList.fromJson(Map<String, dynamic> json) {
    nId = json['n_id'];
    subject = json['subject'];
    msgType = json['msg_type'];
    msgBody = json['msg_body'];
    requestType = json['request_type'];
    publishDate = json.containsKey('publish_date') ? json['publish_date'] : '';
    approvalStatus =
        json.containsKey('approval_status') ? json['approval_status'] : '';
    attachment =
        json.containsKey('attachment_url') ? json['attachment_url'] : '';
    if (json['to_list'] != null) {
      toList = <ToList>[];
      json['to_list'].forEach((v) {
        toList!.add(new ToList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n_id'] = this.nId;
    data['subject'] = this.subject;
    data['msg_type'] = this.msgType;
    data['msg_body'] = this.msgType;
    data['request_type'] = this.requestType;
    data['publish_date'] = this.publishDate;
    data['approval_status'] = this.approvalStatus;
    data['attachment_url'] = this.attachment;
    if (this.toList != null) {
      data['to_list'] = this.toList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToList {
  int? sectionId;
  String? sectionName;
  int? userRoleId;
  String? userRoleName;
  int? studentId;
  String? studentName;

  ToList(
      {this.sectionId,
      this.sectionName,
      this.userRoleId,
      this.userRoleName,
      this.studentId,
      this.studentName});

  ToList.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    sectionName = json['section_name'];
    userRoleId = json['user_role_id'];
    userRoleName = json['user_role_name'];
    studentId = json['student_id'];
    studentName = json['student_name'];
    if (studentName == null) {
      studentName = 'NA';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_id'] = this.sectionId;
    data['section_name'] = this.sectionName;
    data['user_role_id'] = this.userRoleId;
    data['user_role_name'] = this.userRoleName;
    data['student_id'] = this.studentId;
    data['student_name'] = this.studentName;
    return data;
  }
}
