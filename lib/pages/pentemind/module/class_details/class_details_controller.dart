import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/widget/image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api/class_details_api_service.dart';
import '../../../../api/request/interceptor.dart';
import '../../../../helper/KidzeePref.dart';
import '../../../../model/user_model.dart';

class ClassDetailsController extends GetxController {
  final int franchiseeId;
  final int programId;

  ClassDetailsController({
    required this.franchiseeId,
    required this.programId,
  });

  final ClassDetailsApiService apiService = ClassDetailsApiService();
  static final http = InterceptedClient();

  final isLoading = false.obs;
  final selectedYear = RxnString();

  final franchiseCode = ''.obs;
  final classFacilitator = ''.obs;
  final centerHead = ''.obs;
  final classPhotoUrl = ''.obs;
  String userId = '';

  int infoId = 0;
  XFile? pickedFile;
  Uint8List? pickedImageData;

  @override
  void onInit() {
    super.onInit();

    fetchClassDetails();
  }

  Future<void> fetchClassDetails() async {
    try {
      int academicYear = await KidzeePref().getAcademicYear();
      final LoginData? response = await KidzeePref().getLoginResponse();
      userId = response!.userId!;
      debugPrint('getAcademic Year $academicYear');
      selectedYear.value = '20$academicYear';
      debugPrint('Selected Year ${selectedYear.value}');
      isLoading.value = true;

      final data = await apiService.fetchClassInfo(
          franchiseeId: franchiseeId,
          programId: programId,
          yearId: selectedYear.value!);

      if (data != null) {
        infoId = data.infoId;
        franchiseCode.value = data.franchiseeCode;
        classFacilitator.value = data.classFacilitator;
        centerHead.value = data.centerHead;
        classPhotoUrl.value = data.classPhoto;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> pickImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     selectedImage = File(picked.path);
  //     classPhotoUrl.value = picked.path;
  //   }
  // }

  /// MAIN ENTRY POINT (called from UI)
  Future<void> onImageAction() async {
    if (classPhotoUrl.value.isNotEmpty) {
      //_showImageOptions();
      _viewImageOrFile();
    } else {
      await pickNewImage();
    }
  }

  /// SHOW OPTIONS IF IMAGE EXISTS
  void _showImageOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Image / File'),
              onTap: () {
                Get.back();
                _viewImageOrFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload New'),
              onTap: () async {
                Get.back();
                await pickNewImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// PICK IMAGE (GALLERY)
  Future<void> pickNewImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      // Keep the XFile for uploading and also materialize bytes so
      // we can show a preview with `Image.memory` on web and mobile.
      pickedFile = picked;
      try {
        pickedImageData = await picked.readAsBytes();
      } catch (_) {
        pickedImageData = null;
      }
      // keep path for debugging / existing flows
      classPhotoUrl.value = picked.path;
      update();
    }
  }

  /// VIEW IMAGE / FILE
  Future<void> _viewImageOrFile() async {
    final path = classPhotoUrl.value;

    if (path.startsWith('http')) {
      final uri = Uri.parse(path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Unable to open file');
      }
    } else {
      // If we have picked image bytes (web or mobile), pass them to viewer
      if (pickedImageData != null) {
        Get.to(() => ImageViewer(imageData: pickedImageData, imageUrl: path));
      } else {
        Get.to(() => ImageViewer(imageUrl: path));
      }
    }
  }

  bool validateForm() {
    if (classFacilitator.value.isEmpty ||
        centerHead.value.isEmpty ||
        (classPhotoUrl.value.isEmpty && pickedImageData == null)) {
      Get.snackbar('Error', 'All fields are required');
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!validateForm()) return;

    isLoading.value = true;
    var imageUrl = classPhotoUrl.value;
    if (pickedFile != null) {
      var response =
          await apiService.uploadImage('0', pickedFile!, isVideoFile: false);
      imageUrl = response.imageModel![0].location;
    }

    final payload = {
      "InfoId": infoId,
      "franchisee_Id": franchiseeId,
      "Program_Id": programId,
      "classfacilitatorname": classFacilitator.value,
      "centerheadname": centerHead.value,
      "classphoto": imageUrl,
      "user_id": userId
    };

    // debugPrint(payload);
    final success = await apiService.submitClassDetails(payload);

    isLoading.value = false;

    fetchClassDetails();
    if (success) {
      Utility.showAlertDialog(Get.context!, 'Record updated successfully!');
      //Get.snackbar('Success', 'Record updated successfully!');
    } else {
      Utility.showAlertDialog(Get.context!, 'Something went wrong');
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
