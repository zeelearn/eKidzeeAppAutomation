import 'dart:convert';

class ApprovedRequest {
  ApprovedRequest({
    required this.ApprovedStatus,
    required this.ApprovedBy,
    required this.inputdata,
  });
  late final String ApprovedStatus;
  late final String ApprovedBy;
  late final List<ApprovalModel> inputdata;

  ApprovedRequest.fromJson(Map<String, dynamic> json){
    ApprovedStatus = json['ApprovedStatus'];
    ApprovedBy = json['ApprovedBy'];
    inputdata = List.from(json['inputdata']).map((e)=>ApprovalModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'ApprovedStatus': this.ApprovedStatus,
      'ApprovedBy': this.ApprovedBy,
      'inputdata': inputdata.map((e)=>e.toJson()).toList(),
    });
  }
}

class ApprovalModel {
  ApprovalModel({
    required this.ID,
  });
  late final int ID;

  ApprovalModel.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    return _data;
  }
}