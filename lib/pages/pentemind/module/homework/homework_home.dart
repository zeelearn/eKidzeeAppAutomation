import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/core/widgets/homework_dropdown_widget.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/insert_daily_student_homework_model.dart';
import 'package:ekidzee/pages/k12/data/repository/homework_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/entities/insert_daily_student_homework_entity.dart';
// import 'package:ekidzee/pages/k12/domain/entities/update_daily_homework_entity.dart';
import 'package:ekidzee/pages/pentemind/module/homework/add_new_homework_screen.dart';
import 'package:ekidzee/pages/pentemind/module/homework/review/homework_review_screen.dart';
import 'package:ekidzee/pages/pentemind/module/homework/widget/homework_card.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:literaoctave/core/toast_utility.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:shared_preferences/shared_preferences.dart';

class HomeworkHome extends StatefulWidget {
  String userType;
  HomeworkHome({super.key, required this.userType});

  @override
  State<HomeworkHome> createState() => _HomeworkHomeState();
}

class _HomeworkHomeState extends State<HomeworkHome> {
  // String selectedSubject = 'HIndi';
  Subject? selectedSubject;
  Chapter? selectedChapter;
  String? selectedCCStatus;
  String? error;

  bool isLoading = true;

  final statusTextController = TextEditingController();
  final subjectTextController = TextEditingController();
  final chapterTextController = TextEditingController();

  List<Subject> listOfSubject = [];
  List<Chapter> listOfChapter = [];
  List<Homework> listOfHomework = [];
  List<Homework> listOfOriginalHomework = [];

  late final prefs;
  String uid = '';
  String username = '';
  String userId = '';
  String token = '';
  int classId = 0;
  int programId = 0;
  int studentId = 0;

  List<String> ccStatusoptions = [
    'All',
    'Published',
    'Pending',
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    log('User name is - $uid - $userId - ${LocalConstant.isCognimind}');

    username = prefs.getString(LocalConstant.KEY_USER_NAME) as String;

    try {
      studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    } catch (e) {}
    setState(() {});

    getHomework();
  }

  set setLoading(bool value) => setState(() {
        isLoading = value;
      });

  Future<void> getHomework() async {
    debugPrint(
        'User id - $uid username is - $username ${programId.toString()}');
    debugPrint('UserType : ${widget.userType}');
    GetHomeworkModel getHomeworkModel = GetHomeworkModel(
        sectionId: programId.toString(), userId: uid, username: username);
    setLoading = true;
    var response = HomeworkRepositoryImpl()
        .getHomework(getHomeworkModel: getHomeworkModel);
    setLoading = false;
    response.either(
      (left) => log('Error from gethomework is - $left'),
      (right) {
        getHomeworkModel = GetHomeworkModel.fromJson(right,
            sectionId: getHomeworkModel.sectionId,
            userId: getHomeworkModel.userId,
            username: getHomeworkModel.username);
        listOfHomework.clear();
        listOfOriginalHomework.clear();
        listOfSubject.clear();
        listOfHomework.addAll(getHomeworkModel.data?.homework ?? []);
        listOfOriginalHomework.addAll(getHomeworkModel.data?.homework ?? []);
        listOfSubject.addAll(getHomeworkModel.data?.subject ?? []);
        setState(() {});
        //log('Response from gethomework is - ${getHomeworkModel.toJson()}');
      },
    );
  }

  bool isTeach() => widget.userType.toLowerCase().trim() == 'teach';

  bool isCCandCM() =>
      widget.userType.toLowerCase() == 'cc' ||
      widget.userType.toLowerCase() == 'cm';

  bool isStud() => widget.userType.toLowerCase() == "p";

  bool canAddorPublishHomework() => isTeach() || isCCandCM();
  Future<void> uploadHomework({required Homework homework}) async {
    InsertDailyStudentHomeworkModel insertDailyStudentHomeworkModel =
        InsertDailyStudentHomeworkModel(
            username: username,
            businessId: 1,
            inputData: [
              InputData(
                  homeworkId: homework.homeworkID ?? 0,
                  uploadUrl: 'https:homeworkuploded'),
            ],
            sectionId: programId,
            studentId: int.parse(userId));

    // setLoading = true;
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );

