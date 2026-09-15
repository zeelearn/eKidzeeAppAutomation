import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/k12/core/widgets/homework_dropdown_widget.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/k12/data/repository/homework_repository_impl.dart';
import 'package:ekidzee/pages/pentemind/module/homework/add_new_homework_screen.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:saathi/core/utility/utils.dart' show getAttachmentIcon;
import 'package:shared_preferences/shared_preferences.dart';

class HomeworkHomeKES extends StatefulWidget {
  String userType;
  HomeworkHomeKES({super.key, required this.userType});

  @override
  State<HomeworkHomeKES> createState() => _HomeworkHomeKESState();
}

class _HomeworkHomeKESState extends State<HomeworkHomeKES> {
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
  String teacherId = '';
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
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    log('User name is - ${prefs.getString(LocalConstant.KEY_USER_NAME)}');

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

  bool isCC() =>
      widget.userType.toLowerCase() == 'cc' ||
      widget.userType.toLowerCase() == 'cm';

  bool canAddorPublishHomework() => isTeach() || isCC();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (canAddorPublishHomework()) ...[
                    Row(
                      mainAxisAlignment: isCC()
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (isCC()) ...[
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
                        Expanded(
                          child: !isTeach()
                              ? SizedBox.shrink()
                              : Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      goToAddHomeworkScreen();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Add New',
                                          style: LightColors.subTextStyle,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: 24,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                          listOfChapter.addAll(selectedSubject?.chapter ?? []);
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
                                          selectedSubject?.subjectName ?? '') ??
                                      false) &&
                                  (element.chapterName?.contains(
                                          selectedChapter?.chapterName ?? '') ??
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
                  Expanded(child: homeworkList())
                ],
              ),
            ),
    );
  }

  ListView homeworkList() {
    return ListView.builder(
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
        if (isCC() && !(homework.isPublish ?? false)) {
          goToAddHomeworkScreen(homework);
        }
      },
      child: Card(
        color: Colors.white,
        // margin: EdgeInsets.all(8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: smallText(
                          'Assign Date: ${homework.assigndate == null ? '' : DateFormat('yyyy-MM-dd').format(DateTime.parse(homework.assigndate!))}')),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Expanded(
                      child: smallText(
                          'Submission Date: ${homework.submissiondate == null ? '' : DateFormat('yyyy-MM-dd').format(DateTime.parse(homework.submissiondate!))}'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        subjectText('Subject: ${homework.subjectName}'),
                        SizedBox(
                          height: 5,
                        ),
                        CameraDescription(
                          'Chapter: ${homework.chapterName}',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    if (homework.fileURL != null &&
                        homework.fileURL!.isNotEmpty) ...[
                      InkWell(
                        onTap: () {
                          homework.fileURL != null &&
                                  homework.fileURL!.isNotEmpty
                              ? octaveUtil.Utils.onFileTapKidzee(context,
                                  'Attachment', homework.fileURL!, '', false)
                              : null;
                        },
                        child: FadeInImage(
                          height: 78,
                          placeholder:
                              AssetImage(getAttachmentIcon(homework.fileURL!)),
                          image:
                              AssetImage(getAttachmentIcon(homework.fileURL!)),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image(
                                image: AssetImage(
                                    getAttachmentIcon(homework.fileURL!)));
                          },
                        ),
                        // child: Image.network(
                        //   homework.fileURL!,
                        //   height: 40,
                        //   width: 40,
                        //   errorBuilder: (context, error, stackTrace) => Icon(
                        //     Icons.error,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      // if (homework.fileURL!.isNotEmpty)
                      //   IconButton(
                      //       onPressed: () {
                      //         Utility.downloadFile(homework.fileURL!,
                      //             homework.fileURL!.split('/').last);
                      //       },
                      //       icon: Icon(Icons.download)),
                    ]
                  ])
                ],
              ),
              CameraDescription('Message: ${homework.message}'),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    homework.isPublish ?? false ? 'Published' : 'Pending',
                    style: homework.isPublish ?? false
                        ? LightColors.smallTextStyle
                        : LightColors.textHeaderStyle13
                            .copyWith(color: LightColors.kRed),
                  )
                ],
              )
            ],
          ),
        ),
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
