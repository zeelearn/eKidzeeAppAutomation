import 'package:ekidzee/pages/k12/data/models/LG/studentModel.dart';
import 'package:ekidzee/pages/k12/data/models/LG/student_rating_model.dart';
import 'package:ekidzee/pages/k12/data/models/ppan_model.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/observations.dart';

abstract class LearninggoalRepository {

  Future<ClassInfoModel> getLearningMasters(String classId, int sectionId, String userId,String userName);

  Future<List<KESLearningGoalObservations>> getObservations({
    required int classId,
    required int subjectId,
    required int phId,
    required int ppanId,
    required int sectionId
  });
  
  Future<StudentsResponse> getCompetenciesStudentList({
    required int ccId, required int sectionId, required String userName
  });


    Future<Map<String, dynamic>> saveStudentRating(StudentRatingModel studentRatingModel);


  
}