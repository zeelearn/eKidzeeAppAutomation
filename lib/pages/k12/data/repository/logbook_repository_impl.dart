import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/data_sources/learninggoal_datasource.dart';
import 'package:ekidzee/pages/k12/data/data_sources/logbook/logbook_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model_get.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';

class LogbookRepository {
  final LogbookRemoteDataSource remoteDataSource;

  LogbookRepository(this.remoteDataSource);

  Future<LogbookEntity> getLogbook(
      int classId, int subjectId, String userName, int franchiseeId) async {
    if (await Utility.isInternet()) {
      try {
        final logbookModel = await remoteDataSource.getLogbook(
            classId, subjectId, userName, franchiseeId);
        // Convert LogbookModel to LogbookEntity if needed
        return logbookModel.toEntity();
      } catch (e) {
        return LearninggoalRemoteDatasource()
            .getOfflineLogbook(classId, subjectId);
      }
    } else {
      return LearninggoalRemoteDatasource()
          .getOfflineLogbook(classId, subjectId);
    }
  }

  @override
  Future<GeneralResponse> saveTeacherLogbook(
      TeacherLogbookModel logbook) async {
    return await remoteDataSource.insertTeacherLogbook(logbook.toJson());
  }

  Future<List<LogbookTimeTableModel>> fetchTimeTable(
      String username, String date) async {
//     debugPrint('in 37   get TimeTable-----------------');
    if (await Utility.isInternet()) {
      try {
        return remoteDataSource.getTimetable(username, date);
      } catch (e) {
//         debugPrint('error found in 41');
        return LearninggoalRemoteDatasource().fetchOfflineTimeTable(date);
      }
    } else {
      return LearninggoalRemoteDatasource().fetchOfflineTimeTable(date);
    }
  }

  Future<GetTeacherLogbookModel> getTeacherLogbook(String userName,
      int businessId, String date, int periodId, int sectionId) {
    return remoteDataSource.getTeacherLogbook(
        userName, businessId, date, periodId, sectionId);
  }
}
