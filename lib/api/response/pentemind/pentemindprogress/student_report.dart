class StudentReportResponse {
  StudentReportResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<ReportModel> data;

  StudentReportResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>ReportModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ReportModel {
  ReportModel({
    required this.reportaccess,
  });
  late final List<Reportaccess> reportaccess;

  ReportModel.fromJson(Map<String, dynamic> json){
    reportaccess = List.from(json['reportaccess']).map((e)=>Reportaccess.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['reportaccess'] = reportaccess.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Reportaccess {
  Reportaccess({
    required this.ReportID,
  });
  late final String ReportID;

  Reportaccess.fromJson(Map<String, dynamic> json){
    ReportID = json['ReportID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ReportID'] = ReportID;
    return _data;
  }
}