
import 'package:ekidzee/api/response/pentemind/GenericResponse.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/reports/report_access_model.dart';
import 'package:ekidzee/pages/k12/data/models/reports/student_profile_response.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/kes_certificate.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/report_access_entity.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_list_lgreport.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_profile.dart';
import 'package:ekidzee/pages/k12/domain/repositories/report_repository.dart';

class ReportsUsecase {
  final ReportRepository repository;

  ReportsUsecase(this.repository);

  Future<List<ReportPhase>> getPhases(String classId, String sectionId) {
    return repository.getPhases(classId, sectionId);
  }

  Future<List<StudentForLGReport>> call(int sectionId, String userId, String reportName) {
    return repository.getStudents(sectionId, userId, reportName);
  }

  Future<KESCertificate> getKesCertificate(int sectionId, int studentId, String phaseId, int isHtml) {
    return repository.fetchKesCertificate(sectionId, studentId, phaseId, isHtml);
  }

  @override
  Future<StudentProfile> getStudentProfile(int studentId, int sectionId, String reportName) async {
    return await repository.getStudentProfile(studentId, sectionId, reportName);
  }

   @override
  Future<StudentInfoResponse> insertStudentProfile(String userName,int studentId,int sectionId,String reportName,
  int totalDays,int outOfDays,String learnerIs,String learnerStrengths,String learnerChallenges,
  String suggestions,int createdBy
  ) async {
    return await repository.insertStudentProfile(
      userName: userName,
      studentId: studentId,
      sectionId: sectionId,
      reportName: reportName,
      totalDays: totalDays,
      outOfDays: outOfDays,
      learnerIs: learnerIs,
      learnerStrengths: learnerStrengths,
      learnerChallenges: learnerChallenges,
      suggestions: suggestions,
      createdBy: createdBy,
    );
  }

   Future<GeneralResponse> insertReportAccess(ReportAccessModel model) async {
    final response = await repository.insertReportAccess(model);
    return response;
  }
}
