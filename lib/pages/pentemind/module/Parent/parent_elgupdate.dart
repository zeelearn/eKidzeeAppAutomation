import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/elg_stud_list.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/update_elg.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../Responsive.dart';
import '../../../../api/response/pentemind/parent/elg_stud_response.dart';
import '../../../../api/response/pentemind/parent_corner/elg_response.dart';

class ParentELGUpdateScreen extends StatefulWidget {
  ElgModel model;
  String culmination;

  ParentELGUpdateScreen(
      {super.key, required this.model, required this.culmination});

  @override
  _ParentELGUpdateScreenState createState() => _ParentELGUpdateScreenState();
}

class _ParentELGUpdateScreenState extends State<ParentELGUpdateScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<FacilatorObservation> Observation = [];
  List<ElgStudentModel> mList = [];
  bool isLoading = true;
  bool isPresent = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  int classId = 0;
  String userType = '';
  String token = '';

  int studentId = 0;
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
        RefKey: "Rarely", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "Sometimes", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "Always", RefCount: 0, Remarks: "", isChecked: false));
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
      //getElgData();
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
    studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;

    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getElgData();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      ELGStudResponse response = ELGStudResponse.fromJson(
        json.decode(data!),
      );
      mList.addAll(response.data);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_PARENT_ELG}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getElgData() {
//     debugPrint('elg Data asdkalkdnmakldnklandkandlamsld');
    mList.clear();
    isLoading = true;
    setState(() {});
    ELGStudRequest request = ELGStudRequest(
        UserID: uid,
        ProgramId: programId.toString(),
        PCID: widget.model.PCID,
        C: int.parse(widget.culmination),
        StudentID: studentId.toString());
    APIService apiService = APIService();
    apiService.getElgStudentListRequest(request, token).then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is ELGStudResponse) {
          ELGStudResponse response = value;
          //String json = jsonEncode(response);
          /*savechildSummery(json);*/
          mList.addAll(response.data);
          generateRadio();
//           debugPrint('list is ${mList.length}');
          setState(() {});
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  generateRadio() {
    for (int index = 0; index < mList[0].OBSRN.length; index++) {
      int defGroup = 900;
/*      if(mList!=0 && mList[index].IsPresent){
        isPresent = true;
      }*/
      for (int jIndex = 0; jIndex < Observation.length; jIndex++) {
        if (jIndex == 0 && mList[0].OBSRN[index].StatusCode == 'R') {
//           debugPrint('SI FOUNBD.......................');
          defGroup = 1;
        } else if (jIndex == 1 && mList[0].OBSRN[index].StatusCode == 'S') {
          defGroup = 2;
        } else if (jIndex == 2 && mList[0].OBSRN[index].StatusCode == 'A') {
          defGroup = 3;
        }
        if (index == 0) {
          _value.add((index + jIndex) + 1);
        } else {
          _value.add((index * jIndex));
        }
      }
      _group.add(defGroup);
    }
//     debugPrint('value length ${_value.length}');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Developmental Feedback');
    headerWidth = Responsive.isMobile(context)
        ? (MediaQuery.of(context).size.width * 45 / 100)
        : (MediaQuery.of(context).size.width * 53 / 100);
    rowWidth = Responsive.isMobile(context)
        ? ((MediaQuery.of(context).size.width * 45 / 100) / 3)
        : ((MediaQuery.of(context).size.width * 40 / 100) / 3);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Observations',
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
              getElgData();
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
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Parent observations",
                  style: TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "*kindly mark the observations",
                  style: TextStyle(
                    fontSize: 12,
                    color: LightColors.kRed,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      width: headerWidth,
                      child: MyWidget().richText(
                          'Observations', LightColors.textSmallStyle)),

                  SizedBox(
                      width: rowWidth,
                      child: Center(
                          child: Text('Rarely',
                              style: LightColors.textvSmallStyle))),
                  SizedBox(
                      width: rowWidth,
                      child: Center(
                          child: Text('Sometimes',
                              style: LightColors.textvSmallStyle))),
                  SizedBox(
                      width: rowWidth,
                      child: Center(
                          child: Text('Always',
                              style: LightColors.textvSmallStyle)))

                  // Wrap(spacing: 15.0, runSpacing: 2.0, children: [
                  //
                  // ]),
                ],
              )),
          getContentRow(),
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
                        backgroundColor: kPrimaryLightColor,
                      ),
                      onPressed: () {
                        updateFeedback();
                      },
                      child: Text('Submit',
                          style: LightColors.textHeaderStyle13
                              .copyWith(color: Colors.white)))))
        ]),
      );
    }
  }

  getContentRow() {
    return Flexible(
        child: ListView.builder(
            itemCount: mList[0].OBSRN.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: LightColors.kHeaderColor)),
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                        width: headerWidth,
                        child: MyWidget().richText(
                            mList[0].OBSRN[index].Observation,
                            LightColors.textSmallStyle)),
                    Wrap(
                      // spacing: 4.0,
                      // runSpacing: 2.0,
                      children: List<Widget>.generate(_dynamicChips.length,
                          (int mIndex) {
                        return SizedBox(
                          width: rowWidth,
                          child: Center(
                            child: Radio(
                                value: _value[mIndex],
                                groupValue: _group[index],
                                onChanged: (value) {
                                  debugPrint(getCode(_dynamicChips[mIndex]));
                                  mList[0].OBSRN[index].StatusCode =
                                      getCode(_dynamicChips[mIndex]);
                                  setState(() {
                                    // debugPrint(value);
                                    // debugPrint(value);
                                    _group[index] = value as int;
                                  });
                                }),
                          ),
                        );
                      }),
                    )
                  ],
                )),
              );
            }));
  }

  getCode(String value) {
    String code = '';
    if (value == 'Rarely')
      code = 'R';
    else if (value == 'Sometimes')
      code = 'S';
    else if (value == 'Always') code = 'A';
    return code;
  }

  int id = 1;
  final List<String> _dynamicChips = ['Rarely', 'Sometimes', 'Always'];

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
      for (int index = 0; index < Observation.length; index++) {
        if (index == 0) {
          //for (int jIndex = 0; jIndex < _group.length; jIndex++) {
          _group[mIndex] = 0;
          //}
        } else {
          for (int jIndex = 0; jIndex < _group.length; jIndex++) {
            if (!isChecked) _group[mIndex] = 1;
          }
        }
      }
    }
  }

  updateFeedback() {
    Utility.showLoaderDialog(context);
    UpdateElgObservationRequest request = UpdateElgObservationRequest(
        ProgramId: programId,
        Class_Id: classId,
        User_ID: uid,
        StudentID: studentId,
        OBSRN: mList[0].OBSRN);
    APIService apiService = APIService();
    apiService.updateParentCorner(request, token).then((value) {
      isLoading = false;
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            Navigator.pop(context, 'DONE');
            try {
              Utility.showMessage(
                  context,
                  response.response is String
                      ? response.response
                      : response.response.response.toString());
            } catch (e) {
              Utility.showMessage(
                  context,
                  response.response is String
                      ? response.response
                      : response.response.response.toString());
            }
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
    debugPrint('onclick ${action} ${value}');
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
