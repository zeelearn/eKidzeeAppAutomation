import 'package:either_dart/src/either.dart';
import 'package:ekidzee/pages/k12/data/data_sources/apiprovider.dart';
import 'package:ekidzee/pages/k12/data/models/crud_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_student_model.dart';
import 'package:ekidzee/pages/k12/data/models/insert_daily_student_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/update_daily_homework_model.dart';
import 'package:ekidzee/pages/k12/domain/repositories/homework_repository.dart';

import '../../../../helper/LocalStrings.dart';

class HomeworkRepositoryImpl extends HomeworkRepository {
  @override
  Future<Either<String, dynamic>> crudHomework(
      {required CrudHomeworkModel crudHomeworkModel}) {
    return ApiProvider.request(
        LocalStrings.kesBaseUrl + LocalStrings.API_CRUDHOMEWORK,
        body: crudHomeworkModel.toMapApi(),
        method: HttpMethod.post);
  }

  @override
  Future<Either<String, dynamic>> getHomework(
      {required GetHomeworkModel getHomeworkModel}) {
    return ApiProvider.request(
      LocalStrings.kesBaseUrl + LocalStrings.API_GET_GETHOMEWORK,
      body: getHomeworkModel.toMapApi(),
      method: HttpMethod.post,
    );
  }

  @override
  Future<Either<String, dynamic>> getHomeworkStudentList(
      {required GetHomeworkStudentModel getHomeworkStudentModel}) {
    return ApiProvider.request(
      LocalStrings.kesBaseUrl + LocalStrings.API_GET_GETHOMEWORK_STUDENTLIST,
      body: getHomeworkStudentModel.toMapApi(),
      method: HttpMethod.post,
    );
  }

  @override
  Future<Either<String, dynamic>> insertStudentDailyHomework(
      {required InsertDailyStudentHomeworkModel
          insertDailyStudentHomeworkModel}) {
    return ApiProvider.request(
        LocalStrings.kesBaseUrl +
            LocalStrings.API_GET_INSERTSTUDENTDAILYHOMEWORK,
        body: insertDailyStudentHomeworkModel.toMapApi(),
        method: HttpMethod.post);
  }

  @override
  Future<Either<String, dynamic>> updateDailyHomeworkCorrection(
      {required UpdateDailyHomeworkModel updateDailyHomeworkModel}) {
    return ApiProvider.request(
        LocalStrings.kesBaseUrl +
            LocalStrings.API_GET_UPDATESTUDENTDAILYHOMEWORK,
        body: updateDailyHomeworkModel.toMapApi(),
        method: HttpMethod.post);
  }
}
