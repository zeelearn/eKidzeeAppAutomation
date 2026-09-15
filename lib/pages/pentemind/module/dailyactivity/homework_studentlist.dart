import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/dailyactivity/studentlist_request.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/update_homework_teacher.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../Responsive.dart';
import '../../../../api/response/pentemind/dailyactivity/homestudentlist.dart';
import '../../../../api/response/pentemind/dailyactivity/homework_response.dart';
import '../../../../widget/image_viewer.dart';

class HomeworkStudentListScreen extends StatefulWidget {
  HomeWorkModel model;

  HomeworkStudentListScreen({super.key, required this.model});

  @override
  _HomeworkStudentListScreenState createState() =>
      _HomeworkStudentListScreenState();
}

class _HomeworkStudentListScreenState extends State<HomeworkStudentListScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<FacilatorObservation> Observation = [];
  List<HomeWorkStudentModel> mList = [];
  bool isLoading = true;
  bool isPresent = false;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';

  String studentId = '';
  String className = '';
  int programId = 0;
  double headerWidth = 0;
  double rowWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    Observation.add(FacilatorObservation(
        RefKey: "C", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "NC", RefCount: 0, Remarks: "", isChecked: false));
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
//     debugPrint('Update DailyActivity didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getStudentList();
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
    if (true || childAdvancementSummery == null) {
      getStudentList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      GetHomeworkStudentResponse response = GetHomeworkStudentResponse.fromJson(
        json.decode(data!),
      );
      mList.addAll(response.studentList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_DAILY_ACTIVITY_UPDATE}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getStudentList() {
    isLoading = true;
    setState(() {});
    mList.clear();
    _group.clear();
    _value.clear();
    GetHomeworkStudentRequest request = GetHomeworkStudentRequest(
        UserID: uid,
        ProgramID: programId.toString(),
        HomeworkID: widget.model.HomeworkID,
        TransType: 'HW',
        StudentID: '0');
    APIService apiService = APIService();
    apiService.getHomeWorkStudentLust(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
//         debugPrint('value is not null ${value}');
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GetHomeworkStudentResponse) {
          GetHomeworkStudentResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          //mList.add(HomeWorkStudentModel(StudentID: '0', StudentName: 'Student Name', ParentName: '', MobileNo: '', UploadUrl: '', PStatusCode: '', TStatusCode: '', Remarks: ''));
          mList.addAll(response.studentList);
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

  generateRadio() {
    for (int index = 0; index < mList.length; index++) {
      int defGroup = 900;
      if (mList != 0 && mList[index].UploadUrl.isNotEmpty) {
        isPresent = true;
      }
      for (int jIndex = 0; jIndex < Observation.length; jIndex++) {
        if (jIndex == 0 && mList[index].TStatusCode == 'S1') {
//           debugPrint('SI FOUNBD.......................');
          defGroup = 1;
        } else if (jIndex == 1 && mList[index].TStatusCode == 'S2') {
          defGroup = 2;
        }
        if (index == 0) {
          _value.add((index + jIndex) + 1);
        } else {
          _value.add((index * jIndex));
        }
      }
      _group.add(defGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Developmental Feedback');
    headerWidth = Responsive.isMobile(context)
        ? (MediaQuery.of(context).size.width * 40 / 100)
        : (MediaQuery.of(context).size.width * 55 / 100);
    rowWidth = Responsive.isMobile(context)
        ? ((MediaQuery.of(context).size.width * 40 / 100) / 2)
        : ((MediaQuery.of(context).size.width * 45 / 100) / 2);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.model.Worksheet,
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
              getStudentList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Utility.showLoader();
    } else if (mList.isEmpty) {
      return Utility.emptyData(context,
          "Student List are  not available at this moment please check later");
    } else {
      return Container(
        color: LightColors.kLightGrayM,
        margin: EdgeInsets.all(1),
        child: Column(children: <Widget>[
          getHeader(),
          getContent(),
          /*generateTable(),*/
          SizedBox(
            height: 30,
          ),
          SizedBox(
              width: 100,
              height: 40,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPresent == true
                            ? kPrimaryLightColor
                            : LightColors.kHeaderColor,
                      ),
                      onPressed: () {
                        if (isPresent) updateFeedback();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ))))
        ]),
      );
    }
  }

  int id = 1;

  final List<String> _dynamicChips = ['S1', 'S2'];
  getContent() {
    return Flexible(
        child: ListView.builder(
      itemCount: mList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return activeRow(mList[index], index);
      },
    ));
  }

  activeRow(HomeWorkStudentModel model, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: model.UploadUrl.isNotEmpty
              ? Colors.white
              : LightColors.kLightGrayM,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: model.UploadUrl.isNotEmpty
                    ? SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageViewer(
                                        imageUrl: model.UploadUrl,
                                      )));
                            },
                            child: Image.network(model.UploadUrl,
                                width: 50, height: 50, fit: BoxFit.fill)),
                      )
                    : Image.asset('assets/icons/ic_noimg.png',
                        width: 25, height: 25),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: generateAttendanceView(model, index),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Wrap(
                  // spacing: 0.0,
                  // runSpacing: 0.0,
                  children:
                      List<Widget>.generate(_dynamicChips.length, (int mIndex) {
                    return model.StudentID.isEmpty
                        ? Container(
                            margin: EdgeInsets.all(5),
                            width: rowWidth,
                            child: Text(_dynamicChips[mIndex],
                                style: LightColors.textHeaderStyle),
                          )
                        : model.UploadUrl.isNotEmpty
                            ? SizedBox(
                                width: rowWidth,
                                child: Radio(
                                    value: _value[mIndex],
                                    groupValue: _group[index],
                                    onChanged: (value) {
                                      mList[index].TStatusCode =
                                          _dynamicChips[mIndex];
                                      mList[index].Remarks = mIndex == 0
                                          ? 'Well Done'
                                          : 'Well attempted! Let\'s meet to understand how do we make it better.';
                                      debugPrint(mList[index].Remarks);
                                      setState(() {
                                        _group[index] = value as int;
                                      });
                                    }),
                              )
                            : SizedBox(
                                width: rowWidth,
                                child: Radio(
                                  activeColor: Colors.grey,
                                  value: _value[mIndex],
                                  groupValue: _group[index],
                                  onChanged: (value) {},
                                ),
                              );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 50,
                child: Text(
                  'HW',
                  style: LightColors.textSmallStyle,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Student Name',
                  style: LightColors.textSmallStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Wrap(
                  // spacing: 0.0,
                  // runSpacing: 0.0,
                  children:
                      List<Widget>.generate(_dynamicChips.length, (int mIndex) {
                    return SizedBox(
                      width: rowWidth,
                      child: Image.asset(
                          'assets/icons/pentemind/Smile${mIndex + 1}.png',
                          width: 25,
                          height: 25),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  generateAttendanceView(HomeWorkStudentModel model, int index) {
    List<Widget> rowWidget = [];
    if (model.StudentName.isNotEmpty) {
      rowWidget.add(
        Text(
          model.StudentName,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      );
    }
    if (model.PStatusCode.isNotEmpty) {
      rowWidget.add(
        Text(
          'Status : ${model.PStatusCode}',
          style: LightColors.textSmallStyle,
        ),
      );
    }
    if (model.Remarks.isNotEmpty) {
      rowWidget.add(
        Text(
          'Remarks : ${model.Remarks}',
          style: LightColors.textSmallStyle,
        ),
      );
    }
    return rowWidget;
  }

  bool isSelectAll = false;

  final List<int> _group = [];
  final List<int> _value = [];
  List<SaveWhatWentWellModel> getSelectedOptions() {
    List<SaveWhatWentWellModel> list = [];
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
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
      for (int index = 0; index < Observation.length; index++) {
        if (index == 0) {
          //for (int jIndex = 0; jIndex < _group.length; jIndex++) {
          _group[mIndex] = index;
          //}
        } else {
          for (int jIndex = 0; jIndex < _group.length; jIndex++) {
            if (!isChecked) _group[mIndex] = 999;
          }
        }
      }
    }
  }

  updateFeedback() {
    Utility.showLoaderDialog(context);
    List<HomeWorkStudentModel> studentInfoList = [];
    for (int index = 0; index < mList.length; index++) {
      debugPrint(
          'Student Name ${mList[index].StudentName} : ${mList[index].Remarks}');
      if (mList[index].Remarks.isNotEmpty) studentInfoList.add(mList[index]);
    }
    UpdateHomeworkStudentRequest request = UpdateHomeworkStudentRequest(
        HomeworkID: widget.model.HomeworkID,
        TransType: 'T',
        TeacherID: teacherId,
        UserID: uid,
        ProgramID: programId.toString(),
        InputDate:
            DateFormat("yyyy-MM-dd'T'hh:mm:ss.sss'Z'").format(DateTime.now()),
        InputData: studentInfoList);
    APIService apiService = APIService();
    apiService.updateHomeWorkStudentModel(request, token).then((value) {
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
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  @override
  void onClick(int action, value) {
//     debugPrint('onclick ${action} ${value}');
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
