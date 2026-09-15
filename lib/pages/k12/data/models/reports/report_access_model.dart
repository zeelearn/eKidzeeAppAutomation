class ReportAccessModel {
  final String teacherId;
  final int studentId;
  final String sectionId;
  final String reportName;
  final int isSubmit;
  final int isPublish;
  final String createdBy;

  ReportAccessModel({
    required this.teacherId,
    required this.studentId,
    required this.sectionId,
    required this.reportName,
    required this.isSubmit,
    required this.isPublish,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "Teacher_Id": teacherId,
      "Student_Id": studentId,
      "Section_id": sectionId,
      "ReportName": reportName,
      "IsSubmit": isSubmit,
      "IsPublish": isPublish,
      "CreatedBy": createdBy,
    };
  }
}
