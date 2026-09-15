import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';

class GetHomeworkEntity {
  final String sectionId;
  final String userId;
  final String username;

  int? success;
  Data? data;

  GetHomeworkEntity(
      {required this.sectionId, required this.userId, required this.username});
}
