// lib/presentation/pages/logbook_page.dart
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/k12/data/data_sources/logbook/logbook_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/teacher_logbook_model_get.dart';
import 'package:ekidzee/pages/k12/data/repository/logbook_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/entities/logbook/logbook_entity.dart';
import 'package:ekidzee/pages/k12/domain/usecases/logbook/logbook_usecase.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saathi/widget/dropdown.dart';

import '../../../data/models/logbook/timetable.dart';

class KESLogbookPage extends StatefulWidget {
  String userName;
  int classId;
  String date;
  LogbookTimeTableModel timeTableModel;

  KESLogbookPage(
      {super.key,
      required this.userName,
      required this.classId,
      required this.date,
      required this.timeTableModel});

  @override
  _LogbookPageState createState() => _LogbookPageState();
}

class _LogbookPageState extends State<KESLogbookPage>
    implements onClickListener {
  late final GetLogbook getLogbook; // Injected via constructor or DI
  LogbookEntity? logbook;
  GetTeacherLogbookModel? currentLogbook;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();

  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _aidController = TextEditingController();
  final TextEditingController _classworkSheetController =
      TextEditingController();
  final TextEditingController _homeworkController = TextEditingController();
  final TextEditingController _remakrController = TextEditingController();

  LogbookChapter? mSelectedChapter;
  LogbookTopic? mSelectedTopic;
  List<LogbookTopic> topic = [];
  List<LogbookClosure> closureList = [];
  List<LearningOutcome> learningOutcomes = [];

  double height = 500;

  @override
  void initState() {
    super.initState();
    getLogbook = GetLogbook(LogbookRepository(LogbookRemoteDataSource()));
    _loadLogbook();
  }

  Future<void> _loadLogbook() async {
    logbook = await getLogbook.getKESLogbook(
        widget.classId, widget.timeTableModel.subjectId, widget.userName, 1);
    try {
      currentLogbook = await getLogbook.getTeachersLogbook(
          widget.userName,
          1,
          widget.date,
          widget.timeTableModel.periodId,
          widget.timeTableModel.sectionId);
      updateData();
    } catch (e) {
      debugPrint('Error while parsing logbook data - $e');
    }
    setState(() {});
  }

  updateData() {
    try {
      _remakrController.text = currentLogbook!.remarks;
      _chapterController.text = currentLogbook!.chapterName;
      _topicController.text = currentLogbook!.topicName;
      mSelectedChapter = logbook!.academic[0].chapter!
          .where((chapter) => chapter.chapterId == currentLogbook!.chapterId)
          .toList()[0];
      mSelectedTopic = mSelectedChapter!.topic
          .where((topic) => topic.topicId == currentLogbook!.topicId)
          .toList()[0];
      _activityController.text = currentLogbook!.activity;
      _aidController.text = currentLogbook!.teachingAids;
      _classworkSheetController.text = currentLogbook!.classwork;
      _homeworkController.text = currentLogbook!.homework;
      learningOutcomes.clear();
      learningOutcomes.addAll(mSelectedChapter!.learningOutcome!);
      topic.clear();
      topic.addAll(mSelectedChapter!.topic);

      closureList.clear();
      closureList.addAll(mSelectedTopic!.closure!);

      final updatedLogbookIds =
          currentLogbook!.learningOutcome.map((log) => log.loId).toSet();
      // Update isChecked flag in currentList based on existence in updatedList
      for (var log in learningOutcomes) {
        log.isChecked = updatedLogbookIds.contains(log.loId);
      }
      final updatedclosure =
          currentLogbook!.closure.map((closure) => closure.closureId).toSet();
      // Update isChecked flag in currentList based on existence in updatedList
      for (var closure in closureList) {
        closure.isChecked = updatedclosure.contains(closure.closureId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height * 0.8;
    //debugPrint('Height ${height}  ${MediaQuery.of(context).size.height}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject : ${widget.timeTableModel.subjectName}',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Text(
              'Class : ${widget.timeTableModel.className}   -   Period : ${widget.timeTableModel.periodName}',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )
          ],
        ),
      ),
      body: logbook == null
          ? Center(child: CircularProgressIndicator())
          : kIsWeb
              ? _logbookWeb()
              : _logbookMobile(),
    );
  }

  _logbookMobile() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Chapter',
              style: LightColors.smallTextStyle,
            ),
            if (logbook != null && logbook!.academic.isNotEmpty)
              ZeeDropDown(
                title: 'Chapter',
                textController: _chapterController,
                hintText: 'Chapter',
                readOnly: true,
                items: logbook!.academic[0].chapter!,
                displayFunction: (value) => value.chapterName!,
                onChanged: (value) {
                  mSelectedChapter = value!;
                  learningOutcomes.clear();
                  learningOutcomes.addAll(value.learningOutcome!);
                  setState(() {
                    topic.clear();
                    topic.addAll(value.topic);
                  });
                  // if (value != null) {
                  //   if (!isNodeExists(currentNode[index])) {
                  //     push(value, value.name);
                  //   }
                  // }else{
                  //   debugPrint('current index ${index}');
                  // }
                },
              ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Topic',
              style: LightColors.smallTextStyle,
            ),
            ZeeDropDown(
              title: 'Topic',
              textController: _topicController,
              hintText: 'Topic',
              items: topic,
              readOnly: true,
              displayFunction: (value) => value.topicName!,
              onChanged: (value) {
                mSelectedTopic = value!;
                setState(() {
                  closureList.clear();
                  closureList.addAll(value.closure!);
//                   debugPrint('closureList length ${closureList.length}');
                });

                // if (value != null) {
                //   if (!isNodeExists(currentNode[index])) {
                //     push(value, value.name);
                //   }
                // }else{
                //   debugPrint('current index ${index}');
                // }
              },
            ),
            SizedBox(
              height: defaultPadding,
            ),

            _textField('Activity', _activityController),
            SizedBox(
              height: defaultPadding,
            ),
            _divider(),
            _textField('Teaching Aids & Resources', _aidController),
            SizedBox(
              height: defaultPadding,
            ),
            _textField('Classwork sheet', _classworkSheetController),
            // _divider(),
            SizedBox(
              height: defaultPadding,
            ),
            _textField('Homework', _homeworkController),
            /*  SizedBox(
              height: defaultPadding,
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    color: LightColors.kLightGrayM,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Closure',
                      style: LightColors.smallTextStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      
                      //width: MediaQuery.of(context).size.width/2.3,
                      child: closureList.length == 0
                          ? Center(
                              child: Text('Closure List Not avaliable'),
                            )
                          : Column(
                              children: [
                                for (int index = 0;
                                    index < closureList.length;
                                    index++)
                                  CheckboxListTile(
                                    title: Text(closureList[index].closureName!),
                                    value: closureList[index].isChecked ?? false,
                                    onChanged: (value) {
                                      setState(() {
                                        closureList[index].isChecked = value;
                                      });
                                    },
                                  )
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ), */
            /* SizedBox(
              height: defaultPadding,
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    color: LightColors.kLightGrayM,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Text(
                    'Learning Outcome',
                    style: LightColors.smallTextStyle,
                    ),
                  ),
                  if (learningOutcomes.length > 0)
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          for (int index = 0; index < learningOutcomes.length; index++)
                            CheckboxListTile(
                              title: Text(learningOutcomes[index].loName!),
                              value: learningOutcomes[index].isChecked ?? false,
                              onChanged: (value) {
                                setState(() {
                                  learningOutcomes[index].isChecked = value;
                                });
                              },
                            )
                        ],
                      ),
                    ),
                ],
              ),
            ),
             */
            SizedBox(
              height: defaultPadding,
            ),
            _textField('Remark', _remakrController),
            SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
                onPressed: () {
                  validateLogbook();
                },
                child: Text(
                  'Submit',
                  style: LightColors.textHeaderStyle13
                      .copyWith(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  _chapter() {
    return ZeeDropDown(
      title: 'Chapter',
      textController: _chapterController,
      hintText: 'Chapter',
      readOnly: true,
      items: logbook!.academic[0].chapter!,
      displayFunction: (value) => value.chapterName!,
      onChanged: (value) {
        mSelectedChapter = value!;
        learningOutcomes.clear();
        learningOutcomes.addAll(value.learningOutcome!);
        setState(() {
          topic.clear();
          topic.addAll(value.topic);
        });
      },
    );
  }

  _topic() {
    return ZeeDropDown(
      title: 'Topic',
      textController: _topicController,
      hintText: 'Topic',
      items: topic,
      readOnly: true,
      displayFunction: (value) => value.topicName!,
      onChanged: (value) {
        setState(() {
          mSelectedTopic = value!;
          closureList.clear();
          closureList.addAll(value.closure!);
//           debugPrint('closureList length ${closureList.length}');
        });
      },
    );
  }

  _textField(String label, TextEditingController controller) {
    return kIsWeb
        ? Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: LightColors.smallTextStyle,
                ),
                MyWidget().normalTextAreaField(context, label, controller)
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: LightColors.smallTextStyle,
              ),
              MyWidget().normalTextAreaField(context, label, controller)
            ],
          );
  }

  _divider() {
    return SizedBox(
      width: 10,
    );
  }

  _buildWidget(String label, Widget widget) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: LightColors.smallTextStyle,
          ),
          widget
        ],
      ),
    );
  }

  _logbookWeb() {
    double padding = MediaQuery.of(context).size.height * 0.05;
    return logbook!.academic.isEmpty
        ? Utility.emptyData(context, 'Data not found')
        : Container(
            color: LightColors.kLightGray1,
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.height * 0.05,
                  top: 20,
                  bottom: 20),
              child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height,
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _buildWidget('Chapter', _chapter()),
                                    _divider(),
                                    _buildWidget('Topic', _topic()),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Row(
                                  children: [
                                    _textField('Activity', _activityController),
                                    _divider(),
                                    _textField('Teaching Aids& Resources',
                                        _aidController),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Row(
                                  children: [
                                    _textField('Classwork sheet',
                                        _classworkSheetController),
                                    _divider(),
                                    _textField('Homework', _homeworkController),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Closure',
                                          style: LightColors.smallTextStyle,
                                        )),
                                    SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Learning Outcome',
                                          style: LightColors.smallTextStyle,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        height: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: LightColors.kLightGray1),
                                            color: Colors.white),
                                        //width: MediaQuery.of(context).size.width/2.3,
                                        child: closureList.isEmpty
                                            ? Center(
                                                child: Text(
                                                    'Closure List Not avaliable'),
                                              )
                                            : ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Divider(
                                                    color:
                                                        LightColors.kLightGrayM,
                                                  );
                                                },
                                                itemCount: closureList.length,
                                                itemBuilder: (context, index) {
                                                  return CheckboxListTile(
                                                    title: Text(
                                                        closureList[index]
                                                            .closureName!),
                                                    value: closureList[index]
                                                            .isChecked ??
                                                        false,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        closureList[index]
                                                            .isChecked = value;
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        height: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: LightColors.kLightGray1),
                                            color: Colors.white),
                                        //width: MediaQuery.of(context).size.width/2.3,
                                        child: learningOutcomes.isEmpty
                                            ? Center(
                                                child: Text(
                                                    'Learning Outcome Not avaliable'),
                                              )
                                            : ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Divider(
                                                    color:
                                                        LightColors.kLightGrayM,
                                                  );
                                                },
                                                itemCount:
                                                    learningOutcomes.length,
                                                itemBuilder: (context, index) {
                                                  return CheckboxListTile(
                                                    title: Text(
                                                        learningOutcomes[index]
                                                            .loName!),
                                                    value:
                                                        learningOutcomes[index]
                                                                .isChecked ??
                                                            false,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        learningOutcomes[index]
                                                            .isChecked = value;
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: _textField(
                                          'Remark', _remakrController),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            validateLogbook();
                          },
                          child: Text(
                            'Submit',
                            style: LightColors.textHeaderStyle13
                                .copyWith(color: Colors.white),
                          ))
                    ],
                  )),
            ),
          );
  }

  validateLogbook() {
//     debugPrint('validate logbook');
    saveTeacherLogbook();
  }

  List<LogbookClosure> _getSelectedClosure() {
    List<LogbookClosure> checkedClosures =
        closureList.where((closure) => closure.isChecked == true).toList();
    return checkedClosures;
  }

  List<LearningOutcome> _getSelectedLearingOutcome() {
    List<LearningOutcome> outcomes =
        learningOutcomes.where((outcome) => outcome.isChecked == true).toList();
    return outcomes;
  }

  validate() {
    bool isValidate = false;
    if (mSelectedChapter == null) {
      Utility.showAlertDialog(context, 'Please Select the Chapter');
    } else if (mSelectedTopic == null) {
      Utility.showAlertDialog(context, 'Please Select Topic');
    } else if (_activityController.text.isEmpty) {
      Utility.showAlertDialog(context, 'Please Enter the Activity Name');
    } else if (_aidController.text.isEmpty) {
      Utility.showAlertDialog(
          context, 'Please Enter the Teaching Aid & Resources');
    } else if (_classworkSheetController.text.isEmpty) {
      Utility.showAlertDialog(context, 'Please Enter the Classwork Sheet');
    } else if (_homeworkController.text.isEmpty) {
      Utility.showAlertDialog(context, 'Please Enter the Homework');
    } /*  else if (_getSelectedClosure().length == 0) {
      Utility.showAlertDialog(context, 'Please Select the Clouser');
    } */ /* else if (_getSelectedLearingOutcome().length == 0) {
      Utility.showAlertDialog(context, 'Please Select the Learning Outcome');
    } */
    else if (_remakrController.text.isEmpty) {
      Utility.showAlertDialog(context, 'Please Enter the Remark');
    } else {
      isValidate = true;
    }
    return isValidate;
  }

  saveTeacherLogbook() async {
    if (validate()) {
      TeacherLogbookData data = TeacherLogbookData(
          chapterId: mSelectedChapter!.chapterId!,
          topicId: mSelectedTopic!.topicId!,
          activity: _activityController.text.toString(),
          teachingAids: _aidController.text.toString(),
          classwork: _classworkSheetController.text.toString(),
          homework: _homeworkController.text.toString(),
          closure: _getSelectedClosure(),
          learningOutcome: _getSelectedLearingOutcome(),
          remarks: _remakrController.text.toString());
      TeacherLogbookModel model = TeacherLogbookModel(
          username: widget.userName,
          businessId: AppFlavor == 'mlzs' ? 2 : 1,
          date: widget.date,
          periodId: widget.timeTableModel.periodId,
          sectionId: widget.timeTableModel.sectionId,
          classId: widget.classId,
          subjectId: widget.timeTableModel.subjectId,
          inputData: data);
      GeneralResponse response = await getLogbook.insertTeacherLogbook(model);
      if (response.success == 200) {
        Utility.confirm(context, 'Success', response.data!.msg!, this);
      }
    }
  }

  @override
  void onClick(int action, value) {
    Navigator.of(context).pop();
  }
}
