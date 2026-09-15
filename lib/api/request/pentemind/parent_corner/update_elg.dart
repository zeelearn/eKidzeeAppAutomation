import 'dart:convert';

import '../../../response/pentemind/parent/elg_stud_response.dart';

class UpdateElgObservationRequest {
  UpdateElgObservationRequest({
    required this.ProgramId,
    required this.Class_Id,
    required this.User_ID,
    required this.StudentID,
    required this.OBSRN,
  });
  late final int ProgramId;
  late final int Class_Id;
  late final String User_ID;
  late final int StudentID;
  late final List<OBSRNModel> OBSRN;

  UpdateElgObservationRequest.fromJson(Map<String, dynamic> json){
    ProgramId = json['Program_ID'];
    Class_Id = json['Class_Id'] ?? 0;
    User_ID = json['User_ID'] ?? 0;
    StudentID = json['StudentID'] ?? 0;
    OBSRN = List.from(json['InputData']).map((e)=>OBSRNModel.fromJson(e)).toList();
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramId,
      'Class_Id': this.Class_Id,
      'User_ID': this.User_ID,
      'StudentID': this.StudentID,
      'InputData': OBSRN.map((e)=>e.toJson()).toList()
    });
  }

}