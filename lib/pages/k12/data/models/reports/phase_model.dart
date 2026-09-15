import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';

class PhaseModel extends ReportPhase {
  PhaseModel({
    required String phaseId,
    required String phaseName,
    required String shortName,
    required String value,
  }) : super(
          phaseId: phaseId,
          phaseName: phaseName,
          shortName: shortName,
          value: value,
        );

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      phaseId: json['phase_id'],
      phaseName: json['phase_name'],
      shortName: json['shortname'],
      value: json['value'],
    );
  }
}
