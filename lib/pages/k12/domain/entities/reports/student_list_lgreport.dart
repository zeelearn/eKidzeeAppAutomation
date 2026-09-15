class StudentForLGReport {
  final int studentId;
  final String studentName;
  final int classId;
  final String className;
  final bool isSubmit;
  final bool isPublish;

  StudentForLGReport({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    required this.isSubmit,
    required this.isPublish,
  });

  factory StudentForLGReport.fromJson(Map<String, dynamic> json) {
    return StudentForLGReport(
      studentId: json['student_id'],
      studentName: json['Student_Name'],
      classId: json['Class_Id'],
      className: json['Class_Name'],
      isSubmit: json['IsSubmit'],
      isPublish: json['IsPublish'],
    );
  }
}
