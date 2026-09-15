// lib/domain/entities/competency.dart
class KESLearningGoalObservations {
  final int ccId;
  final String domainName;
  final String curricularGoalName;
  final String competenciesName;
  final String criteria;
  int bg;
  int pg;
  int pf;
  int na;

  KESLearningGoalObservations({
    required this.ccId,
    required this.domainName,
    required this.curricularGoalName,
    required this.competenciesName,
    required this.criteria,
    required this.bg,
    required this.pg,
    required this.pf,
    required this.na,
  });
}
