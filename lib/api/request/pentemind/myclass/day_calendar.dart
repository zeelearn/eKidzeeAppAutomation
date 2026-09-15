import 'dart:convert';

class GetDayCalenderRequest {
  GetDayCalenderRequest({
    required this.C,
    required this.ProgramId,
  });
  late final int C;
  late final int ProgramId;

  GetDayCalenderRequest.fromJson(Map<String, dynamic> json){
    C = json['C'];
    ProgramId = json['Program_Id'];

  }

  toJson() {
    return jsonEncode({
      'C': this.C,
      'Program_Id': this.ProgramId,
    });
  }

}