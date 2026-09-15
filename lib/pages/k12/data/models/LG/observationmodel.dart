// lib/data/models/competency_model.dart


import 'package:ekidzee/pages/k12/domain/entities/learninggoal/observations.dart';

class KESLGModel extends KESLearningGoalObservations {
  KESLGModel({
    required int ccId,
    required String domainName,
    required String curricularGoalName,
    required String competenciesName,
    required String criteria,
    required int bg,
    required int pg,
    required int pf,
    required int na,
  }) : super(
          ccId: ccId,
          domainName: domainName,
          curricularGoalName: curricularGoalName,
          competenciesName: competenciesName,
          criteria: criteria,
          bg: bg,
          pg: pg,
          pf: pf,
          na: na,
        );

  factory KESLGModel.fromJson(Map<String, dynamic> json) {
    return KESLGModel(
      ccId: json['cc_id'],
      domainName: json['domain_name'],
      curricularGoalName: json['curricular_goal_name'],
      competenciesName: json['competencies_name'],
      criteria: json['criteria'],
      bg: json['BG'],
      pg: json['PG'],
      pf: json['PF'],
      na: json['NA'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cc_id': ccId,
      'domain_name': domainName,
      'curricular_goal_name': curricularGoalName,
      'competencies_name': competenciesName,
      'criteria': criteria,
      'BG': bg,
      'PG': pg,
      'PF': pf,
      'NA': na,
    };
  }
}
