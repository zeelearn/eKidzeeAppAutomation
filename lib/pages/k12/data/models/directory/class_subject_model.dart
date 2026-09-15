import 'package:equatable/equatable.dart';

class ClassSubjectMasterModel {
  int? success;
  List<ClassSubjectModel>? data;

  ClassSubjectMasterModel({this.success, this.data});

  ClassSubjectMasterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <ClassSubjectModel>[];
      json['data'].forEach((v) {
        try {
          data!.add(ClassSubjectModel.fromJson(v));
        } catch (e) {
          // debugPrint(e.toString());
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      //data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassSubjectModel extends Equatable {
  final int classId;
  final String className;
  final List<SubjectModel> subjectData;

  const ClassSubjectModel({
    required this.classId,
    required this.className,
    required this.subjectData,
  });

  factory ClassSubjectModel.fromJson(Map<String, dynamic> json) {
    var subjectList = (json['subjectdata'] as List)
        .map((subject) => SubjectModel.fromJson(subject))
        .toList();

    return ClassSubjectModel(
      classId: json['class_id'],
      className: json['class_name'],
      subjectData: subjectList,
    );
  }

  @override
  List<Object?> get props => [classId, className, subjectData];
}

class SubjectModel extends Equatable {
  final int subjectId;
  final String subjectName;
  final int classId;

  const SubjectModel({
    required this.subjectId,
    required this.subjectName,
    required this.classId,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'].trim(),
      classId: json['class_id'],
    );
  }

  @override
  List<Object?> get props => [subjectId, subjectName, classId];
}
