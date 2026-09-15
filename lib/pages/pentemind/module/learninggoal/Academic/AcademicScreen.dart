import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/AcademicRequest/GetAcademicRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/request/pentemind/get_culmination.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/culmination_response.dart';
import '../../../../../api/response/pentemind/learninggoals/academic/GetAcademicResponse.dart';
import '../../../../../api/response/pentemind/learninggoals/academic/GetAcademicStudentListResponse.dart';
import '../../../../../api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import 'academic_feedback.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  _AcademicScreenScreenState createState() => _AcademicScreenScreenState();
}

class _AcademicScreenScreenState extends State<AcademicScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isInternet = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  int programId = 0;
  String _lasySyncDate = '';
  String _culminationName = 'Select Culmination';
  List<String> culminationList = [];
  GetAcademicResponse? mAcademaicResponse;
  final TextEditingController _dayController = TextEditingController();
  List<String> observations = [];
  int ACTION_OBSERVATION = 100;
  int ACTION_CULMINATION = 101;

  CulminationResponse? _mCulminations;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//     debugPrint('_Academic Screen didChangeAppLifecycleState ');
    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    term = prefs.getString(LocalConstant.KEY_CURRENT_TERM) as String;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    _dayController.text = '1';
    culminationList.clear();
    culminationList.add('Select Culmination');
    culminationList.add('Culmination 1');
    culminationList.add('Culmination 2');
    culminationList.add('Culmination 3');
    culminationList.add('Culmination 4');
    culminationList.add('Culmination 5');
    culminationList.add('Culmination 6');
    getofflineCulminations();
  }

  getCulminationList() async {
//     debugPrint('online culmination ');
    if (await Utility.isInternet()) {
      GetCulminationRequest request = GetCulminationRequest(termType: term);
      APIService apiService = APIService();
      apiService.getCulmination(request, token).then((value) {
        if (value != null) {
          if (value is CulminationResponse) {
//             debugPrint('in Culres');
            CulminationResponse response = value;
            _mCulminations = response;
            if (response.data != null) {
              saveCulminationSummery(jsonEncode(_mCulminations));
              culminationList.clear();
              culminationList.add('Select Culmination');
              for (int index = 0; index < response.data!.length; index++) {
                culminationList.add(response.data![index].culminationName!);
              }
            }
          }
          setState(() {
            isLoading = false;
            //getDropDown();
          });
//           debugPrint('options ${culminationList.toString()}');
        } /* else {
          getofflineCulminations();
        }*/
      });
    } else {
      // getofflineCulminations();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('_Academic Screen didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getofflineCulminations();
    }
  }

  Future<void> getSkillDropdown() async {
//     debugPrint('get------Dropdown-----');
    var childAdvancementSummery = prefs.getString(getId());
    _lasySyncDate = prefs.getString('sync_${getId()}') ?? '';
//     debugPrint('sync key is   sync_${getId()}');
    debugPrint(childAdvancementSummery);
    bool isOfflineEligble = await Utility.isOfflineEligble(
        context, prefs.getString('sync_${getId()}') ?? '');
//     debugPrint('isOffline ${isOfflineEligble}');
    if (childAdvancementSummery != null && isOfflineEligble) {
      getLocalData(childAdvancementSummery);
      setState(() {
        isLoading = false;
      });
    } else {
      getDropDownList();
    }
  }

  Future<void> getofflineCulminations() async {
//     debugPrint('get------offline Culmination Dropdown-----');
    var offlineCulminationList = prefs.getString(getCulminationOfflineId());
    debugPrint('getofflineCulminations are $culminationList');
    if (true) {
      try {
        isLoading = false;
        debugPrint('in 171 $offlineCulminationList');
        debugPrint(json.decode(offlineCulminationList!));
        CulminationResponse response = CulminationResponse.fromJson(
          json.decode(offlineCulminationList!),
        );
        debugPrint('offline culmination response ${response.toJson()}');
        if (response.data != null) {
          _mCulminations = response;
          culminationList.clear();
          culminationList.add('Select Culmination');
          for (int index = 0; index < response.data!.length; index++) {
            culminationList.add(response.data![index].culminationName!);
          }
          debugPrint('offline culmination ');
        }
        getSkillDropdown();
      } catch (e) {
        setState(() {});
        getCulminationList();
      }
    } else {
      getCulminationList();
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      isLoading = false;
      GetAcademicResponse response = GetAcademicResponse.fromJson(
        json.decode(data!),
      );
//       debugPrint('Local data Academic ${mAcademaicResponse?.toJson()}');
      mAcademaicResponse = response;
      generateObservation();
      getSortedList();
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  getCulminationId(String value) {
    String returnValue = value;
    if (_mCulminations != null && _mCulminations!.data != null) {
      for (int index = 0; index < _mCulminations!.data!.length; index++) {
        if (value == _mCulminations!.data![index].culminationName) {
          returnValue = _mCulminations!.data![index].c.toString();
        }
      }
      return returnValue;
    } else {
      return value.replaceAll("Culmination ", "");
    }
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_LG_ACEDEMIC}_${programId}_${getCulminationId(_culminationName)}';
  }

  String getCulminationOfflineId() {
    return '${uid.toString()}_${LocalConstant.MENU_LG_ACEDEMIC}_$programId';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
    prefs.setString('sync_${getId()}', Utility.formatDate());
//     debugPrint('Key is sync_${getId()}');
    setState(() {
      _lasySyncDate = Utility.formatDate();
    });
  }

  saveCulminationSummery(String json) async {
    prefs.setString(getCulminationOfflineId(), json);
  }

  String _observation = 'Select Category';
  final List<String> _skill = [];

  getSortedList() {
    mSortedSkill.clear();
    _skill.clear();
    _skill.add('Select Category');
//     debugPrint('${_observation} skill ${_skill}');
//     debugPrint('in Sorted list ${mAcademaicResponse!.toJson()}');
    if (mAcademaicResponse != null)
      for (int index = 0;
          index < mAcademaicResponse!.learningGoalModel.length;
          index++) {
        if (_observation ==
            mAcademaicResponse!.learningGoalModel[index].ALGCategoryName) {
          if (!_skill.contains(
              mAcademaicResponse!.learningGoalModel[index].LearningGoals)) {
            mSortedSkill.add(mAcademaicResponse!.learningGoalModel[index]);
            _skill.add(
                mAcademaicResponse!.learningGoalModel[index].LearningGoals);
          }
        }
      }
//     debugPrint('in Sorted list ${mSortedSkill.length}');
    setState(() {});
  }

  generateObservation() {
    observations.clear();
    observations.add('Select Category');
    for (int index = 0;
        index < mAcademaicResponse!.learningGoalModel.length;
        index++) {
      if (!observations.contains(
          mAcademaicResponse!.learningGoalModel[index].ALGCategoryName)) {
        observations
            .add(mAcademaicResponse!.learningGoalModel[index].ALGCategoryName);
      }
    }
  }

  getDropDownList() async {
//     debugPrint('get------online Culmination Dropdown-----');
    if (!await Utility.isInternet()) {
      //getSkillDropdown();
      isInternet = false;
      setState(() {
        isLoading = false;
      });
    } else if (_culminationName == 'Select Culmination') {
      setState(() {
        isLoading = false;
      });
    } else {
//       debugPrint('Culmination Name ${_culminationName}');
      isInternet = true;
      isLoading = true;
      setState(() {});
      GetAcademicRequest request = GetAcademicRequest(
          ProgramID: programId,
          D: getCulminationId(
              _culminationName) /*_dayController.text
              .toString()
              .isEmpty ? '1' : _dayController.text.toString()*/
          ,
          LGAID: "0",
          UserID: int.parse(uid));
      APIService apiService = APIService();
      apiService.getLearningGoalAcademicDropdown(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is GetAcademicResponse) {
            GetAcademicResponse response = value;
            String json = jsonEncode(response);
            savechildSummery(json);
            mAcademaicResponse = response;
            generateObservation();
            getSortedList();
            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LG-Adademic');
    return Scaffold(
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
              getDropDownList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  getHeader(),
                  getChildList(),
                ],
              ),
            ),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (_culminationName == 'Select Culmination' ||
        _observation == 'Select Category') {
      return Utility.filter(
          context,
          _culminationName == 'Select Culmination'
              ? 'Please Select the Culmination'
              : _observation == 'Select Category'
                  ? 'Please Select Category'
                  : "Data are not available at this moment please check later");
    } else if (mAcademaicResponse == null) {
      return Utility.emptyData(
          context,
          !isInternet
              ? LocalConstant.NO_INTERNET
              : "Data are not available at this moment please check later");
    } else if (!isInternet && mSortedSkill == null) {
      return Utility.noInternet(context);
    } else {
      return getContent();
    }
  }

  reset() {}

  getHeader() {
    //debugPrint(culminationList);
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2, // 30%
            child: Text(''),
          ),
          Expanded(
            flex: 30, // 30%
            child: MyWidget().getDropdownButton('Select Culmination',
                _culminationName, culminationList, ACTION_CULMINATION, this),
          ),
          Expanded(
            flex: 2, // 30%
            child: Text(''),
          ),
          Expanded(
            flex: 66, // 70%
            child: MyWidget().getDropdownButton('Select Observation',
                _observation, observations, ACTION_OBSERVATION, this),
          ),
          Expanded(
            flex: 2, // 30%
            child: Text(''),
          ),
        ],
      ),
    );
  }

  final List<String> _dynamicChips = ['S1', 'S2', 'S3'];
  final List<Color> _colorChips = [
    LightColors.kGreen,
    LightColors.kBlue,
    LightColors.kRed
  ];
  List<AcademicLearningGoalsModel> mSortedSkill = [];

  getContent() {
    return Flexible(
        child: ListView.builder(
      itemCount: mSortedSkill.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AcademicFeedback(
                        model: mSortedSkill[i],
                        day: int.parse(
                            getCulminationId(_dayController.text.toString())),
                      )),
            ).then((value) {
              //do something after resuming screen
              if (value is GetAcademicStudentListResponse) {
                GetAcademicStudentListResponse response = value;
                updateCount(response);
              } else {
                getDropDownList();
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Card(
              color: Colors.white,
              child: ListTile(
                  title: MyWidget().richText(mSortedSkill[i].LearningGoals,
                      LightColors.textSmallStyle),
                  trailing: Wrap(
                    spacing: 4.0,
                    runSpacing: 2.0,
                    children: List<Widget>.generate(_dynamicChips.length,
                        (int index) {
                      return Chip(
                        shadowColor: Colors.red,
                        backgroundColor: Colors.white70,
                        color: WidgetStateProperty.resolveWith(
                            (states) => Colors.white),
                        shape: StadiumBorder(
                            side: BorderSide(color: LightColors.kLightGray1)),
                        avatar: CircleAvatar(
                          backgroundColor: LightColors.kLightGrayM,
                          child: Image.asset(
                            "assets/icons/pentemind/Smile${index + 1}.png",
                            height: 28,
                            width: 28,
                          ),
                        ),
                        label: Text(getTagValue(mSortedSkill[i], index),
                            style: GoogleFonts.roboto(
                              fontSize: 10.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            )),
                      );
                    }),
                  )),
            ),
          ),
        );
      },
    ));
  }

  String getTagValue(AcademicLearningGoalsModel learningGoal, int index) {
    String value = '';
    //debugPrint(' ${learningGoal.S1}  ${learningGoal.S2}  ${learningGoal.S3}');
    if (index == 0) {
      value = learningGoal.S1.toString();
    } else if (index == 1) {
      value = learningGoal.S2.toString();
    } else if (index == 2) {
      value = learningGoal.S3.toString();
    }
    return value;
  }

  getRatingCard(LearningGoal goalModel) {
    return Row(
      children: [
        Chip(
          labelPadding: EdgeInsets.all(5.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade600,
            child: Text("P"),
          ),
          label: Text(
            "1",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: LightColors.kLightBlue,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: EdgeInsets.all(6.0),
        ),
      ],
    );
  }

  clearScreen() {
    setState(() {
      mAcademaicResponse = null;
      observations.clear();
      _skill.clear();
    });
  }

  @override
  void onClick(int action, value) {
    debugPrint('onclick $action $value');
    if (action == ACTION_CULMINATION) {
      _culminationName = value;
      debugPrint('ACTION_CULMINATION----$value');
      if (value == 'Select Culmination') {
        clearScreen();
      } else {
        _dayController.text = value.toString().replaceAll('Culmination ', '');
        //getofflineCulminations();
        getSkillDropdown();
        //getDropDown();
      }
    } else if (action == ACTION_OBSERVATION) {
      _observation = value;
      debugPrint(_observation);
      setState(() {
        generateObservation();
        getSortedList();
      });
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
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

  showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),*/
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 8,
        ),
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                list.length,
                (index) => Card(
                  borderOnForeground: true,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        //updateSelection(action, list[index]);
                      },
                      child: MyWidget()
                          .richText(list[index], LightColors.textbigStyle),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getInputBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                // content padding
                child: Form(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 4.5,
                      // color: Colors.red,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _dayController,
                              maxLines: 2,
                              minLines: 2,
                              decoration: InputDecoration(
                                  hintText: "Insert Culmination Day",
                                  border: InputBorder.none),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onFieldSubmitted: (val) {
                                setState(() {
                                  _dayController.text = val.toString();
                                  getSkillDropdown();
                                });
                              },
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Culmination Day can\'t be empty';
                                } else {
                                  _dayController.text = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.black,
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                  //updateSelection(ACTION_DAY, _dayController.text.toString());
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8)),
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 25,
                                child: Text("Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ));
        },
        context: context);
  }

  void updateCount(GetAcademicStudentListResponse response) {
    if (mAcademaicResponse != null &&
        mAcademaicResponse!.learningGoalModel.isNotEmpty) {
      for (int index = 0;
          index < mAcademaicResponse!.learningGoalModel.length;
          index++) {
        int s1 = mAcademaicResponse!.learningGoalModel[index].S1;
        int s2 = mAcademaicResponse!.learningGoalModel[index].S2;
        int s3 = mAcademaicResponse!.learningGoalModel[index].S3;
        for (int jIndex = 0; jIndex < response.studentInfo.length; jIndex++) {
          if (mAcademaicResponse!.learningGoalModel[index].LGAID ==
              response.studentInfo[jIndex].LGAID) {
            if (jIndex == 0) {
              s1 = 0;
              s2 = 0;
              s3 = 0;
            }
            if (response.studentInfo[jIndex].Rating == 'S1') {
              s1++;
            } else if (response.studentInfo[jIndex].Rating == 'S2') {
              s2++;
            } else if (response.studentInfo[jIndex].Rating == 'S3') {
              s3++;
            }
          }
        }
        mAcademaicResponse!.learningGoalModel[index].S1 = s1;
        mAcademaicResponse!.learningGoalModel[index].S2 = s2;
        mAcademaicResponse!.learningGoalModel[index].S3 = s3;
        savechildSummery(jsonEncode(mAcademaicResponse));
      }
    }

    setState(() {});
  }
}

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}
