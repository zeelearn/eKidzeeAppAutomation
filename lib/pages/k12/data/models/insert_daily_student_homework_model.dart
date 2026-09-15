import 'package:ekidzee/pages/k12/domain/entities/insert_daily_student_homework_entity.dart';

class InsertDailyStudentHomeworkModel extends InsertDailyStudentHomeworkEntity {
  InsertDailyStudentHomeworkModel(
      {required super.sectionId,
      required super.inputData,
      required super.studentId,
      required super.businessId,
      required super.username});

  Map<String, dynamic> toMapApi() {
    return {
      'section_id': sectionId,
      'inputdata': inputData.map((v) => v.toJson()).toList(),
      'student_id': studentId,
      'business_id': businessId,
      'username': username,
    };
  }
}
