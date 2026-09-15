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
import '../../../../api/request/pentemind/learninggoal/GetAnecdotalGeneralHealthAndHygieneResponse.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/GetAnecdotalStudentResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';

class HelthHygineFeedbackScreen extends StatefulWidget {
  String term;
  HealthAndHygieneModel model;
  String refKey;

  HelthHygineFeedbackScreen(
      {super.key,
      required this.term,
      required this.refKey,
      required this.model});

  @override
  _HelthHygineFeedbackScreenScreenState createState() =>
      _HelthHygineFeedbackScreenScreenState();
}

class _HelthHygineFeedbackScreenScreenState
    extends State<HelthHygineFeedbackScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  double headerWidth = 0;
  double rowWidth = 0;

  List<FacilatorObservation> Observation = [];
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
    Observation.add(FacilatorObservation(
        RefKey: "S1", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "S2", RefCount: 0, Remarks: "", isChecked: false));
    Observation.add(FacilatorObservation(
        RefKey: "S3", RefCount: 0, Remarks: "", isChecked: false));
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
//     debugPrint('_AnnouncementListState didChangeAppLifecycleState ${state} ');
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
        InputType: 'HEALTH',
        RefKey: widget.refKey,
        Term: widget.term);
    APIService apiService = APIService();
    apiService.getStudentListAnacdotal(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
//         debugPrint('value is not null ${value}');
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
      int defGroup = 999;

      for (int jIndex = 0; jIndex < Observation.length; jIndex++) {
        _value.add(jIndex);
        if (jIndex == 0 && mList[index].RefValue == 'S1') {
          defGroup = 0;
        } else if (jIndex == 1 && mList[index].RefValue == 'S2') {
          defGroup = 1;
        } else if (jIndex == 2 && mList[index].RefValue == 'S3') {
          defGroup = 2;
        }
      }
      _group.add(defGroup);
    }
    //debugPrint('array is ${_value}');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils()
        .sendAnalyticsEvent('Facilator Says ${widget.refKey}');
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
            widget.refKey,
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
      return SingleChildScrollView(
          child: Column(children: <Widget>[
        generateTable(),
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
      ]));

      //return generateTable();
      /*return ListView.builder(
            itemCount: mList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              _controllers.add(new TextEditingController());
              return generateListRow(mList[index], index);
            },
      );*/
    }
  }

  int id = 1;

  generateListRow(AnecdotalStudentModel model, int mIndex) {
    return Container(
        color: LightColors.kLightGray,
        child: Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                /*MyWidget()
                    .richText(model.StudentName, LightColors.textHeaderStyle),*/

                Container(
                    //width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(0),
                    child: DataTable(
                      columnSpacing: 0,
                      // datatable widget
                      columns: getHeaders(),

                      rows: getRows(mIndex, model.StudentName),
                    )),
                MyWidget().normalTextField(
                    context, 'Enter Remark here', _controllers[mIndex])
              ],
            )));
  }

  generateTable() {
    return Container(
        //width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(0),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 10,
              // datatable widget
              columns: getHeaders(),

              rows: getRowsStudent(),
            )));
//     return Container(
//         child: Card(
//             margin: EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 /*MyWidget()
//                     .richText(model.StudentName, LightColors.textHeaderStyle),*/
//
//                 Container(
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.all(0),
//                     child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 0,
//                           // datatable widget
//                           columns: getHeaders(),
//
//                           rows: getRowsStudent(),
//                         ))),
// /*                MyWidget().normalTextField(
//                     context, 'Enter Remark here', _controllers[mIndex])*/
//               ],
//             )));
  }

  bool isSelectAll = false;

  List<DataColumn> getHeaders() {
    List<DataColumn> list = [];
    list.add(
      DataColumn(
        columnWidth: FixedColumnWidth(headerWidth),
        label: Center(
            child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white, // color of tick Mark
              activeColor: kPrimaryLightColor,
              value: isSelectAll,
              onChanged: (bool? value) {
                setState(() {
                  resetCheckbox();
                  isSelectAll = value!;
                  updateSelection(value);
                });
              },
            ),
            Text('Select All')
          ],
        )),
      ),
    );
    for (int index = 0; index < Observation.length; index++) {
      list.add(
        DataColumn(
          columnWidth: FixedColumnWidth(rowWidth),
          label: Center(
            child: Text(
              '',
              style: LightColors.textvSmallStyle,
            ),
          ),
        ),
      );
    }
    return list;
  }

  final List<int> _group = [];
  final List<int> _value = [];

  List<DataRow> getRows(int mIndex, String name) {
    List<DataRow> list = [];
    List<DataCell> cell = [];
    cell.add(
      DataCell(
        SizedBox(
            width: headerWidth,
            child: MyWidget().richText(name, LightColors.textvSmallStyle)),
      ),
    );
    for (int index = 0; index < Observation.length; index++) {
      //_value.add(mIndex + index);
      //debugPrint('${index + mIndex} group is ${_group[mIndex]} values ${_value[mIndex + index]}');
      //debugPrint('value is ${_value[mIndex * index]} and ${_group[mIndex]}');
      cell.add(
        DataCell(
          Center(
            child: SizedBox(
              width: rowWidth,
              child: Radio(
                  value: _value[index + mIndex],
                  groupValue: _group[mIndex],
                  onChanged: (value) {
                    setState(() {
                      isSelectAll = false;
                      debugPrint(
                          'Click ${_group[mIndex]} and ${_value[mIndex + index]}  $value');
                      _group[mIndex] = value as int;
                      debugPrint(
                          'Click ${_group[mIndex]} and ${_value[mIndex + index]}  $value');
                    });
                  }),
            ),
          ),
        ),
      );
    }
    // debugPrint(_value);
    list.add(DataRow(cells: cell));
    return list;
  }

  List<SaveWhatWentWellModel> getSelectedOptions() {
    List<SaveWhatWentWellModel> list = [];
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
      for (int index = 0; index < Observation.length; index++) {
        if (_group[mIndex] == index) {
          list.add(SaveWhatWentWellModel(
              RefKey: widget.refKey,
              RefValue: Observation[index].RefKey,
              StudentID: int.parse(mList[mIndex].StudentID),
              Term: widget.term,
              Remarks: ''));
//             debugPrint('Result is ${mList[mIndex].StudentName} Mind ${Observation[index].RefKey}');
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
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
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

  List<DataRow> getRowsStudent() {
    List<DataRow> list = [];
    for (int mIndex = 0; mIndex < mList.length; mIndex++) {
      List<DataCell> cell = [];
      cell.add(
        DataCell(
          MyWidget()
              .richText(mList[mIndex].StudentName, LightColors.textSmallStyle),
        ),
      );
      if (mIndex == 0) {
        List<DataCell> cellHeader = [];
        cellHeader.add(
          DataCell(
            MyWidget().richText('', LightColors.textSmallStyle),
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
//                       debugPrint('Oupput is ${mIndex} ${_group[mIndex]}');
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

  setSelection(AnecdotalStudentModel model) {
    _mModel = model;
  }

  updateFacilatorSays() {
    List<SaveWhatWentWellModel> list = getSelectedOptions();
    if (list.isEmpty) {
      Utility.showAlertDialog(context, 'Please Select Observation ');
    } else {
      Utility.showLoaderDialog(context);
      SaveWhatWentWellRequest request = SaveWhatWentWellRequest(
          TeacherId: teacherId,
          UserId: uid,
          ProgramID: programId,
          InputType: 'HEALTH',
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
