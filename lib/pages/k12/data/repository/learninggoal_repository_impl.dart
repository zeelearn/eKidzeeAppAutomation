import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/data_sources/learninggoal_datasource.dart';
import 'package:ekidzee/pages/k12/data/models/LG/observationmodel.dart';
import 'package:ekidzee/pages/k12/data/models/LG/studentModel.dart';
import 'package:ekidzee/pages/k12/data/models/LG/student_rating_model.dart';
import 'package:ekidzee/pages/k12/data/models/ppan_model.dart';
import 'package:ekidzee/pages/k12/domain/repositories/learninggoal_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LearninggoalRepositoryImpl implements LearninggoalRepository {
  final LearninggoalRemoteDatasource remoteDataSource;

  LearninggoalRepositoryImpl(this.remoteDataSource);

  @override
  Future<ClassInfoModel> getLearningMasters(
      String className, int sectionId, String userId, String username) async {
    http.Client client = http.Client();
//     debugPrint('getLearning Goal api calling...');
    try {
      final response = await client.post(
        Uri.parse(
            '${LocalStrings.lmsBaseUrl}LMS/GetMasterForCompetenciesForApp'),
        // Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetMasterForCompetencies'),
        headers: APIService().getNormalHeader1(),
        body: jsonEncode({
          'class_name': className,
          'section_id': sectionId,
          'user_name': username
        }),
      );
      debugPrint(jsonEncode({
        'class_name': className,
        'section_id': sectionId,
        'user_name': username
      }));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
//       debugPrint('API response ${data['data'][0]}');
        return ClassInfoModel.fromJson(data['data'][0]);
      } else {
//       debugPrint('API response throw error - ${response.body}');
        return ClassInfoModel(
            classId: 0,
            className: className,
            subject: [],
            sectionId: sectionId);
      }
    } catch (e) {
      debugPrint('Error in api is - $e');
      return ClassInfoModel(
          classId: 0, className: className, subject: [], sectionId: sectionId);
    }
  }

  @override
  Future<List<KESLGModel>> getObservations({
    required int classId,
    required int subjectId,
    required int phId,
    required int ppanId,
    required int sectionId,
  }) async {
    http.Client client = http.Client();
//     debugPrint('getObservations api calling...');
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetCompetenciesConfig'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        'class_id': classId,
        'subject_id': subjectId,
        'ph_id': phId,
        'ppan_id': ppanId,
        'section_id': sectionId,
      }),
    );
    debugPrint(jsonEncode({
      'class_id': classId,
      'subject_id': subjectId,
      'ph_id': phId,
      'ppan_id': ppanId,
      'section_id': sectionId,
    }));

//     debugPrint('in 62 response we are getting');
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var list = data['data'] as List;
      List<KESLGModel> model = list.map((i) => KESLGModel.fromJson(i)).toList();
//       debugPrint('respnser parsed successfully');
      return model;
    } else {
//       debugPrint('error in 70');
      throw Exception('Failed to load competencies');
    }
  }

  @override
  Future<StudentsResponse> getCompetenciesStudentList(
      {required int ccId,
      required int sectionId,
      required String userName}) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetCompetenciesStudentList'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        'cc_id': ccId,
        'section_id': sectionId,
        'user_name': userName,
      }),
    );
    debugPrint('Request body is - ${jsonEncode({
          'cc_id': ccId,
          'section_id': sectionId,
          'user_name': userName,
        })}');
    if (response.statusCode == 200) {
      //debugPrint(response.body);
      return StudentsResponse.fromJson(jsonDecode(response.body));
    } else {
//       debugPrint('error  ${response.body}');
      //throw Exception('Failed to load data ${response.body}');
      return StudentsResponse(success: 400, data: []);
    }
  }

  @override
  Future<Map<String, dynamic>> saveStudentRating(
      StudentRatingModel ratingModel) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/InsertStudentCompetencies'),
      headers: APIService().getNormalHeader1(),
      body: json.encode(ratingModel.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save rating');
    }
  }
}