    var response = HomeworkRepositoryImpl().insertStudentDailyHomework(
        insertDailyStudentHomeworkModel: insertDailyStudentHomeworkModel);
    Navigator.pop(context);
    // setLoading = false;
    response.either(
      (left) {
        ToastUtility.showError('Failed to upload homework');
      },
      (right) {
        ToastUtility.showSuccess(
            right['data']['msg'] ?? 'Homework Submitted Successfully');
        int index = listOfHomework.indexWhere(
          (element) => element.homeworkID == homework.homeworkID,
        );
        if (index != -1) {
          listOfHomework[index].is_student_homework_uploaded = 1;
          listOfHomework[index].upload_url = 'https:homeworkuploded';
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    if (canAddorPublishHomework()) ...[
                      Row(
                        mainAxisAlignment: isCCandCM()
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (isCCandCM()) ...[
                            Expanded(
                              child: homwworkDropDown<String>(
                                selectedCCStatus,
                                textEditingController: statusTextController,
                                (p0) {
                                  if (p0 != null) {
                                    listOfHomework.clear();

                                    selectedCCStatus = p0;
                                    listOfChapter.clear();
                                    selectedSubject = null;
                                    selectedChapter = null;

                                    if (selectedCCStatus?.toLowerCase() ==
                                        'all') {
                                      listOfHomework
                                          .addAll(listOfOriginalHomework);
                                    } else {
                                      for (var element
                                          in listOfOriginalHomework) {
                                        if ((element.isPublish ?? false) &&
                                            p0.toLowerCase() == 'published') {
                                          listOfHomework.add(element);
                                        } else if (!(element.isPublish ??
                                                false) &&
                                            p0.toLowerCase() == 'pending') {
                                          listOfHomework.add(element);
                                        }
                                      }
                                    }

                                    setState(() {});
                                  }
                                },
                                ccStatusoptions,
                                (p0) => p0,
                              ),
                            ),
                          ],
                          !isTeach()
                              ? SizedBox.shrink()
                              : Container(
                                  width: 150,
                                  alignment: Alignment.topRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      goToAddHomeworkScreen();
                                    },
                                    icon: Icon(Icons.add,
                                        size: 18, color: Colors.white),
                                    label: Text(
                                      'Add New',
                                      style: LightColors.subTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryLightColor,
                                      foregroundColor: LightColors.primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        // vertical: 8.0,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: homwworkDropDown<Subject>(
                          selectedSubject,
                          textEditingController: subjectTextController,
                          (p0) {
                            selectedSubject = p0;
                            listOfChapter.clear();
                            listOfChapter
                                .addAll(selectedSubject?.chapter ?? []);
                            listOfHomework.clear();
                            if (p0 == null) {
                              listOfHomework.addAll(listOfOriginalHomework);
                              subjectTextController.text = '';
                              chapterTextController.text = '';
                              selectedChapter = null;
                              selectedSubject = null;
                            } else {
                              for (var element in listOfOriginalHomework) {
                                if (element.subjectName?.contains(
                                        selectedSubject?.subjectName ?? '') ??
                                    false) {
                                  listOfHomework.add(element);
                                }
                              }
                            }
                            chapterTextController.text = '';
                            selectedChapter = null;
                            setState(() {});
                            //                           debugPrint('Selected subject is - ${p0?.toJson()}');
                          },
                          listOfSubject,
                          (p0) => p0.subjectName ?? '',
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: homwworkDropDown<Chapter>(
                          selectedChapter,
                          textEditingController: chapterTextController,
                          (p0) {
                            setState(() {
                              selectedChapter = p0;
                              var newList = listOfOriginalHomework.where(
                                (element) =>
                                    (element.subjectName?.contains(
                                            selectedSubject?.subjectName ??
                                                '') ??
                                        false) &&
                                    (element.chapterName?.contains(
                                            selectedChapter?.chapterName ??
                                                '') ??
                                        false),
                              );
                              listOfHomework.clear();
                              if (p0 == null) {
                                listOfHomework.addAll(newList);
                              } else {
                                for (var element in newList) {
                                  if (element.chapterName?.contains(
                                          selectedChapter?.chapterName ?? '') ??
                                      false) {
                                    listOfHomework.add(element);
                                  }
                                }
                              }
                              selectedChapter = null;
                              setState(() {});
                            });
                            log('Selected chapter is - ${p0?.toJson()}');
                          },
                          listOfChapter,
                          (p0) => p0.chapterName ?? '',
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Hero(
                            tag: 'homework_${1}', child: homeworkList(context)))
                  ],
                ),
              ),
      ),
    );
  }

