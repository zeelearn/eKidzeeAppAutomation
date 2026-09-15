import '../../../../globals.dart';

class AnnouncementListResponse {
  late int success;
  late AnnouncementData announcementModel;

  AnnouncementListResponse(
      {required this.success, required this.announcementModel});

  AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    announcementModel = (json['data'] != null
        ? new AnnouncementData.fromJson(json['data'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.announcementModel.toJson();
    return data;
  }
}

class AnnouncementData {
  late int totalPages;
  late List<AnnouncementModel> announcementList = [];

  AnnouncementData({required this.totalPages, required this.announcementList});

  AnnouncementData.fromJson(Map<String, dynamic> json) {
    totalPages = json['TotalPages'];
    if (json['MsgBody'] != null) {
      announcementList = <AnnouncementModel>[];
      json['MsgBody'].forEach((v) {
        announcementList.add(new AnnouncementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalPages'] = this.totalPages;
    data['MsgBody'] = this.announcementList.map((v) => v.toJson()).toList();
    return data;
  }
}

class AnnouncementModel {
  late int iD;
  late String subject;
  late String msgBody;
  late String publishDate;

  AnnouncementModel(
      {required this.iD,
      required this.subject,
      required this.msgBody,
      required this.publishDate});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    iD = convertintJson(json, 'ID'); //json['ID'];
    subject = convertStringJson(json, 'Subject'); //json['Subject'];
    msgBody = convertStringJson(json, 'MsgBody'); //json['MsgBody'];
    publishDate = convertStringJson(json, 'PublishDate'); //json['PublishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Subject'] = this.subject;
    data['MsgBody'] = this.msgBody;
    data['PublishDate'] = this.publishDate;
    return data;
  }
}
