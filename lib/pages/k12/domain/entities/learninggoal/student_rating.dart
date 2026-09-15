import 'package:ekidzee/pages/k12/data/models/LG/student_rating_model.dart';

class StudentRating {
  final int teacherId;
  final String userName;
  final int sectionId;
  final List<RatingData> inputData;

  StudentRating({
    required this.teacherId,
    required this.userName,
    required this.sectionId,
    required this.inputData,
  });
}

