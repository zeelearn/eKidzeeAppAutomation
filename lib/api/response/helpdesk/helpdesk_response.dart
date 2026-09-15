class HelpDeskListResponse {
  List<HelpdeskModel> data = [];

  HelpDeskListResponse({required this.data});

  HelpDeskListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HelpdeskModel>[];
      json['data'].forEach((v) {
        data.add(new HelpdeskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class HelpdeskModel {
  double? businessId;
  double? helpdeskId;
  String? issueTitle;
  String? issueType;
  String? issueSubcategory;
  String? createdDate;
  int? indentId;
  String? indentStatus;
  String? status;
  String? businessName;
  String? uSERNAME;
  String? franchiseeCode;
  String? issueDescription;
  double? userId;
  String? crdate;

  HelpdeskModel(
      {this.businessId,
      this.helpdeskId,
      this.issueTitle,
      this.issueType,
      this.issueSubcategory,
      this.createdDate,
      this.indentId,
      this.indentStatus,
      this.status,
      this.businessName,
      this.uSERNAME,
      this.franchiseeCode,
      this.issueDescription,
      this.userId,
      this.crdate});

  HelpdeskModel.fromJson(Map<String, dynamic> json) {
    businessId = json['Business_Id'];
    helpdeskId = json['Helpdesk_Id'];
    issueTitle = json['Issue_Title'];
    issueType = json['Issue_Type'];
    issueSubcategory = json['IssueSubcategory'];
    createdDate = json['Created_Date'];
    indentId = json['Indent_Id'];
    indentStatus = json['Indent_Status'];
    status = json['status'];
    businessName = json['business_name'];
    uSERNAME = json['USER_NAME'];
    franchiseeCode = json['Franchisee_Code'];
    issueDescription = json['Issue_Description'];
    userId = json['user_id'];
    crdate = json['crdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business_Id'] = this.businessId;
    data['Helpdesk_Id'] = this.helpdeskId;
    data['Issue_Title'] = this.issueTitle;
    data['Issue_Type'] = this.issueType;
    data['IssueSubcategory'] = this.issueSubcategory;
    data['Created_Date'] = this.createdDate;
    data['Indent_Id'] = this.indentId;
    data['Indent_Status'] = this.indentStatus;
    data['status'] = this.status;
    data['business_name'] = this.businessName;
    data['USER_NAME'] = this.uSERNAME;
    data['Franchisee_Code'] = this.franchiseeCode;
    data['Issue_Description'] = this.issueDescription;
    data['user_id'] = this.userId;
    data['crdate'] = this.crdate;
    return data;
  }
}
