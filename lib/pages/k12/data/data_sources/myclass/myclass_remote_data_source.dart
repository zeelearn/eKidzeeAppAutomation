import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/attendance_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MyclassRemoteDataSource {
  Future<String> insertStudentCompetencies(AttendanceModel model) async {
    final response = await http.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/InsertMyClassAttendance'),
      headers: APIService().getNormalHeader1(),
      body: json.encode(model.toJson()),
    );
    debugPrint(model.toJson().toString());
    debugPrint('insertStudentCompetencies ${response.body}');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data']['msg'];
    } else {
      return "Something went wrong";
    }
  }
}
