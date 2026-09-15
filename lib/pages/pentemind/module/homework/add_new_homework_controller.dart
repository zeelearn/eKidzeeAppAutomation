import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import '../../../k12/data/models/crud_homework_model.dart';
import '../../../k12/data/models/get_homework_model.dart';
import '../../../k12/data/repository/homework_repository_impl.dart';

class AddNewHomeworkController extends GetxController implements onClickListener {
  final String userType;
  final String username;
  final String sectionId;
  final String userId;
  final List<Subject> listOfSubject;
  final Homework? homework;

  AddNewHomeworkController({
    required this.userType,
    required this.username,
    required this.sectionId,
    required this.userId,
    required this.listOfSubject,
    this.homework,
  });

  final Rx<Subject?> subjectSelectedValue = Rx<Subject?>(null);
  final Rx<Chapter?> chapterSelectedValue = Rx<Chapter?>(null);
  final RxList<Chapter> listOfChapter = <Chapter>[].obs;
  final RxString selectedImageUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool dataChanged = false.obs;

  final messageTextController = TextEditingController();
  final subjectTextController = TextEditingController();
  final chapterTextController = TextEditingController();
  final assigndateTextController = TextEditingController();
  final submissiondateTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    setInitialData();
  }

  void setInitialData() {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    assigndateTextController.text = cdate;
    submissiondateTextController.text = cdate;

    if (homework != null) {
      for (var element in listOfSubject) {
        if (element.subjectId == homework?.subjectID) {
          subjectSelectedValue.value = element;
          subjectTextController.text = homework?.subjectName ?? '';
        }
      }

      if (subjectSelectedValue.value != null) {
        for (var element in subjectSelectedValue.value!.chapter ?? []) {
          if (element.chapterId == homework?.chapterID) {
            chapterSelectedValue.value = element;
            listOfChapter.add(element);
            chapterTextController.text = homework?.chapterName ?? '';
          }
        }
      }

      messageTextController.text = homework?.message ?? '';
      assigndateTextController.text = homework?.assigndate != null
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(homework!.assigndate!))
          : cdate;
      submissiondateTextController.text = homework?.submissiondate != null
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(homework!.submissiondate!))
          : cdate;
      selectedImageUrl.value = homework!.fileURL ?? '';
    }
  }

  void onSubjectChanged(Subject? val) {
    if (val != null) {
      subjectSelectedValue.value = val;
      listOfChapter.assignAll(val.chapter ?? []);
      chapterTextController.text = '';
      chapterSelectedValue.value = null;
    } else {
      subjectSelectedValue.value = null;
      listOfChapter.clear();
      chapterTextController.text = '';
      chapterSelectedValue.value = null;
    }
  }

  void onChapterChanged(Chapter? val) {
    chapterSelectedValue.value = val;
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await Utility.uploadHomeworkFile();
    if (result != null) {
      if (!Utility.isLargeFile(result, Get.context!)) {
        PlatformFile file = result.files.first;
        isLoading.value = true;
        try {
          await APIService().uploadImage(userId, kIsWeb ? file : file.path!, listener: this);
        } catch (e) {
          isLoading.value = false;
          Utility.showMessages(Get.context!, 'Upload failed: $e');
        }
      }
    }
  }

  Future<void> crudHomework() async {
    if (subjectSelectedValue.value?.subjectId == null) {
      Utility.showMessages(Get.context!, 'Select Subject');
      return;
    } else if (chapterSelectedValue.value?.chapterId == null) {
      Utility.showMessages(Get.context!, 'Select Chapter');
      return;
    } else if (messageTextController.text.trim().isEmpty) {
      Utility.showMessages(Get.context!, 'Enter Message');
      return;
    } else if (assigndateTextController.text.trim().isEmpty) {
      Utility.showMessages(Get.context!, 'Select Assign Date.');
      return;
    } else if (submissiondateTextController.text.trim().isEmpty) {
      Utility.showMessages(Get.context!, 'Select Submission Date.');
      return;
    }

    CrudHomeworkModel crudHomeworkModel = CrudHomeworkModel(
        homeworkId: homework?.homeworkID ?? 0,
        sectionId: sectionId,
        subjectId: subjectSelectedValue.value!.subjectId!.toString(),
        chapterId: chapterSelectedValue.value!.chapterId!.toString(),
        userId: userId,
        message: messageTextController.text,
        fileUrl: selectedImageUrl.value,
        username: username,
        assignDate: assigndateTextController.text,
        submissionDate: submissiondateTextController.text,
        isPublish: homework == null ? false : true,
        createdBy: homework == null ? '1' : '0');

    isLoading.value = true;
    Utility.showKESLoaderDialog(Get.context!);

    var response = await HomeworkRepositoryImpl().crudHomework(crudHomeworkModel: crudHomeworkModel);
    
    Navigator.pop(Get.context!); // Close Loader
    isLoading.value = false;

    response.either(
      (left) {
        debugPrint('Error is - $left');
        Utility.showMessages(Get.context!, 'Operation failed: $left');
      },
      (right) {
        dataChanged.value = true;
        if (right != null) {
          Utility.getConfirmationDialog(
              Get.context!, 'SUCCESS', right['data']['msg'].toString(), this);
        }
      },
    );
  }

  void clear() {
    subjectSelectedValue.value = null;
    subjectTextController.text = '';
    chapterSelectedValue.value = null;
    chapterTextController.text = '';
    assigndateTextController.text = '';
    submissiondateTextController.text = '';
    selectedImageUrl.value = '';
    messageTextController.text = '';
    listOfChapter.clear();
  }

  bool isTeach() => userType.toLowerCase() == 'teach';
  bool isCC() => userType.toLowerCase() == 'cc' || userType.toLowerCase() == 'cm';

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      UploadImageResponse response = value;
      selectedImageUrl.value = response.imageModel![0].location;
      isLoading.value = false;
    } else if (action == Utility.ACTION_OK) {
      if (homework != null) {
        Get.back(result: dataChanged.value);
      } else {
        clear();
      }
    }
  }
}
