import '../api/response/pentemind/parent/myhomework.dart';

class HomeworkInfoModel {
  HomeworkInfoModel({
    required this.day,
    required this.isHomeworkPending,
    required this.homeworkList,
  });
  late final int day;
  late final bool isHomeworkPending;
  late final List<MyHomeworkModel> homeworkList;

}