class CulminationResponse {
  int? success;
  List<CulminationModel>? data;

  CulminationResponse({this.success, this.data});

  CulminationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CulminationModel>[];
      json['data'].forEach((v) {
        data!.add(new CulminationModel.fromJson(v));
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

class CulminationModel {
  int? c;
  String? culminationName;
  String? displayName;
  String? classTermType;
  String? term;

  CulminationModel(
      {this.c,
        this.culminationName,
        this.displayName,
        this.classTermType,
        this.term});

  CulminationModel.fromJson(Map<String, dynamic> json) {
    c = json['C'];
    culminationName = json['Culmination_Name'];
    displayName = json['DisplayName'];
    classTermType = json['Class_Term_Type'];
    term = json['Term'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['C'] = this.c;
    data['Culmination_Name'] = this.culminationName;
    data['DisplayName'] = this.displayName;
    data['Class_Term_Type'] = this.classTermType;
    data['Term'] = this.term;
    return data;
  }
}
