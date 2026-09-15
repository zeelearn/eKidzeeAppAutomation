import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:http/http.dart' as http;

abstract class StudentProfileRemoteDataSource {
  Future<void> insertStudentProfile({
    required int teacherId,
    required int studentId,
    required int sectionId,
    required String reportName,
    required int totalDays,
    required int outOfDays,
    required String learnerIs,
    required String learnerStrengths,
    required String learnerChallenges,
    required String suggestions,
    required int createdBy,
  });
}

class StudentProfileRemoteDataSourceImpl
    implements StudentProfileRemoteDataSource {
  final http.Client client;

  StudentProfileRemoteDataSourceImpl(this.client);

  @override
  Future<void> insertStudentProfile({
    required int teacherId,
    required int studentId,
    required int sectionId,
    required String reportName,
    required int totalDays,
    required int outOfDays,
    required String learnerIs,
    required String learnerStrengths,
    required String learnerChallenges,
    required String suggestions,
    required int createdBy,
  }) async {
    final response = await client.post(
      Uri.parse('${LocalStrings.kesBaseUrl}LMS/InsertLearnerProfile'),
      headers: APIService().getNormalHeader1(),
      body: json.encode({
        'Teacher_Id': teacherId,
        'Student_Id': studentId,
        'Section_id': sectionId,
        'Report_Name': reportName,
        'Totaldays': totalDays,
        'Outofdays': outOfDays,
        'LearnerIs': learnerIs,
        'Learner_Strengths': learnerStrengths,
        'Learner_Challenges': learnerChallenges,
        'Suggestions': suggestions,
        'Created_by': createdBy,
      }),
    );

    if (response.statusCode != 200) {}
  }
}