  Widget homeworkList(BuildContext context) {
    return listOfHomework.isEmpty
        ? Center(
            child: Utility.filter(context, 'No Homework Available'),
          )
        : !Responsive.isMobile(context)
            ? GridView.builder(
                clipBehavior: Clip.hardEdge,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Utility.getCrossAxisCountHomework(
                      context), // number of columns on desktop
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isStud() ? 1.6 : 1.5, // adjust as needed
                ),
                itemCount: listOfHomework.length,
                itemBuilder: (context, index) {
                  return homeworklistviewwidget(index);
                },
              )
            : ListView.builder(
                clipBehavior: Clip.hardEdge,
                itemBuilder: (context, index) {
                  return homeworklistviewwidget(index);
                },
                itemCount: listOfHomework.length,
              );
  }

  Widget homeworklistviewwidget(int index) {
    Homework homework = listOfHomework[index];
    return InkWell(
      onTap: () {
        if (isTeach() && (homework.isPublish ?? false)) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomeworkReviewScreen(homework: homework)));
        } else if (isCCandCM() && !(homework.isPublish ?? false)) {
          goToAddHomeworkScreen(homework);
        }
      },
      child: HomeworkCard(
        homework: homework,
        subject: homework.subjectName ?? '',
        chapter: homework.chapterName ?? '',
        message: homework.message ?? '',
        assignDate: homework.assigndate == null
            ? ''
            : DateFormat('dd MMM yyyy')
                .format(DateTime.parse(homework.assigndate!)),
        submissionDate: homework.submissiondate == null
            ? ''
            : DateFormat('dd MMM yyyy')
                .format(DateTime.parse(homework.submissiondate!)),
        status: isStud()
            ? homework.is_student_homework_uploaded == 1
                ? homework.statusCode?.toLowerCase() == 'c'
                    ? "Corrected"
                    : 'Submitted'
                : homework.statusCode?.toLowerCase() == 'w'
                    ? 'ReDo'
                    : 'Pending'
            : homework.isPublish ?? false
                ? 'Published'
                : 'Pending',
        fileUrl: homework.fileURL,
        onAttachmentTap: () {
          homework.fileURL != null && homework.fileURL!.isNotEmpty
              ? octaveUtil.Utils.onFileTapKidzee(
                  context, 'Attachment', homework.fileURL!, '', true)
              : null;
        },
        onHomeoworkTap: () {
          homework.upload_url != null && homework.upload_url!.isNotEmpty
              ? octaveUtil.Utils.onFileTapKidzee(context, 'Homework Attachment',
                  homework.upload_url!, '', true)
              : null;
        },
        userType: widget.userType,
        onUploadTap: () async {
          await uploadHomework(homework: homework);
        },
        completed: homework.completed ?? 0,
        total: homework.total ?? 0,
      ),
    );
  }

  void goToAddHomeworkScreen([Homework? homework]) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNewHomeworkScreen(
            userType: widget.userType,
            userId: uid,
            sectionId: programId.toString(),
            username: username /* '1234' */,
            listOfSubject: listOfSubject,
            homework: homework,
          ),
        )).then(
      (value) {
        checkDataChanged(value);
      },
    );
  }

  void checkDataChanged(value) {
    debugPrint('Return data is - $value');
    if (value is bool && value) {
      getHomework();
    }
  }

  Text subjectText(String title) {
    return Text(
      title,
      style: LightColors.textHeaderStyle13,
    );
  }

  Text CameraDescription(String title) {
    return Text(
      title,
      style: LightColors.smallTextStyle,
    );
  }

  Text smallText(String title) => Text(
        title,
        style: LightColors.subTextStyle.copyWith(fontSize: 10),
      );
}
