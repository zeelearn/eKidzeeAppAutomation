// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';

part 'StatusModel.g.dart';

@HiveType(typeId: 11)
class StatusModel extends HiveObject {
  @HiveField(0)
  final int programID;

  @HiveField(1)
  final String classID;

  @HiveField(2)
  final int day;

  @HiveField(3)
  final bool logbookStatus;

  @HiveField(4)
  final String className;

  StatusModel(
      {required this.programID,
      required this.classID,
      required this.day,
      required this.logbookStatus,
      required this.className});
}
