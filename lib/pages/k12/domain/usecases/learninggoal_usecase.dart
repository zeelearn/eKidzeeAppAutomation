import 'package:ekidzee/pages/k12/data/models/LG/student_rating_model.dart';
import 'package:ekidzee/pages/k12/data/models/ppan_model.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/observations.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/student.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/student_rating.dart';
import 'package:ekidzee/pages/k12/domain/repositories/learninggoal_repository.dart';

class LearninggoalUsecase {
  final LearninggoalRepository repository;

  LearninggoalUsecase(this.repository);

  Future<ClassInfoModel> getLearningMasters(
      String className, int sectionId, String userId, String uname) {
    return repository.getLearningMasters(className, sectionId, userId, uname);
  }

  // Future<dynamic> get(int classId, int sectionId, int userId) {
  //   return repository.getLearningMasters(classId, sectionId, userId);
  // }

  Future<List<KESLearningGoalObservations>> getObservations({
    required int classId,
    required int subjectId,
    required int phId,
    required int ppanId,
    required int sectionId,
  }) {
    return repository.getObservations(
      classId: classId,
      subjectId: subjectId,
      phId: phId,
      ppanId: ppanId,
      sectionId: sectionId,
    );
  }

  Future<List<Student>> getCompetenciesStudentList(
      int ccId, int sectionId, String userName) async {
//     debugPrint('in 39==============');
    final response = await repository.getCompetenciesStudentList(
        ccId: ccId, sectionId: sectionId, userName: userName);
//     debugPrint('Student response ${response.success}');
    return response.data
        .map((model) => Student(
              studentId: model.studentId,
              studentName: model.studentName,
              classId: model.classId,
              className: model.className,
              rating: model.rating,
            ))
        .toList();
  }

  Future<Map<String, dynamic>> saveStudentRating(
      StudentRating studentRating) async {
    return await repository.saveStudentRating(
      StudentRatingModel(
        teacherId: studentRating.teacherId,
        userName: studentRating.userName,
        sectionId: studentRating.sectionId,
        inputData: studentRating.inputData
            .map((e) => RatingData(
                  ccId: e.ccId,
                  studentId: e.studentId,
                  rating: e.rating,
                ))
            .toList(),
      ),
    );
  }
}
