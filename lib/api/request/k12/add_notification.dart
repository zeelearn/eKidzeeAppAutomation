import 'dart:convert';

import 'package:ekidzee/api/response/k12/notification/notification.dart'
    show StudentList;

class AddKesNotification {
  int? nId;
  String? username;
  String? subject;
  String? msgType;
  String? msgBody;
  String? requestType;
  String? publishDate;
  String? attachmentUrl;
  String? approvalStatus;
  List<StudentList>? studentList;

  AddKesNotification(
      {this.username,
      this.nId,
      this.approvalStatus,
      this.subject,
      this.msgType,
      this.msgBody,
      this.requestType,
      this.publishDate,
      this.attachmentUrl,
      this.studentList});

  AddKesNotification.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    subject = json['subject'];
    msgType = json['msg_type'];
    msgBody = json['msg_body'];
    requestType = json['request_type'];
    publishDate = json['publish_date'];
    attachmentUrl = json['attachment_url'];
    if (json['input_data'] != null) {
      studentList = <StudentList>[];
      json['input_data'].forEach((v) {
        studentList!.add(new StudentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toKesJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['subject'] = this.subject;
    data['msg_type'] = this.msgType;
    data['msg_body'] = this.msgBody;
    data['request_type'] = this.requestType;
    data['publish_date'] = this.publishDate;
    data['attachment_url'] = this.attachmentUrl;
    if (this.studentList != null) {
      data['input_data'] = this.studentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  toJson() {
    return jsonEncode({
      'n_id': this.nId ?? 0,
      'approval_status': this.approvalStatus ?? 'Pending',
      'username': this.username,
      'subject': this.subject,
      'msg_type': this.msgType,
      'msg_body': this.msgBody,
      'request_type': this.requestType,
      'publish_date': this.publishDate,
      'attachment_url': this.attachmentUrl,
      'input_data': this.studentList!.map((v) => v.toJson()).toList(),
    });
  }

  toMlzsJson() {
    return jsonEncode({
      'userId': this.username,
      'subject': this.subject,
      'msg_type': this.msgType,
      'msg_body': this.msgBody,
      'request_type': this.requestType,
      'publish_date': this.publishDate,
      'attachment_url': this.attachmentUrl,
      'input_data': this.studentList!.map((v) => v.toMlzsJson()).toList(),
    });
  }
}
