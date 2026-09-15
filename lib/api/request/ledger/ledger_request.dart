import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class LedgerRequest {
  int Franchisee_Id;
  int Status_ID;
  String From_Date;
  String To_Date;
  String SelectedYearVal;
  String SelectedMonthVal;
  String Type;


  LedgerRequest(
      {required this.Franchisee_Id,
        required this.Status_ID,
        required this.From_Date,
        required this.To_Date,
        required this.SelectedYearVal,
        required this.SelectedMonthVal,
        required this.Type,

      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Franchisee_Id': Franchisee_Id,
      'Status_ID': Status_ID,
      'From_Date': From_Date,
      'To_Date': To_Date,
      'SelectedMonthVal': SelectedMonthVal,
      'SelectedYearVal': SelectedYearVal,
      'Type': Type,
    };

    return map;
  }


  getJson(){
    return jsonEncode( {
      'Franchisee_Id': Franchisee_Id,
      'Status_ID': Status_ID,
      'From_Date': From_Date,
      'To_Date': To_Date,
      'SelectedYearVal': SelectedYearVal,
      'SelectedMonthVal': SelectedMonthVal,
      'Type': Type,
      'AppType' :kIsWeb ? 'web' :  Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown'
    });
  }
}