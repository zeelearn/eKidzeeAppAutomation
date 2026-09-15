class ContentLogResponse {
  String? id;
  int? iD;
  String? result;
  String? status;
  String? contentID;
  String? indentStatus;

  ContentLogResponse(
      {this.id,
        this.iD,
        this.result,
        this.status,
        this.contentID,
        this.indentStatus});

  ContentLogResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    iD = json['ID'];
    result = json['Result'];
    status = json['Status'];
    contentID = json['ContentID'];
    indentStatus = json['Indent_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ID'] = this.iD;
    data['Result'] = this.result;
    data['Status'] = this.status;
    data['ContentID'] = this.contentID;
    data['Indent_status'] = this.indentStatus;
    return data;
  }
}
