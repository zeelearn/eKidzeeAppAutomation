import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/pentemind/module/dailyactivity/update_dailyactivity.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/dailyactivity/activityresponse.dart';
import '../../../../api/response/pentemind/get_day_response.dart';
import '../../../../constants.dart';
import '../../../../helper/KidzeePref.dart';

class WorksheetScreen extends StatefulWidget {
  bool? deepLinkingEnabled;
  String? programID;
  String? day;
  WorksheetScreen(
      {super.key, this.deepLinkingEnabled, this.programID, this.day});

  @override
  _WorksheetScreenState createState() => _WorksheetScreenState();
}

class _WorksheetScreenState extends State<WorksheetScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  String cName = '';
  int programId = 0;
  List<DailyActivityModel> mActivity = [];
  final TextEditingController _dayController = TextEditingController();

  String _chosenValue = 'Daily Activity';
  List<String> options = ['Daily Activity', 'Additional Activity'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    if (widget.deepLinkingEnabled == null) {
      GetDayResponse? dayModel = await KidzeePref.getDay(context);
      _dayController.text = dayModel.data.D.toString();
      cName = dayModel.data.CName;
      if (dayModel.data.D == 0) {
        _dayController.text = '1';
      } else
        _dayController.text = dayModel.data.D.toString();
      setState(() {});
    } else {
      _dayController.text = widget.day ?? '1';
    }
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('WorksheetScreen Screen didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getActivities();
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
      getActivities();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mActivity.clear();
      isLoading = false;
      DailyActivityResponse response = DailyActivityResponse.fromJson(
        json.decode(data!),
      );
      mActivity.addAll(response.activityModel);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${_dayController.toString()}_${LocalConstant.MENU_DAILY_ACTIVITY}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getActivities() {
    mActivity.clear();
    isLoading = true;
    setState(() {});
    BasePentemindRequest request = BasePentemindRequest(
        Program_ID: widget.deepLinkingEnabled == null
            ? programId
            : int.parse(widget.programID ?? '0'),
        userId: uid);
    APIService apiService = APIService();
    apiService
        .getDailyActivity(request, _dayController.text.toString(), token)
        .then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is DailyActivityResponse) {
          DailyActivityResponse response = value;
          String json = jsonEncode(response);
          savechildSummery(json);
          mActivity.addAll(response.activityModel);
          if (mActivity.isNotEmpty) {
            cName = mActivity[0].CName;
          }
          setState(() {});
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils()
        .sendAnalyticsEvent('DailyActivity:WorksheetScreen');
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getActivities();
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
    } else if (mActivity.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getHeader(),
          Utility.emptyData(context,
              "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            Flexible(
                child: ListView.builder(
              itemCount: mActivity.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getActivityWidget(mActivity[index]);
              },
            ))
          ],
        ),
      );
    }
  }

  getHeader() {
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 5, // 30%
            child: Text(''),
          ),
          Expanded(
              flex: 10, // 30%
              child: MyWidget().richText('Day', LightColors.textSmallStyle)),
          Expanded(
              flex: 15, // 30%
              child: GestureDetector(
                onTap: () {
                  getInputBottomSheet();
                },
                child: SizedBox(
                  height: 40.0,
                  child: TextFormField(
                    style: LightColors.textHeaderStyle13,
                    decoration: MyWidget().getInputDecoration(''),
                    initialValue: _dayController.text.toString(),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    maxLength: 3,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (val) {
                      setState(() {
                        _dayController.text = val.toString();
                        getActivities();
                      });
                    },
                  ),
                ),
              )),
          Expanded(
            flex: 20, // 30%
            child: MyWidget().richText(cName, LightColors.textSmallStyle),
          ),
          Expanded(
              flex: 50, // 30%
              child: MyWidget().getDropdownButton('Select Activity',
                  _chosenValue, options, Utility.ACTION_OBSERVATION, this)),
        ],
      ),
    );
  }

  getActivityWidget(DailyActivityModel model) {
    return GestureDetector(
      onTap: () {
        if (model.LogBookStatusCode == 'C') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DAStudentRemarkScreen(
                      model: model,
                      day: int.parse(_dayController.text.toString()),
                      DWSType:
                          _chosenValue == 'Daily Activity' ? 'DAILY' : 'ADDNL',
                    )),
          ).then((value) {
            //do something after resuming screen
            getActivities();
          });
        } else {
          Utility.showMessage(context, 'Activity not completed yet');
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: model.LogBookStatusCode == 'C'
                ? Colors.white
                : LightColors.kLightGrayM,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x430F1113),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MyWidget().richText(
                              'Session : ', LightColors.textvSmallStyle),
                          MyWidget().richText(
                              model.SessionName, LightColors.textvSmallStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Date : ${Utility.parseShortDate(model.LogDate)}',
                        style: LightColors.textvSmallStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    model.Worksheet,
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Color(0xFF4B39EF),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
                trailing: Wrap(
                  spacing: 5, // space between two icons
                  children: <Widget>[
                    Chip(
                      backgroundColor: LightColors.kLightGrayM,
                      avatar: CircleAvatar(
                        backgroundColor: LightColors.kLightGreenMaterial,
                        child: Text(
                          'C',
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                      label: Text(model.C.toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: LightColors.kDarkBlue,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          )),
                    ),
                    Chip(
                      backgroundColor: LightColors.kLightGrayM,
                      avatar: CircleAvatar(
                        backgroundColor: LightColors.kLightRedMaterial,
                        child: Text(
                          'NC',
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                      label: Text(model.NC.toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: LightColors.kDarkBlue,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      setState(() {
        _chosenValue = value;
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _dayController,
                              maxLines: 2,
                              minLines: 2,
                              decoration: InputDecoration(
                                  hintText: "Insert Culmination Day",
                                  counterText: "",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Culmination Day can\'t be empty';
                                } else {
                                  _dayController.text = value;
                                  getActivities();
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
}
