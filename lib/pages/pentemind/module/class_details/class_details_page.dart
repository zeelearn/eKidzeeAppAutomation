import 'package:ekidzee/helpers/image_helper.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'class_details_controller.dart';

class ClassDetailsPage extends StatelessWidget {
  final int franchiseeId;
  final int programId;

  const ClassDetailsPage({
    super.key,
    required this.franchiseeId,
    required this.programId,
  });

  @override
  Widget build(BuildContext context) {
    /// Dependency Injection (Controller)
    final ClassDetailsController controller = Get.put(
      ClassDetailsController(
        franchiseeId: franchiseeId,
        programId: programId,
        //apiService: ClassDetailsApiService(),
      ),
      tag: '$franchiseeId-$programId',
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(title: const Text('Class Details')),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: Get.width > 600 ? 500 : double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //_dropdown(controller),
                        SizedBox(
                          height: kDefaultFontSize,
                        ),
                        Text(
                          'Franchisee Code',
                          // controller.franchiseCode,
                          // readOnly: true,
                        ),
                        Text(
                          controller.franchiseCode.string,
                          // controller.franchiseCode,
                          // readOnly: true,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                'Class Facilitator',
                                controller.classFacilitator,
                                filledColor: Colors.green.shade50,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                'Center Head / Principal',
                                controller.centerHead,
                                filledColor: Colors.red.shade50,
                              ),
                            ),
                          ],
                        ),
                        _photoSection(controller),
                        const SizedBox(height: 20),
                        _submitButton(controller),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // Widget _dropdown(ClassDetailsController controller) {
  //   return DropdownButtonFormField<String>(
  //     value: controller.selectedYear.value,
  //     items: const [
  //       DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
  //       DropdownMenuItem(value: '2026-2027', child: Text('2026-2027')),
  //     ],
  //     onChanged: (v) => controller.updateSelectedYear( v=='2024-2025' ? '2025' : '2026'),
  //     decoration: const InputDecoration(labelText: 'Select Year'),
  //   );
  // }

  Widget _textField(String label, RxString value,
      {bool readOnly = false, Color? filledColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        initialValue: value.value,
        readOnly: readOnly,
        onChanged: (v) => value.value = v,
        decoration: InputDecoration(
          labelText: label,
          filled: filledColor != null,
          fillColor: filledColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _photoSection(ClassDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Class Photo'),
              IconButton(
                  onPressed: controller.pickNewImage,
                  icon: const Icon(Icons.camera_alt, size: 28))
            ],
          ),
          //const Text('Class Photo'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.onImageAction,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(() {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: buildImageWidgetFromPathOrData(
                    path: controller.classPhotoUrl.value,
                    imageData: controller.pickedImageData,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        const Center(child: Icon(Icons.camera_alt, size: 50)),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(ClassDetailsController controller) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: controller.submit,
        child: Text(
          'Submit',
          style: LightColors.textHeaderStyle13Selected,
        ),
      ),
    );
  }
}
