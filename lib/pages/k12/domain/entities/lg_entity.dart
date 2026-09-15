// lib/domain/entities/ppan.dart
class Ppan {
  final int ppanId;
  final int ppan;
  final String? guidelineUrl;

  Ppan({
    required this.ppanId,
    required this.ppan,
    this.guidelineUrl,
  });
}

// lib/domain/entities/phase.dart
class Phase {
  final int phId;
  final String phase;
  final List<Ppan> ppan;

  Phase({
    required this.phId,
    required this.phase,
    required this.ppan,
  });
}

// lib/domain/entities/subject.dart
class Subject {
  final int subjectId;
  final String subjectName;
  final List<Phase> phase;

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.phase,
  });
}

// lib/domain/entities/class_info.dart
class ClassInfo {
  final int classId;

  final int sectionId;
  final String className;
  final List<Subject> subject;

  ClassInfo({
    required this.classId,
    required this.className,
    required this.subject,required this.sectionId
  });
}
