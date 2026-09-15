class ReportPhase {
  final String phaseId;
  final String phaseName;
  final String shortName;
  final String value;

  ReportPhase({
    required this.phaseId,
    required this.phaseName,
    required this.shortName,
    required this.value,
  });

  factory ReportPhase.fromJson(Map<String, dynamic> json) {
    return ReportPhase(
      phaseId: json['phase_id'],
      phaseName: json['phase_name'],
      shortName: json['shortname'],
      value: json['value'],
    );
  }
}
