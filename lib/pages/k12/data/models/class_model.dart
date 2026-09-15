class ClassModel {
  final int classId;
  final String className;
  final List<SubjectModel> subjects;

  ClassModel({
    required this.classId,
    required this.className,
    required this.subjects,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['class_id'],
      className: json['class_name'],
      subjects: (json['subject'] as List)
          .map((e) => SubjectModel.fromJson(e))
          .toList(),
    );
  }
}

class SubjectModel {
  final int subjectId;
  final String subjectName;
  final List<PhaseModel> phases;

  SubjectModel({
    required this.subjectId,
    required this.subjectName,
    required this.phases,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      phases: (json['phase'] as List)
          .map((e) => PhaseModel.fromJson(e))
          .toList(),
    );
  }
}

class PhaseModel {
  final int phId;
  final String phase;
  final List<PpanModel> ppans;

  PhaseModel({
    required this.phId,
    required this.phase,
    required this.ppans,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      phId: json['ph_id'],
      phase: json['phase'],
      ppans: (json['ppan'] as List)
          .map((e) => PpanModel.fromJson(e))
          .toList(),
    );
  }
}

class PpanModel {
  final int ppanId;
  final int ppan;
  final String? guidelineUrl;

  PpanModel({
    required this.ppanId,
    required this.ppan,
    this.guidelineUrl,
  });

  factory PpanModel.fromJson(Map<String, dynamic> json) {
    return PpanModel(
      ppanId: json['ppan_id'],
      ppan: json['ppan'],
      guidelineUrl: json['Guidelineurl'],
    );
  }
}
