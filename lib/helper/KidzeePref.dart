import 'dart:convert';

import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/response/pentemind/get_day_response.dart';
import '../model/user_model.dart';

class KidzeePref {
  late SharedPreferences prefs;

  KidzeePref();
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  KidzeePref._internal();

  Future<SharedPreferences> getPref() async {
    // Obtain shared preferences.
    return await SharedPreferences.getInstance();
  }

  Future<String?>? getString(String key) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    await init();
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  Future<void> setString(String key, String value) async {
    // Save an String value to 'action' key.
    await init();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> setDay(
      BuildContext context, int programId, String json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalConstant.KEY_MODEL_DAY + programId.toString(), json);
    debugPrint(json);
  }

  static Future<GetDayResponse> getDay(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID);
    var data =
        prefs.getString(LocalConstant.KEY_MODEL_DAY + programId.toString());
    if (data != null) {
      debugPrint(data);
      return GetDayResponse.fromJson(
        json.decode(data),
      );
    } else {
//       debugPrint('not found......');
      return GetDayResponse(
          success: 400, data: GetDayResponseModel(D: 0, CName: '', C: '1'));
    }
  }

  Future<void> saveLoginResponse(LoginData response) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(response.toJson());
    await prefs.setString('login_response', jsonString);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveAcademicYear(int year) async {
    debugPrint('set Academic Year $year');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(LocalConstant.KEY_SEL_ACADEMIC_YEAR, year);
  }

  Future<int> getAcademicYear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(LocalConstant.KEY_SEL_ACADEMIC_YEAR) ??
        int.parse(DateFormat('yy').format(DateTime.now()));
  }

  Future<LoginData?> getLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('login_response');

    if (jsonString == null) return null;

    return LoginData.fromJson(jsonDecode(jsonString));
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_response');
    await prefs.remove('token');
  }

  Future<bool> isRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('isRememberMe ${prefs.getBool(LocalConstant.ISREMEMBER)}');
    return prefs.getBool(LocalConstant.ISREMEMBER) ?? false;
  }

  Future<void> updateRememberMe(bool isRemember) async {
    debugPrint('updateRememberMe $isRemember');
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LocalConstant.ISREMEMBER, isRemember);
  }
}
