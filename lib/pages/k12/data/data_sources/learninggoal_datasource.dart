import 'dart:convert';

import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';
import 'package:hive_flutter/adapters.dart';

class LearninggoalRemoteDatasource {
  String key = "lg";
  String keyTimeTable = "lgd";

  // Future<List<KESLearningGoalObservations>> fetchCompetencies({
  //   required int classId,
  //   required int subjectId,
  //   required int phId,
  //   required int ppanId,
  //   required int sectionId,
  // });

  Future<List<LogbookTimeTableModel>> fetchOfflineTimeTable(String date) async {
//     debugPrint('offline timeTable');
    var box = await Hive.openBox(LocalConstant.KesKey);
    if (box.containsKey('${keyTimeTable}_$date')) {
//      final data = jsonDecode(response.body)['data'];
      final data = jsonDecode(box.get('${keyTimeTable}_$date'))['data'];
//       debugPrint('data is $data');
      return List<LogbookTimeTableModel>.from(
          data.map((item) => LogbookTimeTableModel.fromJson(item)));
    } else {
      return [];
    }
  }

  saveTimeTable(String date, String data) async {
//     debugPrint('save timetable ....');
    // debugPrint(data);
    var box = await Hive.openBox(LocalConstant.KesKey);
    box.put('${keyTimeTable}_$date', data);
  }

  Future<LogbookEntity> getOfflineLogbook(int classId, int subjectId) async {
    var box = await Hive.openBox(LocalConstant.KesKey);
    if (box.containsKey('${key}_${classId}_$subjectId')) {
      final logbookModel = KESLogbookModel.fromJson(
          json.decode(box.get('${key}_${classId}_$subjectId')));
      // Convert LogbookModel to LogbookEntity if needed
      return logbookModel.toEntity();
    } else {
      return LogbookEntity(academic: []);
    }
  }

  saveOfflineLogbook(int classId, int subjectId, String data) async {
    var box = await Hive.openBox(LocalConstant.KesKey);
    box.put('${key}_${classId}_$subjectId', data);
  }
}
