import '../../../../globals.dart';

class ParentTrackerResponse {
  ParentTrackerResponse({
    required this.success,
    required this.trackerList,
  });
  late final int success;
  late final List<ParentTrackerInfo> trackerList;

  ParentTrackerResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    trackerList = List.from(json['data']).map((e)=>ParentTrackerInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = trackerList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ParentTrackerInfo {
  ParentTrackerInfo({
    required this.C,
    required this.Cid,
    required this.CName,
    required this.AttendanceDate,
    required this.Activity,
  });
  late final String C;
  late final String Cid;
  late final String CName;
  late final String AttendanceDate;
  late final String Activity;

  ParentTrackerInfo.fromJson(Map<String, dynamic> json){
    C = convertStringJson(json, 'C');//json['C'];
    Cid = convertStringJson(json, 'Cid');//json['Cid'];
    CName = convertStringJson(json, 'CName');//json['CName'];
    AttendanceDate = convertStringJson(json, 'AttendanceDate');//json['AttendanceDate'];
    Activity = convertStringJson(json, 'Activity');// json['Activity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['C'] = C;
    _data['Cid'] = Cid;
    _data['CName'] = CName;
    _data['AttendanceDate'] = AttendanceDate;
    _data['Activity'] = Activity;
    return _data;
  }
}