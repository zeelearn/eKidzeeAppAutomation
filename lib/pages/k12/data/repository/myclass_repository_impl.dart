import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/data_sources/myclass/myclass_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/attendance_model.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_student_list.dart';
import 'package:ekidzee/pages/k12/domain/repositories/myclass/myclass_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyclassRepositoryImpl extends MyclassRepository {
  @override
  Future<ClassMasterModel> getTerms() async {
    debugPrint("Cognimind is - ${LocalConstant.isCognimind}");
    var prefs = await SharedPreferences.getInstance();
    String? token = await KidzeePref().getString(LocalConstant.KEY_APP_TOKEN);
    int? programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID);
    int? businessId = prefs.getInt(LocalConstant.KEY_BUSINESS_ID);

    String? username = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
    http.Client client = http.Client();
    final response = await client.post(
        Uri.parse(
            '${LocalStrings.lmsBaseUrl}${LocalConstant.isCognimind ? LocalStrings.API_GETATTENDANCEMASTERCOGNIMIND : 'LMS/GetAttendanceMaster'}'),
        headers: LocalConstant.isCognimind
            ? APIService().getHeader(token ?? '')
            : APIService().getNormalHeader1(),
        body: LocalConstant.isCognimind
            ? jsonEncode({
                "section_id": programId,
                "username": username,
                "business_id": businessId
              })
            : null);
//     debugPrint('getTerms response ${response.body}');
    if (response.statusCode == 200) {
      return ClassMasterModel.fromJson(jsonDecode(response.body));
    } else {
      return ClassMasterModel(success: 400, data: []);
    }
  }

  @override
  Future<StudentKesAttandanceResponse> getStudentAttendance(
      int sectionId, String userName, String attendanceDate) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetAttendanceStudentList'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        'section_id': sectionId,
        'username': userName,
        'attendance_date': attendanceDate
      }),
    );
    debugPrint(jsonEncode({
      'section_id': sectionId,
      'username': userName,
      'attendance_date': attendanceDate
    }));
//     debugPrint('response ${response.body}');
    if (response.statusCode == 200) {
      return StudentKesAttandanceResponse.fromJson(jsonDecode(response.body));
    } else {
      return StudentKesAttandanceResponse(success: 400, data: []);
    }
  }

  @override
  Future<AttandanceDaysResponse> getAttandanceCalender(
      int sectionId, int month, int year) async {
    String? token = await KidzeePref().getString(LocalConstant.KEY_APP_TOKEN);
    debugPrint('Cognimind - ${LocalConstant.isCognimind}');
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse(
          '${LocalStrings.lmsBaseUrl}${LocalConstant.isCognimind ? LocalStrings.API_GET_DAY_CALENDAR_COGNIMIND : 'LMS/GetDayCalender'}'),
      headers: LocalConstant.isCognimind
          ? APIService().getHeader(token ?? '')
          : APIService().getNormalHeader1(),
      body: jsonEncode({'section_id': sectionId, 'month': month, 'year': year}),
    );
    //debugPrint(jsonEncode({'section_id': sectionId, 'month': month}));
    //debugPrint('getAttandanceCalender response ${response.body}');
    if (response.statusCode == 200) {
      return AttandanceDaysResponse.fromJson(jsonDecode(response.body));
    } else {
      return AttandanceDaysResponse(data: [], success: 500);
    }
  }

  @override
  Future<String> saveAttendance(AttendanceModel attendance) {
    // final model = AttendanceModel(
    //   teacherId: attendance.teacherId,
    //   userName: attendance.userName,
    //   sectionId: attendance.sectionId,
    //   inputData: attendance.inputData.map((e) {
    //     return InputDataModel(
    //       ccId: e.ccId,
    //       studentId: e.studentId,
    //       rating: e.rating,
    //     );
    //   }).toList(),
    // );
    MyclassRemoteDataSource apiDataSource = MyclassRemoteDataSource();
    return apiDataSource.insertStudentCompetencies(attendance);
  }
}
