import 'package:ekidzee/globals.dart';

class HelpDeskCategoryResponse {
  List<HelpDeskCategoryModel> data=[];

  HelpDeskCategoryResponse({required this.data});

  HelpDeskCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HelpDeskCategoryModel>[];
      json['data'].forEach((v) {
        data.add(new HelpDeskCategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class HelpDeskCategoryModel {
  int? businessIssueId;
  String? issueTypeCode;
  String? issueType;
  String? controlDisplayed;

  HelpDeskCategoryModel(
      {this.businessIssueId,
        this.issueTypeCode,
        this.issueType,
        this.controlDisplayed});

  HelpDeskCategoryModel.fromJson(Map<String, dynamic> json) {
    businessIssueId = convertintJson(json, 'Business_Issue_Id');//json['Business_Issue_Id'];
    issueTypeCode = convertStringJson(json, 'Issue_Type_Code');//json['Issue_Type_Code'];
    issueType = convertStringJson(json, 'Issue_Type');//json['Issue_Type'];
    controlDisplayed =convertStringJson(json, 'Control_Displayed');// json['Control_Displayed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business_Issue_Id'] = this.businessIssueId;
    data['Issue_Type_Code'] = this.issueTypeCode;
    data['Issue_Type'] = this.issueType;
    data['Control_Displayed'] = this.controlDisplayed;
    return data;
  }
}
