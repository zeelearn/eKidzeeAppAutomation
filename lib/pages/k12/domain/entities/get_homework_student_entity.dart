import '../../data/models/get_homework_student_model.dart';

class GetHomeworkStudentEntity {
  int sectionID;
  String username;
  int homeworkID;
  int businessID;
  int? success;
  List<Data>? data;
  GetHomeworkStudentEntity({
    required this.sectionID,
    required this.username,
    required this.homeworkID,
    required this.businessID,
  });
}
