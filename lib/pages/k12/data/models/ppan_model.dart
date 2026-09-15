// lib/data/models/ppan_model.dart

import 'package:ekidzee/pages/k12/domain/entities/lg_entity.dart';

class PpanModel extends Ppan {
  PpanModel({
    required super.ppanId,
    required super.ppan,
    super.guidelineUrl,
  });

  factory PpanModel.fromJson(Map<String, dynamic> json) {
    return PpanModel(
      ppanId: json['ppan_id'],
      ppan: json['ppan'],
      guidelineUrl: json['Guidelineurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ppan_id': ppanId,
      'ppan': ppan,
      'Guidelineurl': guidelineUrl,
    };
  }
}

// lib/data/models/phase_model.dart

class PhaseModel extends Phase {
  PhaseModel({
    required super.phId,
    required super.phase,
    required List<PpanModel> super.ppan,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    var list = json['ppan'] as List;
    List<PpanModel> ppanList = list.map((i) => PpanModel.fromJson(i)).toList();

    return PhaseModel(
      phId: json['ph_id'],
      phase: json['phase'],
      ppan: ppanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ph_id': phId,
      'phase': phase,
      'ppan': ppan.map((ppan) => (ppan as PpanModel).toJson()).toList(),
    };
  }
}

// lib/data/models/subject_model.dart

class SubjectModel extends Subject {
  SubjectModel({
    required super.subjectId,
    required super.subjectName,
    required List<PhaseModel> super.phase,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    var list = json['phase'] as List;
//     debugPrint('Parse SubjectModel');
    List<PhaseModel> phaseList =
        list.map((i) => PhaseModel.fromJson(i)).toList();
//     debugPrint('Parse PHASE');
    return SubjectModel(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      phase: phaseList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'phase': phase.map((phase) => (phase as PhaseModel).toJson()).toList(),
    };
  }
}

// lib/data/models/class_info_model.dart

class ClassInfoModel extends ClassInfo {
  ClassInfoModel(
      {required super.classId,
      required super.className,
      required List<SubjectModel> super.subject,
      required super.sectionId});

  factory ClassInfoModel.fromJson(Map<String, dynamic> json) {
    var list = json['subject'] as List;
//     debugPrint('Parse ClassInfoModel');
    List<SubjectModel> subjectList =
        list.map((i) => SubjectModel.fromJson(i)).toList();
//     debugPrint('subject list sorted');
    return ClassInfoModel(
      classId: json['class_id'],
      sectionId: json['section_id'],
      className: json['class_name'],
      subject: subjectList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'subject':
          subject.map((subject) => (subject as SubjectModel).toJson()).toList(),
    };
  }
}
