import '../../../../globals.dart';

class ElgDetailsResponse {
  ElgDetailsResponse({
    required this.success,
    required this.elgDetailsList,
  });
  late final int success;
  late final List<ElgDetailsModel> elgDetailsList;

  ElgDetailsResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    elgDetailsList = List.from(json['data']).map((e)=>ElgDetailsModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = elgDetailsList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ElgDetailsModel {
  ElgDetailsModel({
    required this.StudentID,
    required this.StudentName,
    required this.ParentName,
    required this.MobileNo,
    required this.Title,
    required this.StatusCode,
    required this.OBSRN,
  });
  late final int StudentID;
  late final String StudentName;
  late final String ParentName;
  late final String MobileNo;
  late final String Title;
  late final String StatusCode;
  late final List<OBSRNModel>? OBSRN;

  ElgDetailsModel.fromJson(Map<String, dynamic> json){
    StudentID = convertintJson(json, 'StudentID');//json['StudentID'];
    StudentName = convertStringJson(json, 'Student_Name');//json['Student_Name'];
    ParentName =convertStringJson(json, 'Parent_Name');// json['Parent_Name'];
    MobileNo = convertStringJson(json, 'Mobile_No');//json['Mobile_No'];
    Title = convertStringJson(json, 'Title');//json['Title'];
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'];
    OBSRN = List.from(json['OBSRN']).map((e)=>OBSRNModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StudentID'] = StudentID;
    _data['Student_Name'] = StudentName;
    _data['Parent_Name'] = ParentName;
    _data['Mobile_No'] = MobileNo;
    _data['Title'] = Title;
    _data['StatusCode'] = StatusCode;
    _data['OBSRN'] = OBSRN!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class OBSRNModel {
  OBSRNModel({
    required this.PCID,
    required this.TransType,
    required this.Observation,
    required this.StatusCode,
  });
  late final int PCID;
  late final String TransType;
  late final String Observation;
  late final String StatusCode;

  OBSRNModel.fromJson(Map<String, dynamic> json){
    PCID = convertintJson(json, 'PCID');//json['PCID'];
    TransType = convertStringJson(json, 'TransType');//json['TransType'];
    Observation = convertStringJson(json, 'Observation');//json['Observation'];
    StatusCode = convertStringJson(json, 'StatusCode');//json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PCID'] = PCID;
    _data['TransType'] = TransType;
    _data['Observation'] = Observation;
    _data['StatusCode'] = StatusCode;
    return _data;
  }
}