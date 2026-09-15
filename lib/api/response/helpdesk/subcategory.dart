class HelpDeskSubCategoryResponse {
  List<HelpDeskSubCategoryModel> data=[];

  HelpDeskSubCategoryResponse({required this.data});

  HelpDeskSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HelpDeskSubCategoryModel>[];
      json['data'].forEach((v) {
        data.add(new HelpDeskSubCategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class HelpDeskSubCategoryModel {
  int? issueSubcategoryId;
  String? name;

  HelpDeskSubCategoryModel({this.issueSubcategoryId, this.name});

  HelpDeskSubCategoryModel.fromJson(Map<String, dynamic> json) {
    issueSubcategoryId = json['Issue_Subcategory_Id'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Issue_Subcategory_Id'] = this.issueSubcategoryId;
    data['Name'] = this.name;
    return data;
  }
}
