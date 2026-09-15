import 'package:ekidzee/api/response/pentemind/GenericResponse.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/reports/report_access_model.dart';
import 'package:ekidzee/pages/k12/data/models/reports/student_profile_response.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/kes_certificate.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/report_access_entity.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_list_lgreport.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_profile.dart';

abstract class ReportRepository {
  Future<List<ReportPhase>> getPhases(String classId, String sectionId);

  Future<List<StudentForLGReport>> getStudents(int sectionId, String userId, String reportName);

  Future<KESCertificate> fetchKesCertificate(int sectionId, int studentId, String phaseId, int isHtml);

  Future<StudentProfile> getStudentProfile(int studentId, int sectionId, String reportName);

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
  });

  Future<GeneralResponse> insertReportAccess(ReportAccessModel model);


  
}