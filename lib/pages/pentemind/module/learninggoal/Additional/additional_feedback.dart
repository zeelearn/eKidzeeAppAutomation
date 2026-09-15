import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/developmental/DevelopmentalFeedbackRequest.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/developmental/developmental_student_list.dart';
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
import '../../../../../api/response/pentemind/learninggoals/developmental/DevelopmentalStudentListResponse.dart';
import '../../../../../api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/DatabaseHelper.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../notification/NotificationService.dart';
import 'additional.dart';

class DevelopmentalFeedback extends StatefulWidget {
  int day;
  String observation;
  LearningGoal model;

  DevelopmentalFeedback(
      {super.key,
      required this.day,
      required this.observation,
      required this.model});

  @override
  _DevelopmentalFeedbackState createState() => _DevelopmentalFeedbackState();
}

class _DevelopmentalFeedbackState extends State<DevelopmentalFeedback>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  double headerWidth = 0;
  double rowWidth = 0;

  List<FacilatorObservation> Observation = [];
  List<DevelopmentalStudentModel> mList = [];
  DevelopmentalStudentListResponse? mResponse;
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';

  String studentId = '';
  String className = '';
  int programId = 0;

  DevelopmentalStudentModel? _mModel;
  final List<TextEditingController> _controllers = [];

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
    //debugPrint('Details ovbersion '+widget.observation);
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
      getDevelopmentalStudentList();
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
    getStudentList();
  }

  getStudentList() async {
    bool isInternetAvaliability = await Utility.isInternet();
    var childAdvancementSummery = prefs.getString(getId());
    bool isOfflineEligble = await Utility.isOfflineEligble(
        context, prefs.getString('sync_${getId()}') ?? '');
    if (isOfflineEligble && childAdvancementSummery != null) {
      getLocalData(childAdvancementSummery);
    } else if (isInternetAvaliability || childAdvancementSummery == null) {
      getDevelopmentalStudentList();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      DevelopmentalStudentListResponse response =
          DevelopmentalStudentListResponse.fromJson(
        json.decode(data!),
      );
      mResponse = response;
      mList.clear();
      //mList.add(DevelopmentalStudentModel(D: 0, StudentID: '0', StudentName: 'Student Name', ParentName: '', MobileNo: '', Rating: '', enumRating: '', IsPresent: true, LGDID: 0));
      if (response.data[0].StudentName != 'Student Name') {
        mList.add(DevelopmentalStudentModel(
            D: 0,
            StudentID: '0',
            StudentName: 'Student Name',
            ParentName: '',
            MobileNo: '',
            Rating: '',
            enumRating: '',
            IsPresent: false,
            LGDID: 0));
      }
      mList.addAll(response.data);
      generateRadio();
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${widget.model.LGDID}_${programId.toString()}_${LocalConstant.MENU_LG_DEVELOPMENTAL_STUDLIST}';
  }

  savechildAdvancementSummery(String json) async {
    if (json != 'null' && json.isNotEmpty) {
      //debugPrint(json);
      prefs.setString(getId(), json);
      prefs.setString('sync_${getId()}', Utility.formatDate());
    }
  }

  getDevelopmentalStudentList() async {
    if (!await Utility.isInternet()) {
      setState(() {
        isLoading = false;
      });
      Utility.showMessage(context, 'Please check Internet connection...');
    } else {
      isLoading = true;
      setState(() {});
      mList.clear();
      _group.clear();
      _value.clear();
      DevelopmentalStudentListRequest request = DevelopmentalStudentListRequest(
          UserID: uid,
          ProgramId: programId,
          LGDID: widget.model.LGDID,
          ObservationType: widget.observation,
          D: 0);
      APIService apiService = APIService();
      apiService
          .getLearningGoalDevelopmentalADDLStudentList(request, token)
          .then((value) {
        //debugPrint(value.toString());
        isLoading = false;
        if (value != null) {
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is DevelopmentalStudentListResponse) {
            DevelopmentalStudentListResponse response = value;
            mResponse = response;
            String json = jsonEncode(response);
            savechildAdvancementSummery(json);
            mList.clear();
            mList.add(DevelopmentalStudentModel(
                D: 0,
                StudentID: '0',
                StudentName: 'Student Name',
                ParentName: '',
                MobileNo: '',
                Rating: '',
                enumRating: '',
                IsPresent: true,
                LGDID: 0));
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
  }

  generateRadio() {
    for (int index = 0; index < mList.length; index++) {
      int defGroup = 999;
      for (int jIndex = 0; jIndex < Observation.length; jIndex++) {
        if (jIndex == 0 && mList[index].Rating == 'P') {
          defGroup = 0;
        } else if (jIndex == 1 && mList[index].Rating == 'E') {
          defGroup = 1;
        } else if (jIndex == 2 && mList[index].Rating == 'N') {
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

  final List<Filters> _chipsList = [
    Filters('P', 0, Colors.brown, false),
    Filters('E', 0, Colors.brown, false),
    Filters('N', 0, Colors.brown, false)
  ];

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
          title: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Text(
                widget.model.LearningGoals,
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
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
              checkColor: Colors.white, // color of tick Mark
              activeColor: kPrimaryLightColor,
              value: isSelectAll,
              onChanged: (bool? value) {
//                 debugPrint('status change ${value}');
                setState(() {
                  resetCheckbox();
                  isSelectAll = value!;
                  updateSelection(value);
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

  final List<String> _dynamicChips = ['P', 'E', 'N'];
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
            child: ListTile(
                title: SizedBox(
                  width: headerWidth,
                  child: MyWidget().richText(
                      mList[index].StudentName, LightColors.textSmallStyle),
                ),
                trailing: Wrap(
                  // spacing: 4.0,
                  // runSpacing: 2.0,
                  children:
                      List<Widget>.generate(_dynamicChips.length, (int mIndex) {
                    return index == 0
                        ? SizedBox(
                            width: rowWidth,
                            child: Center(
                              child: MyWidget().richText(
                                  _chipsList[mIndex].label,
                                  LightColors.textSmallStyle),
                            ),
                          )
                        : SizedBox(
                            width: rowWidth,
                            child: Radio(
                                value: _value[mIndex],
                                groupValue: _group[index],
                                onChanged: (value) {
                                  mList[index].Rating = _dynamicChips[mIndex];
                                  isSelectAll = false;
                                  //debugPrint('Rating update ${index} ${mList[index].Rating}');
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
//     debugPrint('isChecked ${isChecked}');
    for (int mIndex = 1; mIndex < mList.length; mIndex++) {
      for (int index = 0; index < Observation.length; index++) {
        if (index == 0) {
          //for (int jIndex = 0; jIndex < _group.length; jIndex++) {
          _group[mIndex] = index;
          //}
        } else {
          for (int jIndex = 0; jIndex < _group.length; jIndex++) {
            if (isChecked) {
              _group[mIndex] = 0;
              mList[mIndex].Rating = 'P';
            } else {
              _group[mIndex] = 999;
              mList[mIndex].Rating = '';
            }
          }
        }
      }
    }
    setState(() {
//       debugPrint('isChecked--- ${isChecked}');
    });
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

  setSelection(DevelopmentalStudentModel model) {
    _mModel = model;
  }

  updateTag() {
    widget.model.tlg[0].P = 0;
    widget.model.tlg[0].E = 0;
    widget.model.tlg[0].N = 0;
    for (int index = 1; index < mList.length; index++) {
      if (mList[index].Rating == 'P') {
        widget.model.tlg[0].P++;
      } else if (mList[index].Rating == 'E') {
        widget.model.tlg[0].E++;
      } else if (mList[index].Rating == 'N') {
        widget.model.tlg[0].N++;
      }
    }
  }

  updateFacilatorSays() async {
    List<DevelopmentalStudentModel> feedbackList = [];
    Map<String, String> userMap = {};
    for (int index = 0; index < mList.length; index++) {
      if (mList[index].Rating != null && mList[index].Rating!.isNotEmpty) {
//         debugPrint('Rating--- ${mList[index].StudentName} ${mList[index].Rating}');
        DevelopmentalStudentModel model = mList[index];
        model.LGDID = widget.model.LGDID;
        if (!userMap.containsKey(mList[index].StudentID)) {
          feedbackList.add(mList[index]);
          userMap.putIfAbsent(
              mList[index].StudentID, () => mList[index].StudentID);
        }
      } else {
//         debugPrint('Rating ${mList[index].StudentName} ${mList[index].Rating}');
      }
    }
    if (feedbackList.isEmpty) {
      Utility.showAlertDialog(context, 'Please Select Observation ');
    } else {
      Utility.showLoaderDialog(context);
      setState(() {
        isLoading = true;
      });

      updateTag();
      DevelopmentalFeedbackRequest request = DevelopmentalFeedbackRequest(
          TeacherId: teacherId,
          UserId: uid,
          ProgramID: programId,
          ObservationType: widget.observation,
          feedbackList: feedbackList);

      bool isInternet = await Utility.isInternet();
      mResponse?.data = mList;
      String json = jsonEncode(mResponse);
      savechildAdvancementSummery(json);
      if (json == 'null' || json.isEmpty) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context, widget.model);
      } else if (!isInternet) {
        mResponse?.data = mList;
        String json = jsonEncode(mResponse);
        savechildAdvancementSummery(json);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        DBHelper dbHelper = DBHelper();
        dbHelper.insertSyncData(request.toJson(),
            LocalConstant.ACTION_OFFLINE_DEVELOPMENTAL, int.parse(teacherId));
        Utility.getConfirmationDialog(
            context,
            'Additional Learning Goal Request Received!',
            'Additional Learning Goals update request reveiced, it will be updated once Internet connection is established.',
            this);
        NotificationService notificationService = NotificationService();
        notificationService.showNotification(
            1409,
            'Additional Learning Goal Request Received!',
            'Additional Learning Goals update request reveiced, it will be updated once Internet connection is established.',
            'Additional Learning Goals update request reveiced, it will be updated once Internet connection is established.');
        //initializeService();
        setState(() {
          isLoading = false;
        });
      } else {
        APIService apiService = APIService();
        apiService
            .insertDevelopmentalFeedback(request.toJson(), token)
            .then((value) {
          isLoading = false;
          if (value != null) {
            if (value == null) {
              Utility.showMessage(context, 'data not found');
            } else if (value is GenericResponse) {
              GenericResponse response = value;
              if (response.success == 200) {
                Navigator.pop(context, widget.model);
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
      try {
        Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
      } catch (e) {
        Navigator.pop(context, widget.model);
      }
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
