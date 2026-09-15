import 'package:hive_flutter/adapters.dart';

part 'survey_model.g.dart';

@HiveType(typeId: 10)
class SurveyModel {
  @HiveField(0)
  String survey_id;
  @HiveField(1)
  bool completed;
  @HiveField(2)
  String? completed_date;
  @HiveField(3)
  String? survey_json;
  @HiveField(4)
  String userId;

  SurveyModel(
      {required this.survey_id,
      required this.completed,
      this.survey_json,
      this.completed_date,
      required this.userId});
}
