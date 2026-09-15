import 'dart:convert';

class GetAnecdotalStudentList {
  GetAnecdotalStudentList({
    required this.UserID,
    required this.ProgramID,
    required this.InputType,
    required this.RefKey,
    required this.Term,
  });
  late final String UserID;
  late final int ProgramID;
  late final String InputType;
  late final String RefKey;
  late final String Term;

  GetAnecdotalStudentList.fromJson(Map<String, dynamic> json){
    UserID = json['User_ID'];
    ProgramID = json['Program_ID'];
    InputType = json['InputType'];
    RefKey = json['RefKey'];
    Term = json['Term'];
  }

  toJson() {
    return jsonEncode({
      'User_ID': this.UserID,
      'Program_ID': this.ProgramID,
      'InputType': this.InputType,
      'RefKey': this.RefKey,
      'Term': this.Term,
    });
  }

}