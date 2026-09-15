import 'package:ekidzee/pages/k12/domain/entities/update_daily_homework_entity.dart';

class UpdateDailyHomeworkModel extends UpdateDailyHomeworkEntity {
  UpdateDailyHomeworkModel(
      {required super.username,
      required super.businessId,
      required super.sectionId,
      required super.homeworkId,
      required super.inputData});

  Map<String, dynamic> toMapApi() {
    return {
      'username': username,
      'business_id': businessId,
      'section_id': sectionId,
      'homework_id': homeworkId,
      'inputdata': inputData.map((v) => v.toJson()).toList(),
    };
  }
}
