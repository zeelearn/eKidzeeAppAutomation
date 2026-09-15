import 'package:ekidzee/model/parent_info.dart';

class ParentInfoResponse{

  late List<ParentInfo> data;

  ParentInfoResponse({ required this.data});

  ParentInfoResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ParentInfo>[];
      json['data'].forEach((v) {
        data.add(ParentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }


}