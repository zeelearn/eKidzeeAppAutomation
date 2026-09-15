import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/facilatorsays/GetAnecdotalStudentList.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Responsive.dart';
import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/GetAnecdotalStudentResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';

class FacilatorSaysMindFeedbackScreen extends StatefulWidget {
  String term;
  FacilatorSaysModel facilatorSaysModel;
  List<FacilatorObservation> Observation;

  FacilatorSaysMindFeedbackScreen(
      {super.key,
      required this.term,
      required this.facilatorSaysModel,
      required this.Observation});

  @override
  _FacilatorSaysMindFeedbackScreenState createState() =>
      _FacilatorSaysMindFeedbackScreenState();
}

class _FacilatorSaysMindFeedbackScreenState
    extends State<FacilatorSaysMindFeedbackScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  double header = 0;
  double row = 0;

  List<AnecdotalStudentModel> mList = [];
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';

  String studentId = '';
  String className = '';
  int programId = 0;

  AnecdotalStudentModel? _mModel;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
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
//     debugPrint('_AnnouncementListState didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getAnecdotalStudentList();
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
      getAnecdotalStudentList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      GetAnecdotalStudentResponse response =
          GetAnecdotalStudentResponse.fromJson(
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
    return '${uid.toString()}_${LocalConstant.MENU_LG_FACILATOR_SAYS}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getAnecdotalStudentList() {
    isLoading = true;
    setState(() {});
    mList.clear();
    _group.clear();
    _value.clear();
    GetAnecdotalStudentList request = GetAnecdotalStudentList(
        UserID: uid,
        ProgramID: programId,
        InputType: 'FAC_SAYS',
        RefKey: widget.facilatorSaysModel.Mind,
        Term: widget.term);
    APIService apiService = APIService();
    apiService.getStudentListAnacdotal(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
//         debugPrint('value is not null $value');
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GetAnecdotalStudentResponse) {
//           debugPrint('in child info');
          GetAnecdotalStudentResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          mList.addAll(response.data);
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
      int defValue = 900;
      for (int jIndex = 0; jIndex < widget.Observation.length; jIndex++) {
        if (mList[index].RefValue == widget.Observation[jIndex].RefKey) {
          if (index == 0) {
            _value.add(jIndex);
            defValue = jIndex;
          } else {
            _value.add(jIndex);
            defValue = jIndex;
          }
        } else {
          if (index == 0) {
            _value.add(jIndex);
          } else {
            _value.add(jIndex);
          }
        }

//         debugPrint(' ${(index + jIndex)}_value ${_value[index + jIndex]}');
      }
      _group.add(defValue);
    }
    //debugPrint('array is ${_value}');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent(
        'Facilitator Says ${widget.facilatorSaysModel.Mind}');
    header = Responsive.isMobile(context)
        ? (MediaQuery.of(context).size.width * 45 / 100)
        : (MediaQuery.of(context).size.width * 53 / 100);
    row = Responsive.isMobile(context)
        ? ((MediaQuery.of(context).size.width * 45 / 100) / 5)
        : ((MediaQuery.of(context).size.width * 40 / 100) / 5);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.facilatorSaysModel.Mind,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          // You can add title here
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
              getAnecdotalStudentList();
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
      for (int index = 0; index < mList.length; index++) {
        mList[index].group = (1000 * 2) + index;
      }
      return Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          getHeader(),
          getSelection(),
          getContentRow(),
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
        ]),
      );
    }
  }

  int id = 1;

  getHeader() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: LightColors.kHeaderColor)),
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
              width: header,
              child: Center(
                child: MyWidget()
                    .richText('Student Name', LightColors.textSmallStyle),
              )),
          Wrap(
            spacing: 4.0,
            runSpacing: 2.0,
            alignment: WrapAlignment.center,
            children:
                List<Widget>.generate(widget.Observation.length, (int mIndex) {
              return SizedBox(
                  width: row,
                  child: Center(
                    child: Text(widget.Observation[mIndex].RefKey,
                        style: LightColors.textSmallStyle),
                  ));
            }),
          )
        ],
      )),
    );
  }

  getSelection() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: LightColors.kHeaderColor)),
      //padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
              width: header,
              child: Center(
                child: MyWidget()
                    .richText('Select All', LightColors.textbuttonStyle),
              )),
          Wrap(
            // spacing: 4.0,
            // runSpacing: 2.0,
            children:
                List<Widget>.generate(widget.Observation.length, (int mIndex) {
              return SizedBox(
                // margin: const EdgeInsets.all(5),
                width: row,
                child: Radio(
                    value: mIndex,
                    groupValue: _selection[mIndex],
                    onChanged: (value) {
                      //mList[index].StatusCode = _dynamicChips[mIndex];

                      setState(() {
                        resetSelection();
                        _selection[mIndex] = value as int;
                        updateSelectionAll(value, mIndex);
                      });
                    }),
              );
            }),
          )
        ],
      )),
    );
  }

  resetSelection() {
    for (int index = 0; index < _selection.length; index++) {
      _selection[index] = -1;
    }
  }

  updateSelectionAll(int value, int mIndex) {
    for (int index = 0; index < _group.length; index++) {
      _group[index] = value;
      if (widget.Observation[mIndex].Remarks.isNotEmpty) {
        _textEditingControllerList[index].text =
            widget.Observation[mIndex].Remarks;
      }
    }
  }

  final List<TextEditingController> _textEditingControllerList = [];
  generateTextController() {
    for (int index = 0; index < mList.length; index++) {
      TextEditingController controller = TextEditingController();
      controller.text = mList[index].Remarks;
      _textEditingControllerList.add(controller);
    }
  }

  getContentRow() {
    generateTextController();
    return Flexible(
        child: ListView.builder(
            itemCount: mList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: LightColors.kHeaderColor)),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                            child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                                width: header - 10,
                                child: MyWidget().richText(
                                    mList[index].StudentName,
                                    LightColors.textHeaderStyle13)),
                            Wrap(
                              // spacing: 4.0,
                              // runSpacing: 2.0,
                              children: List<Widget>.generate(
                                  widget.Observation.length, (int mIndex) {
                                return SizedBox(
                                  //margin: const EdgeInsets.all(5),
                                  width: row,
                                  child: Radio(
                                      value: _value[mIndex],
                                      groupValue: _group[index],
                                      onChanged: (value) {
                                        //mList[index].StatusCode = _dynamicChips[mIndex];
                                        setState(() {
                                          // debugPrint(value);
                                          // debugPrint(value);
                                          _textEditingControllerList[index]
                                                  .text =
                                              widget
                                                  .Observation[mIndex].Remarks;
                                          _group[index] = value as int;
                                        });
                                      }),
                                );
                              }),
                            )
                          ],
                        )),
                      ),
                      MyWidget().normalTextField(
                          context,
                          mList[index].Remarks.isEmpty
                              ? 'Enter Remark'
                              : mList[index].Remarks,
                          _textEditingControllerList[index])
                    ],
                  ),
                ),
              );
            }));
  }

  final List<int> _group = [];
  final List<int> _value = [];
  final List<int> _selection = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0];

  List<SaveWhatWentWellModel> getSelectedOptions() {
    List<SaveWhatWentWellModel> list = [];
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
      for (int index = 0; index < widget.Observation.length; index++) {
        if (_group[mIndex] == index) {
          list.add(SaveWhatWentWellModel(
              RefKey: widget.facilatorSaysModel.Mind,
              RefValue: widget.Observation[index].RefKey,
              StudentID: int.parse(mList[mIndex].StudentID),
              Term: widget.term,
              Remarks:
                  _textEditingControllerList[mIndex].text.toString() ?? ''));
          debugPrint(
              'Result is ${mList[mIndex].StudentName} Mind ${widget.Observation[index].RefKey}');
        }
      }
    }
    return list;
  }

  resetCheckbox() {
    for (int index = 0; index < widget.Observation.length; index++) {
      widget.Observation[index].isChecked = false;
    }
  }

  updateSelection(bool isChecked) {
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
      for (int index = 0; index < widget.Observation.length; index++) {
        if (widget.Observation[index].isChecked) {
          //for (int jIndex = 0; jIndex < _group.length; jIndex++) {
          _group[mIndex] = index;
          //}
        } else {
          for (int jIndex = 0; jIndex < _group.length; jIndex++) {
            if (!isChecked) {
              _group[mIndex] = 999;
            }
          }
        }
      }
    }
  }

  setSelection(AnecdotalStudentModel model) {
    _mModel = model;
  }

  updateFacilatorSays() {
    Utility.showLoaderDialog(context);
    List<SaveWhatWentWellModel> list = getSelectedOptions();
    SaveWhatWentWellRequest request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: 'FAC_SAYS',
        wwwModel: list);

    APIService apiService = APIService();
    apiService.insertStudentAnecdotal(request, token).then((value) {
      debugPrint(value.toString());
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

  @override
  void onClick(int action, value) {
//     debugPrint('onclick $action $value');
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
