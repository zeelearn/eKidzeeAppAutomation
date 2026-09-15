import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:saathi/core/utility/utils.dart' as saathiutils;

import '../../../../constants.dart';
import '../../../../widget/MyWidget.dart';
import '../../../k12/data/models/get_homework_model.dart';
import 'add_new_homework_controller.dart';

class AddNewHomeworkScreen extends StatelessWidget {
  final String userType, username, userId, sectionId;
  final List<Subject> listOfSubject;
  final Homework? homework;

  const AddNewHomeworkScreen({
    required this.userType,
    required this.username,
    required this.sectionId,
    required this.listOfSubject,
    required this.userId,
    this.homework,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AddNewHomeworkController controller = Get.put(AddNewHomeworkController(
      userType: userType,
      username: username,
      sectionId: sectionId,
      userId: userId,
      listOfSubject: listOfSubject,
      homework: homework,
    ));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: controller.dataChanged.value);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            controller.homework == null ? 'Add New Homework' : 'Update Homework',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: kPrimaryLightColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Class Details'),
                      const SizedBox(height: 12),
                      _buildDropdownRow<Subject>(
                        label: 'Subject',
                        hint: 'Select Subject',
                        value: controller.subjectSelectedValue.value,
                        items: listOfSubject,
                        getLabel: (s) => s.subjectName!,
                        onChanged: controller.onSubjectChanged,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownRow<Chapter>(
                        label: 'Chapter',
                        hint: 'Select Chapter',
                        value: controller.chapterSelectedValue.value,
                        items: controller.listOfChapter,
                        getLabel: (c) => c.chapterName!,
                        onChanged: controller.onChapterChanged,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Homework Content'),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: controller.messageTextController,
                          maxLines: 4,
                          maxLength: 500,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Enter homework instructions or details...',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            counterStyle: GoogleFonts.poppins(fontSize: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Attachment'),
                      const SizedBox(height: 12),
                      _buildAttachmentSection(context, controller),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Scheduling'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              context,
                              'Assign Date',
                              controller.assigndateTextController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker(
                              context,
                              'Submission Date',
                              controller.submissiondateTextController,
                              minDate: controller.assigndateTextController.text.isEmpty 
                                  ? DateTime.now() 
                                  : DateTime.parse(controller.assigndateTextController.text),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildActionButtons(controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: kPrimaryLightColor,
      ),
    );
  }

  Widget _buildDropdownRow<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(hint, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(getLabel(item), style: GoogleFonts.poppins(fontSize: 13)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection(BuildContext context, AddNewHomeworkController controller) {
    if (controller.selectedImageUrl.value.isEmpty) {
      return InkWell(
        onTap: controller.uploadFile,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[100]!, width: 1, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined, color: Colors.blue[400], size: 32),
              const SizedBox(height: 8),
              Text('Upload Attachment', style: GoogleFonts.poppins(color: Colors.blue[700], fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 4),
              Text('PDF or Images (Max 20MB)', style: GoogleFonts.poppins(color: Colors.blue[300], fontSize: 11)),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        InkWell(
          onTap: () => octaveUtil.Utils.onFileTapKidzee(
            context,
            'Attachment',
            controller.selectedImageUrl.value,
            '',
            false,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    saathiutils.getAttachmentIcon(controller.selectedImageUrl.value),
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uploaded File',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Tap to view file',
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.visibility_outlined, color: Colors.grey[400], size: 20),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        Positioned(
          right: -8,
          top: -8,
          child: IconButton(
            icon: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red[400],
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
            onPressed: () => controller.selectedImageUrl.value = '',
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, TextEditingController textController, {DateTime? minDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 6),
        MyWidget().getDateTimePicker(
          context,
          label,
          textController,
          minDate ?? DateTime.now().subtract(const Duration(days: 30)),
          DateTime.now().add(const Duration(days: 60)),
          prefixIconColor: kPrimaryLightColor,
        ),
      ],
    );
  }

  Widget _buildActionButtons(AddNewHomeworkController controller) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.crudHomework,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryLightColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              controller.homework == null ? 'Assign Homework' : 'Update Homework',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: controller.clear,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
