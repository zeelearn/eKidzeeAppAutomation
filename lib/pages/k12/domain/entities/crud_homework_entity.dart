import '../../data/models/crud_homework_model.dart';

class CrudHomeworkEntity {
  final int homeworkId;
  final String sectionId;
  final String subjectId;
  final String chapterId;
  final String? userId;
  final String message;
  final String fileUrl;
  final String assignDate;
  final String submissionDate;
  final bool isPublish;
  final String createdBy;
  final String username;

  int? success;
  Data? data;

  CrudHomeworkEntity(
      {required this.homeworkId,
      required this.sectionId,
      required this.subjectId,
      required this.chapterId,
      this.userId,
      required this.message,
      required this.fileUrl,
      required this.assignDate,
      required this.submissionDate,
      required this.isPublish,
      required this.createdBy,
      required this.username});
}
