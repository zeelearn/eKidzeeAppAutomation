class ContentLogRequest {
  String? userID;
  String? contentID;
  String? contentType;

  ContentLogRequest({this.userID, this.contentID, this.contentType});

  ContentLogRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    contentID = json['ContentID'];
    contentType = json['ContentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['ContentID'] = this.contentID;
    data['ContentType'] = this.contentType;
    return data;
  }
}
