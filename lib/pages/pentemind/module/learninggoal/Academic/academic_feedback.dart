import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/AcademicRequest/GetAcademicRequest.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/AcademicRequest/academic_feedback_request.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Responsive.dart';
import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../../api/response/pentemind/learninggoals/academic/GetAcademicResponse.dart';
import '../../../../../api/response/pentemind/learninggoals/academic/GetAcademicStudentListResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/DatabaseHelper.dart';
import '../../../../../helper/utils.dart';
import '../../../../../main.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../notification/NotificationService.dart';

class AcademicFeedback extends StatefulWidget {
  int day;
  AcademicLearningGoalsModel model;

  AcademicFeedback({super.key, required this.day, required this.model});

  @override
  _AcademicFeedbackState createState() => _AcademicFeedbackState();
}

class _AcademicFeedbackState extends State<AcademicFeedback>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<FacilatorObservation> Observation = [];
  List<AcademicStudentInfo> mList = [];
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';

  String studentId = '';
  String className = '';
  int programId = 0;
  GetAcademicStudentListResponse? mAcademicStudentListResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    Observation.add(FacilatorObservation(
        RefKey: "P", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "E", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "N", RefCount: 0, Remarks: "", isChecked: false));
    loadData();
  }

  loadData() async {
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('DevelopmentalFeedback didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getUserInfo();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;

    var childAdvancementSummery = prefs.getString(getId());
//     debugPrint('ID ------------  ${getId()}');
    debugPrint(childAdvancementSummery);
    if (childAdvancementSummery == null && !await Utility.isInternet()) {
      setState(() {
        isLoading = false;
      });
    } else if (childAdvancementSummery == null || await Utility.isInternet()) {
      getDevelopmentalStudentList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      mAcademicStudentListResponse = GetAcademicStudentListResponse.fromJson(
        json.decode(data!),
      );
      if (mAcademicStudentListResponse != null) {
        mList.add(AcademicStudentInfo(
            StudentID: '',
            StudentName: 'Student Name',
            ParentName: '',
            MobileNo: '',
            Rating: '',
            enumRating: '',
            LGAID: ''));
        mList.addAll(mAcademicStudentListResponse!.studentInfo);
        generateRadio();
        setState(() {});
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
    setState(() {});
    return isLoad;
  }

  String getId() {
    return '${programId.toString()}_${LocalConstant.MENU_LG_ACEDEMIC_STUDINFO}_${widget.model.ClassId}_${widget.model.LGAID}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getDevelopmentalStudentList() async {
    if (!await Utility.isInternet()) {
      Utility.showMessage(context, 'Please check Internet connection...');
    } else {
      isLoading = true;
      setState(() {});
      mList.clear();
      _group.clear();
      _value.clear();
      GetAcademicRequest request = GetAcademicRequest(
          ProgramID: programId,
          D: widget.day.toString(),
          LGAID: widget.model.LGAID,
          UserID: int.parse(uid));
      APIService apiService = APIService();
      apiService
          .getLearningGoalAcademicStudentList(request, token)
          .then((value) {
        debugPrint(value.toString());
        isLoading = false;
        if (value != null) {
//         debugPrint('value is not null ${value}');
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is GetAcademicStudentListResponse) {
            GetAcademicStudentListResponse response = value;
            mAcademicStudentListResponse = response;
            String json = jsonEncode(response);
            savechildAdvancementSummery(json);
            mList.add(AcademicStudentInfo(
                StudentID: '',
                StudentName: 'Student Name',
                ParentName: '',
                MobileNo: '',
                Rating: '',
                enumRating: '',
                LGAID: ''));
            mList.addAll(response.studentInfo);
            generateRadio();
            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        //Navigator.of(context).pop();
        setState(() {});
      });
    }
  }

  generateRadio() {
    for (int index = 0; index < mList.length; index++) {
      int defGroup = 999;
      for (int jIndex = 0; jIndex < Observation.length; jIndex++) {
        if (jIndex == 0 && mList[index].Rating == 'S1') {
//           debugPrint('SI FOUNBD.......................');
          defGroup = 0;
        } else if (jIndex == 1 && mList[index].Rating == 'S2') {
          defGroup = 1;
        } else if (jIndex == 2 && mList[index].Rating == 'S3') {
          defGroup = 2;
        }
        if (index == 0) {
          _value.add(jIndex);
        } else {
          _value.add(jIndex);
        }
      }
      _group.add(defGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Developmental Feedback');
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.model.LearningGoals,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          // You can add title here
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kPrimaryLightColor,
          //You can make this transparent
          elevation: 5,
          //No shadow
          shadowColor: LightColors.kLightGray1,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getDevelopmentalStudentList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (mList.isEmpty) {
      return Utility.emptyData(context,
          "Student List are  not available at this moment please check later");
    } else {
      return Column(children: <Widget>[
        Row(
          children: [
            Checkbox(
              value: isSelectAll,
              onChanged: (bool? value) {
                setState(() {
                  resetCheckbox();
                  isSelectAll = value!;
                  updateSelection(!value);
                });
              },
            ),
            MyWidget().richText('Select All', LightColors.textHeaderStyle13)
          ],
        ),
        getContent(),
        /*generateTable(),*/
        SizedBox(
            width: 100,
            height: 50,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                    ),
                    onPressed: () {
                      updateFacilatorSays();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ))))
      ]);
    }
  }

  int id = 1;

  final List<String> _dynamicChips = ['S1', 'S2', 'S3'];

  generateRatingContent(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Student Name
          Expanded(
            flex: 3,
            child: MyWidget().richText(
              mList[index].StudentName,
              LightColors.textSmallStyle,
            ),
          ),

          /// Smiley / Radio Section
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_dynamicChips.length, (int mIndex) {
                return index == 0
                    ? Image.asset(
                        "assets/icons/pentemind/Smile${mIndex + 1}.png",
                        height: 28,
                        width: 28,
                      )
                    : Radio<int>(
                        value: _value[mIndex],
                        groupValue: _group[index],
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() {
                            isSelectAll = false;
                            _group[index] = value!;
                            mList[index].Rating = _dynamicChips[mIndex];
                          });
                        },
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }

  getContent() {
    return Flexible(
        child: ListView.builder(
      itemCount: mList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(5),
          child: Card(
            color: Colors.white,
            child: true
                ? generateRatingContent(index)
                : ListTile(
                    title: MyWidget().richText(
                        mList[index].StudentName, LightColors.textSmallStyle),
                    trailing: Wrap(
                      spacing: 4.0,
                      runSpacing: 2.0,
                      children: List<Widget>.generate(_dynamicChips.length,
                          (int mIndex) {
                        return index == 0
                            ? Container(
                                width: Responsive.isMobile(context) ? 40 : 90,
                                child: Center(
                                  child: Image.asset(
                                    "assets/icons/pentemind/Smile${mIndex + 1}.png",
                                    height: 28,
                                    width: 36,
                                  ),
                                ),
                              )
                            : Container(
                                width: Responsive.isMobile(context) ? 40 : 90,
                                child: Radio(
                                    value: _value[mIndex],
                                    groupValue: _group[index],
                                    onChanged: (value) {
                                      mList[index].Rating =
                                          _dynamicChips[mIndex];
                                      setState(() {
                                        _group[index] = value as int;
                                      });
                                    }),
                              );
                      }),
                    )),
          ),
        );
      },
    ));
  }

  bool isSelectAll = false;

  final List<int> _group = [];
  final List<int> _value = [];
  List<SaveWhatWentWellModel> getSelectedOptions() {
    List<SaveWhatWentWellModel> list = [];
    for (int mIndex = 1; mIndex < mList.length; mIndex++) {
      for (int index = 0; index < Observation.length; index++) {
        if (_group[mIndex] == index) {
          //list.add(SaveWhatWentWellModel(RefKey: widget.refKey, RefValue: Observation[index].RefKey, StudentID: int.parse(mList[mIndex].StudentID), Term: widget.term));
        }
      }
    }
    return list;
  }

  resetCheckbox() {
    for (int index = 0; index < Observation.length; index++) {
      Observation[index].isChecked = false;
    }
  }

  updateSelection(bool isChecked) {
    for (int mIndex = 1; mIndex < mList.length; mIndex++) {
      if (isChecked) {
        mList[mIndex].Rating = '';
      } else {
        mList[mIndex].Rating = 'S1';
      }
      for (int index = 0; index < Observation.length; index++) {
        if (index == 0) {
          //for (int jIndex = 0; jIndex < _group.length; jIndex++) {
          _group[mIndex] = 0;
          //}
        } else {
          for (int jIndex = 0; jIndex < _group.length; jIndex++) {
            if (isChecked)
              _group[mIndex] = 999;
            else {
              _group[mIndex] = 0;
            }
          }
        }
      }
    }
  }

  List<DataRow> getRowsStudent() {
    List<DataRow> list = [];
    for (int mIndex = 1; mIndex < mList.length; mIndex++) {
      List<DataCell> cell = [];
      cell.add(
        DataCell(
          MyWidget()
              .richText(mList[mIndex].StudentName, LightColors.textvSmallStyle),
        ),
      );
      if (mIndex == 0) {
        List<DataCell> cellHeader = [];
        cellHeader.add(
          DataCell(
            MyWidget().richText('', LightColors.textvSmallStyle),
          ),
        );
        for (int index = 0; index < Observation.length; index++) {
          cellHeader.add(
            DataCell(
              Center(
                child: Image.asset(
                  "assets/icons/pentemind/Smile${index + 1}.png",
                  height: 28,
                  width: 28,
                ),
              ),
            ),
          );
        }

        list.add(DataRow(cells: cellHeader));
      }
      for (int index = 0; index < Observation.length; index++) {
        cell.add(
          DataCell(
            Center(
              child: Radio(
                  value: _value[index],
                  groupValue: _group[mIndex],
                  onChanged: (value) {
                    setState(() {
                      resetCheckbox();
                      _group[mIndex] = value as int;
                      getSelectedOptions();
                    });
                  }),
            ),
          ),
        );
      }
      list.add(DataRow(cells: cell));
    }
    return list;
  }

  saveOfflineObservation() {
//     debugPrint('save local observation....');
    if (mAcademicStudentListResponse != null &&
        mAcademicStudentListResponse!.studentInfo.isNotEmpty) {
      for (int index = 1; index < mList.length; index++) {
        if (mList[index].Rating!.isNotEmpty) {
          for (int jIndex = 0;
              jIndex < mAcademicStudentListResponse!.studentInfo.length;
              jIndex++) {
            if (mAcademicStudentListResponse!.studentInfo[jIndex].StudentID ==
                mList[index].StudentID) {
              mAcademicStudentListResponse!.studentInfo[jIndex].Rating =
                  mList[index].Rating;
//               debugPrint('${mAcademicStudentListResponse!.studentInfo[jIndex].StudentID}  ${mList[index].StudentID} save local observation....Rating updated ${mList[index].Rating}');
            }
          }
        }
      }
      savechildAdvancementSummery(jsonEncode(mAcademicStudentListResponse));
    }
  }

  updateFacilatorSays() async {
//     debugPrint('update Facilator ');
    List<AcademicStudentInfo> studentInfoList = [];
    for (int index = 1; index < mList.length; index++) {
      if (mList[index].Rating!.isNotEmpty) {
        studentInfoList.add(mList[index]);
      }
    }
    for (int index = 0; index < studentInfoList.length; index++) {
      studentInfoList[index].LGAID = widget.model.LGAID;
    }
    AcademicFeedbackRequest request = AcademicFeedbackRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        studentInfo: studentInfoList);
    debugPrint(request.toJson());
    if (request.studentInfo.isEmpty) {
      Utility.showAlertDialog(context, 'Please Select Observation ');
    } else {
      if (!await Utility.isInternet()) {
        saveOfflineObservation();
        DBHelper dbHelper = DBHelper();
        dbHelper.insertSyncData(request.toJson(),
            LocalConstant.ACTION_BG_ACADEMIC, int.parse(teacherId));
        Utility.getConfirmationDialog(context, 'Academic Learning Goal Update!',
            'Academic Learning Goals  are successfully Updated!', this);
        NotificationService notificationService = NotificationService();
        notificationService.showNotification(
            14,
            'Academic Learning Goal Update!',
            'Academic Learning Goals  are successfully Updated!',
            'Academic Learning Goals  are successfully Updated!');
        initializeService();
      } else {
        Utility.showLoaderDialog(context);
        APIService apiService = APIService();
        apiService.insertAcademicFeedback(request, token).then((value) {
          isLoading = false;
          if (value != null) {
            if (value == null) {
              Utility.showMessage(context, 'data not found');
            } else if (value is GenericResponse) {
              GenericResponse response = value;
              if (response.success == 200) {
                Navigator.pop(context, 'DONE');
                Utility.showMessage(
                    context,
                    response.response is String
                        ? response.response
                        : response.response.response.toString());
              }
              //getChildInfomrmationList();
            } else {
              Utility.showMessage(context, 'data not found');
            }
          }
          Navigator.of(context, rootNavigator: true).pop('dialog');
        });
      }
    }
  }

  @override
  void onClick(int action, value) {
//     debugPrint('onclick ${action} ${value}');
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      Navigator.pop(context, mAcademicStudentListResponse);
      //Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
