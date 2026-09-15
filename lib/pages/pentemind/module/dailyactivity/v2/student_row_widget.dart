import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/response/pentemind/dailyactivity/student_list.dart';
import 'da_student_remark_controller.dart';

class StudentRowWidget extends StatelessWidget {

  final int index;
  final bool isTablet;

  StudentRowWidget({
    required this.index,
    required this.isTablet,
  });

  final controller = Get.find<DAStudentRemarkController>();

  @override
  Widget build(BuildContext context) {

    final student = controller.studentList[index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: isTablet
            ? _buildTabletLayout(student)
            : _buildMobileLayout(student),
      ),
    );
  }

  Widget _buildMobileLayout(DAStudentInfo student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(student.StudentName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildRadioGroup(student),
      ],
    );
  }

  Widget _buildTabletLayout(DAStudentInfo student) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(student.StudentName,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        _buildRadioGroup(student),
      ],
    );
  }

  Widget _buildRadioGroup(DAStudentInfo student) {
    return Obx(() => Row(
      children: [
        Radio<String>(
          value: 'C',
          groupValue:
          controller.selectedStatus[index],
          onChanged: (v) =>
              controller.updateStudentStatus(index, v!),
        ),
        const Text("C"),
        Radio<String>(
          value: 'NC',
          groupValue:
          controller.selectedStatus[index],
          onChanged: (v) =>
              controller.updateStudentStatus(index, v!),
        ),
        const Text("NC"),
      ],
    ));
  }
}
