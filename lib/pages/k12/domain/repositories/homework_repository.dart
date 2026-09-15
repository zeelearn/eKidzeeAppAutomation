import 'package:either_dart/either.dart';
import 'package:ekidzee/pages/k12/data/models/crud_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_student_model.dart';
import 'package:ekidzee/pages/k12/data/models/insert_daily_student_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/update_daily_homework_model.dart';

abstract class HomeworkRepository {
  Future<Either<String, dynamic>> getHomework(
      {required GetHomeworkModel getHomeworkModel});

  Future<Either<String, dynamic>> crudHomework(
      {required CrudHomeworkModel crudHomeworkModel});

  Future<Either<String, dynamic>> getHomeworkStudentList(
      {required GetHomeworkStudentModel getHomeworkStudentModel});

  Future<Either<String, dynamic>> insertStudentDailyHomework(
      {required InsertDailyStudentHomeworkModel
          insertDailyStudentHomeworkModel});

  Future<Either<String, dynamic>> updateDailyHomeworkCorrection(
      {required UpdateDailyHomeworkModel updateDailyHomeworkModel});
}
