// lib/data/datasources/logbook_remote_data_source.dart
import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/data_sources/learninggoal_datasource.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model_get.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LogbookRemoteDataSource {
  LogbookRemoteDataSource();

  Future<KESLogbookModel> getLogbook(
      int classId, int subjectId, String userName, int franchiseeId) async {
    http.Client client = http.Client();
    debugPrint(
        'In api getlogbook  ${LocalStrings.lmsBaseUrl}LMS/GetAcademicsConfig');
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetAcademicsConfig'),
      headers: APIService().getNormalHeader1(),
      body: json.encode({
        'class_id': classId,
        'subject_id': subjectId,
        'username': userName,
        // 'franchisee_id': franchiseeId,
      }),
    );
    debugPrint('logbook request ${response.request.toString()}');
    debugPrint('logbok response ${response.body}');
    if (response.statusCode == 200) {
      LearninggoalRemoteDatasource()
          .saveOfflineLogbook(classId, subjectId, response.body.toString());
      return KESLogbookModel.fromJson(json.decode(response.body));
    } else {
      return KESLogbookModel(academics: []);
    }
  }

  Future<GeneralResponse> insertTeacherLogbook(
      Map<String, dynamic> logbookData) async {
    http.Client client = http.Client();
    debugPrint('Insert Teacher Logbook');
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/InsertTeacherLogBook'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode(logbookData),
    );
    debugPrint('Insert Teacher Logbook request ${jsonEncode(logbookData)}');
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      return GeneralResponse(
          success: 0,
          data: GMessage(msg: "Unable to reach, please try again later"));
    }
  }

  Future<List<LogbookTimeTableModel>> getTimetable(
      String username, String date) async {
    final response = await http.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetTeachersTimeTable'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({'username': username, 'date': date}),
    );
    debugPrint('${LocalStrings.lmsBaseUrl}LMS/GetTeachersTimeTable');
    debugPrint(jsonEncode({'username': username, 'date': date}));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data != null) {
        LearninggoalRemoteDatasource()
            .saveTimeTable(date, response.body.toString());
        return List<LogbookTimeTableModel>.from(
            data.map((item) => LogbookTimeTableModel.fromJson(item)));
      } else
        return [];
    } else {
      return [];
    }
  }

  Future<GetTeacherLogbookModel> getTeacherLogbook(String username,
      int businessId, String date, int periodId, int sectionId) async {
//     debugPrint('load Teachers logbook');
    final response = await http.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetTeacherLogBook'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        "username": username,
        "business_id": businessId,
        "date": date,
        "period_id": periodId,
        "section_id": sectionId,
      }),
    );
    debugPrint('request ${jsonEncode({
          "username": username,
          "business_id": businessId,
          "date": date,
          "period_id": periodId,
          "section_id": sectionId,
        })}');
    debugPrint(
        '${response.body}${jsonDecode(response.body)['data'].runtimeType}');
    if (response.statusCode == 200) {
      final model =
          GetTeacherLogbookModel.fromJson(jsonDecode(response.body)['data']);
      return model;
    } else {
      return GetTeacherLogbookModel(
          classId: 0,
          className: '0',
          subjectId: 0,
          subjectName: '',
          chapterId: 0,
          chapterName: '',
          topicId: 0,
          topicName: '',
          activity: '',
          teachingAids: '',
          classwork: '',
          homework: '',
          closure: [],
          learningOutcome: [],
          remarks: '');
    }
  }
}
