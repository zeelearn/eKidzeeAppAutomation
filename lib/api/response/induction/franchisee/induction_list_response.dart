import 'dart:convert';
import 'dart:io';

class InductionListResponseModel {
  bool Status=false;
  late String Indent_status;
  late String Created_Date;
  late int Indent_Id;
  late int UserId;
  late int Induction_Id;
  late String Teacher_Name;
  late String Induction_Name;


  InductionListResponseModel(
      {required this.Status,
        required this.Indent_status,
        required this.Created_Date,
        required this.Indent_Id,
        required this.Induction_Id,
        required this.UserId,
        required this.Teacher_Name,
        required this.Induction_Name,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Status': Status,
      'Indent_status': Indent_status.trim(),
      'Created_Date': Created_Date.trim(),
      'Indent_Id': Indent_Id,
      'UserId': UserId,
      'Induction_Id': Induction_Id,
      'Teacher_Name': Teacher_Name.trim(),
      'Induction_Name': Induction_Name.trim(),
    };

    return map;
  }

  InductionListResponseModel.fromJson(Map<String, dynamic> json) {
    //id = json['$id'];
    UserId = json['UserId'] ?? '';
    Induction_Id = json['Induction_Id'];
    Induction_Name = json['Induction_Name'];
    Status = json['Status'];
    //franchiseeId = json['Franchisee_Id'];
    Teacher_Name = json['Teacher_Name'];
    Created_Date = json['Created_Date'] ?? '';
    Indent_Id = json['Indent_Id'];
    //franchiseeUserId = json['Franchisee_User_Id'];
    //year = json['Year'];
    //tSIPIID = json['TSIPI_ID'];
    Indent_status = json['Indent_status'];
  }

  getJson(){
    return jsonEncode( {
      'Status': Status,
      'Indent_status': Indent_status,
      'Created_Date': Created_Date,
      'Indent_Id': Indent_Id,
      'UserId': UserId,
      'Induction_Id': Induction_Id,
      'Teacher_Name': Teacher_Name,
      'Induction_Name': Induction_Name,
      'AppType' :Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}