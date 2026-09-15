class NewsResponse {
  late List<NewsModel> data;

  NewsResponse({required this.data});

  NewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NewsModel>[];
      json['data'].forEach((v) {
        data.add(new NewsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}
class NewsModel {
  int? tipId;
  String? userType;
  String? tipSubject;
  String? tipDescription;
  String? tipAuthorProfileImage;
  String? tipDate;
  String? tipCreatedBy;
  List<TipContentList>? tipContentList;
  String? createdByName;
  String? userTypes;
  String? attachmentUrl;
  int? isTipSeen;
  String? contentType;

  NewsModel(
      {this.tipId,
        this.userType,
        this.tipSubject,
        this.tipDescription,
        this.tipAuthorProfileImage,
        this.tipDate,
        this.tipCreatedBy,
        this.tipContentList,
        this.createdByName,
        this.userTypes,
        this.attachmentUrl,
        this.isTipSeen,
        this.contentType});

  NewsModel.fromJson(Map<String, dynamic> json) {
    tipId = json['Tip_Id'];
    userType = json['User_Type'];
    tipSubject = json['Tip_Subject'];
    tipDescription = json['Tip_Description'];
    tipAuthorProfileImage = json['Tip_Author_ProfileImage'];
    tipDate = json['Tip_Date'];
    tipCreatedBy = json['Tip_CreatedBy'];
    if (json['Tip_Content_List'] != null) {
      tipContentList = <TipContentList>[];
      json['Tip_Content_List'].forEach((v) {
        tipContentList!.add(new TipContentList.fromJson(v));
      });
    }
    createdByName = json['CreatedByName'];
    userTypes = json['UserTypes'];
    attachmentUrl = json['AttachmentUrl'];
    isTipSeen = json['Is_TipSeen'];
    contentType = json['Content_Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Tip_Id'] = this.tipId;
    data['User_Type'] = this.userType;
    data['Tip_Subject'] = this.tipSubject;
    data['Tip_Description'] = this.tipDescription;
    data['Tip_Author_ProfileImage'] = this.tipAuthorProfileImage;
    data['Tip_Date'] = this.tipDate;
    data['Tip_CreatedBy'] = this.tipCreatedBy;
    if (this.tipContentList != null) {
      data['Tip_Content_List'] =
          this.tipContentList!.map((v) => v.toJson()).toList();
    }
    data['CreatedByName'] = this.createdByName;
    data['UserTypes'] = this.userTypes;
    data['AttachmentUrl'] = this.attachmentUrl;
    data['Is_TipSeen'] = this.isTipSeen;
    data['Content_Type'] = this.contentType;
    return data;
  }
}

class TipContentList {
  int? tipContentID;
  String? tipContentType;
  String? tipContentPath;
  String? tipContentDate;
  String? tipContentCreatedBy;
  int? tipID;
  Null tipContentVideoPath;

  TipContentList(
      {this.tipContentID,
        this.tipContentType,
        this.tipContentPath,
        this.tipContentDate,
        this.tipContentCreatedBy,
        this.tipID,
        this.tipContentVideoPath});

  TipContentList.fromJson(Map<String, dynamic> json) {
    tipContentID = json['TipContent_ID'];
    tipContentType = json['TipContent_Type'];
    tipContentPath = json['TipContent_Path'];
    tipContentDate = json['TipContent_Date'];
    tipContentCreatedBy = json['TipContent_CreatedBy'];
    tipID = json['Tip_ID'];
    tipContentVideoPath = json['TipContentVideo_Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TipContent_ID'] = this.tipContentID;
    data['TipContent_Type'] = this.tipContentType;
    data['TipContent_Path'] = this.tipContentPath;
    data['TipContent_Date'] = this.tipContentDate;
    data['TipContent_CreatedBy'] = this.tipContentCreatedBy;
    data['Tip_ID'] = this.tipID;
    data['TipContentVideo_Path'] = this.tipContentVideoPath;
    return data;
  }
}
