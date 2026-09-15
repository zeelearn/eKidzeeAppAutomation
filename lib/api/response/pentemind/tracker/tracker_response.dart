import '../../../../globals.dart';

class TrackerResponse {
  TrackerResponse({
    required this.success,
    required this.trackerModelList,
  });
  late final int success;
  late final List<TrackerModel> trackerModelList;

  TrackerResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    trackerModelList = List.from(json['data']).map((e)=>TrackerModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = trackerModelList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TrackerModel {
  TrackerModel({
    required this.C,
    required this.Cid,
    required this.CName,
    required this.AttendanceDate,
    required this.Activity,
    required this.dataactivity,
  });
  late final String C;
  late final String Cid;
  late final String CName;
  late final String AttendanceDate;
  late final String Activity;
  late final String dataactivity;

  TrackerModel.fromJson(Map<String, dynamic> json){
    C = convertStringJson(json, 'C');//json['C'] ?? '';
    Cid = convertStringJson(json, 'Cid');//json['Cid'] ?? '';
    CName = convertStringJson(json, 'CName');//json['CName'] ?? '';
    AttendanceDate = convertStringJson(json, 'AttendanceDate');//json['AttendanceDate'] ?? '';
    Activity = convertStringJson(json, 'Activity');//json['Activity'] ?? '';
    dataactivity = convertStringJson(json, 'dataactivity');//json['dataactivity'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['C'] = C;
    _data['Cid'] = Cid;
    _data['CName'] = CName;
    _data['AttendanceDate'] = AttendanceDate;
    _data['Activity'] = Activity;
    _data['dataactivity'] = dataactivity;
    return _data;
  }
}