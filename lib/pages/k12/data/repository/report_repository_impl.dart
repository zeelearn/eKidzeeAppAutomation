import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/reports/report_access_model.dart';
import 'package:ekidzee/pages/k12/data/models/reports/student_profile_model.dart';
import 'package:ekidzee/pages/k12/data/models/reports/student_profile_response.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/kes_certificate.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_list_lgreport.dart';
import 'package:ekidzee/pages/k12/domain/repositories/report_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportRepositoryImpl extends ReportRepository {
  @override
  Future<List<ReportPhase>> getPhases(String classId, String sectionId) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}api/LMS/getPhaseforReport'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode(
          {'class_id': classId, 'section_id': sectionId, 'from': 'App'}),
    );

    debugPrint(
        'Response grom reports api is - ${response.body} and request is - ${jsonEncode({
          'class_id': classId,
          'section_id': sectionId,
          'from': 'App'
        })}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> phasesJson = data['data'];
      return phasesJson.map((json) => ReportPhase.fromJson(json)).toList();
    } else {
//       debugPrint('Error is - ${response.body}');
      throw [];
    }
  }

  @override
  Future<List<StudentForLGReport>> getStudents(
      int sectionId, String userId, String reportName) async {
    http.Client client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetReportStudentList'),
        headers: APIService().getNormalHeader1(),
        body: jsonEncode({
          'section_id': sectionId,
          'user_id': null,
          'Report_name': reportName,
          'from': 'App'
        }),
      );
      debugPrint(
          'Response grom reports api is - ${response.body} and request is - ${jsonEncode({
            'section_id': sectionId,
            'user_id': null,
            'Report_name': reportName,
            'from': 'App'
          })}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> studentsJson = data['data'];
        return studentsJson
            .map((json) => StudentForLGReport.fromJson(json))
            .toList();
      } else {
        throw [];
      }
    } catch (e) {
      debugPrint('Error is - $e');
      throw [];
    }
  }

  @override
  Future<KESCertificate> fetchKesCertificate(
      int sectionId, int studentId, String phaseId, int isHtml) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/KEScertificate'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        'section_id': sectionId,
        'student_id': studentId,
        'phase_id': phaseId,
        'ishtml': isHtml,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return KESCertificate.fromJson(responseData['data']);
    } else {
      throw 'Unable to load the Certificate';
    }
  }

  @override
  Future<StudentProfileModel> getStudentProfile(
      int studentId, int sectionId, String reportName) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetLearnerprofile'),
      headers: APIService().getNormalHeader1(),
      body: json.encode({
        'student_id': studentId,
        'section_id': sectionId,
        'reportname': reportName,
      }),
    );
    debugPrint(json.encode({
      'student_id': studentId,
      'section_id': sectionId,
      'reportname': reportName,
    }));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      debugPrint(response.body);
      return StudentProfileModel.fromJson(jsonData['data'][0]);
    } else {
      return StudentProfileModel(
        createdBy: '',
        studentId: 0,
        createdDate: '',
        isActive: true,
        learnerChallenges: '',
        learnerId: 0,
        learnerIs: '',
        learnerStrengths: '',
        outOfDay: 0,
        reportName: '',
        sectionId: sectionId,
        suggestions: '',
        teacherId: 0,
        totalDay: 0,
      );
    }
  }

  @override
  Future<StudentInfoResponse> insertStudentProfile({
    required String userName,
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
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/InsertLearnerProfile'),
      headers: APIService().getNormalHeader1(),
      body: json.encode({
        'Teacher_Id': null,
        'user_name': userName,
        'Student_Id': studentId,
        'Section_id': sectionId,
        'Report_Name': reportName,
        'Totaldays': totalDays,
        'Outofdays': outOfDays,
        'LearnerIs': learnerIs,
        'Learner_Strengths': learnerStrengths,
        'Learner_Challenges': learnerChallenges,
        'Suggestions': suggestions,
        'Created_by': null,
      }),
    );
    debugPrint(json.encode({
      'Teacher_Id': null,
      'user_name': userName,
      'Student_Id': studentId,
      'Section_id': sectionId,
      'Report_Name': reportName,
      'Totaldays': totalDays,
      'Outofdays': outOfDays,
      'LearnerIs': learnerIs,
      'Learner_Strengths': learnerStrengths,
      'Learner_Challenges': learnerChallenges,
      'Suggestions': suggestions,
      'Created_by': null,
    }));
//     debugPrint('insertStudentProfile ${response.body}');
    if (response.statusCode == 200) {
      return StudentInfoResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      return StudentInfoResponse(
          success: response.statusCode, data: StudentInfoMessage(msg: ''));
    }
  }

  @override
  Future<GeneralResponse> insertReportAccess(ReportAccessModel data) async {
    final response = await http.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/InsertReportAccess'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode(data),
    );

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
}
