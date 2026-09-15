import 'dart:convert';

class DevelopmentalRequest {
  DevelopmentalRequest({
    required this.ProgramID,
    required this.D,
    required this.ObservationType,
    required this.Term,
  });
  late final int ProgramID;
  late int D;
  late final String ObservationType;
  late String Term;

  DevelopmentalRequest.fromJson(Map<String, dynamic> json){
    ProgramID = json['Program_ID'];
    D = json['D'];
    ObservationType = json['ObservationType'];
    Term = json['Term'];
  }

  toJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'D': this.D,
      'ObservationType': this.ObservationType,
      'Term': this.Term,
    });
  }

  toDevelopmentalJson() {
    return jsonEncode({
      'Program_ID': this.ProgramID,
      'D': this.D,
      'ObservationType': this.ObservationType,
    });
  }

}