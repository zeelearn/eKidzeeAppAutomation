import 'package:ekidzee/pages/pentemind/module/dailyactivity/v2/student_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/response/pentemind/dailyactivity/activityresponse.dart';
import 'da_student_remark_controller.dart';

class DAStudentRemarkScreenv2 extends StatelessWidget {

  final controller = Get.put(DAStudentRemarkController());

  final DailyActivityModel model;
  final int day;
  final String type;

  DAStudentRemarkScreenv2({
    super.key,
    required this.model,
    required this.day,
    required this.type,
  }) {
    controller.initialize(
      activityModel: model,
      selectedDay: day,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {

    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(model.Worksheet)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [

            /// Select All
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.isSelectAll.value,
                  onChanged: (v) =>
                      controller.toggleSelectAll(v ?? false),
                )),
                const Text("Select All")
              ],
            ),

            /// Student List
            Expanded(
              child: ListView.builder(
                itemCount: controller.studentList.length,
                itemBuilder: (context, index) {
                  return StudentRowWidget(
                    index: index,
                    isTablet: isTablet,
                  );
                },
              ),
            ),

            /// Submit Button
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitFeedback,
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator()
                      : const Text("Submit"),
                )),
              ),
            )
          ],
        );
      }),
    );
  }
}
