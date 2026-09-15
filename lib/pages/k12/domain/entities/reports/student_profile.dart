class StudentProfile {
  final int learnerId;
  final int teacherId;
  final int studentId;
  final int sectionId;
  final String reportName;
  final String learnerIs;
  final String learnerStrengths;
  final String learnerChallenges;
  final String suggestions;
  final int outOfDay;
  final int totalDay;
  final bool isActive;
  final String createdBy;
  final String createdDate;

  StudentProfile({
    required this.learnerId,
    required this.teacherId,
    required this.studentId,
    required this.sectionId,
    required this.reportName,
    required this.learnerIs,
    required this.learnerStrengths,
    required this.learnerChallenges,
    required this.suggestions,
    required this.outOfDay,
    required this.totalDay,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
  });
}
