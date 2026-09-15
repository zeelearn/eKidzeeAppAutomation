

import 'package:ekidzee/pages/k12/domain/entities/reports/student_profile.dart';

class StudentProfileModel extends StudentProfile {
  StudentProfileModel({
    required int learnerId,
    required int teacherId,
    required int studentId,
    required int sectionId,
    required String reportName,
    required String learnerIs,
    required String learnerStrengths,
    required String learnerChallenges,
    required String suggestions,
    required int outOfDay,
    required int totalDay,
    required bool isActive,
    required String createdBy,
    required String createdDate,
  }) : super(
    learnerId: learnerId,
    teacherId: teacherId,
    studentId: studentId,
    sectionId: sectionId,
    reportName: reportName,
    learnerIs: learnerIs,
    learnerStrengths: learnerStrengths,
    learnerChallenges: learnerChallenges,
    suggestions: suggestions,
    outOfDay: outOfDay,
    totalDay: totalDay,
    isActive: isActive,
    createdBy: createdBy,
    createdDate: createdDate,
  );

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      learnerId: json['Learner_Id'] ?? 0 ,
      teacherId: json['Teacher_Id'] ?? 0,
      studentId: json['Student_Id'] ?? 0,
      sectionId: json['Section_id'] ?? 0, 
      reportName: json['Report_Name'] ?? '',
      learnerIs: json['LearnerIs'] ?? '',
      learnerStrengths: json['Learner_Strengths'] ?? '',
      learnerChallenges: json['Learner_Challenges'] ?? '',
      suggestions: json['Suggestions'] ?? '',
      outOfDay: json['OutOFDay'] ?? 0,
      totalDay: json['TotalDay'] ?? 0,
      isActive: json['IsActive'] ?? false,
      createdBy: json['Created_by'] ?? '',
      createdDate: json['Craeted_date'] ?? '',
    );
  }
}
