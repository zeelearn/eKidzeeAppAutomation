import 'package:ekidzee/api/response/pentemind/reports/get_reports.dart';
import 'package:flutter/material.dart';

import '../../../../utils/theme/colors/light_colors.dart';

class Reportdatasource extends DataTableSource {
  final List<dynamic> _data = [];

  void setData(List<dynamic> newData) {
    _data.clear();
    _data.addAll(newData);
    notifyListeners(); // Refresh table
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final row = _data[index];
    return DataRow.byIndex(
      index: index,
      color: WidgetStateColor.resolveWith(
        (states) => Colors.white,
      ),
      cells: [
        DataCell(allText(row.ClassName)),
        DataCell(allText(row.CulminationName)),
        if (_data.first is ReportModel) ...[
          DataCell(allText(row.SessionName)),
          DataCell(allText(row.DomainName)),
          DataCell(allText(row.SkillName)),
          DataCell(allText(row.LearningGoals)),
          DataCell(allText(row.StudentName)),
          DataCell(allText(row.TeacherName)),
          DataCell(allText(row.Rating)),
          DataCell(allText(row.ObservationType)),
          DataCell(allText(row.OnDay.toString())),
        ] else ...[
          DataCell(allText(row.TeacherName)),
          DataCell(allText(row.SessionName)),
          DataCell(allText(row.Topic)),
          DataCell(allText(row.BroadFlowActivity)),
          DataCell(allText(row.KitMaterial)),
          DataCell(allText(row.OtherMaterial)),
          DataCell(allText(row.LearningOutcome)),
          DataCell(allText(row.Worksheet)),
          DataCell(allText(row.Observations)),
          DataCell(allText(row.StatusCode)),
          DataCell(allText(
            row.Remarks,
          )),
          DataCell(allText(row.CreatedDate)),
        ]
      ],
    );
  }

  Text allText(String value) => Text(
        value,
        style: LightColors.textvSmallStyle,
      );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
