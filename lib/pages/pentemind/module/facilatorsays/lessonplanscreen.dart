import 'dart:async';
import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/facilatortool/lessonplanrequest.dart';
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
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/facilatortool/lessonplan.dart';
import '../../../../api/response/pentemind/get_day_response.dart';
import '../../../../app_routes.dart';
import '../../../../constants.dart';
import '../../../../helper/KidzeePref.dart';

class LessonPlanScreen extends StatefulWidget {
  const LessonPlanScreen({super.key});

  @override
  _LessonPlanScreenState createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String token = '';
  String cName = '';
  String termType = '';
  int classId = 0;
  int day = -1;
  List<LessonPlanModel> mLessonPlanList = [];
  final TextEditingController _dayController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    Timer(Duration(seconds: 1), () => loadData());
  }

  loadData() async {
    GetDayResponse? dayModel = await KidzeePref.getDay(context);
//     debugPrint('in if daymodel ${dayModel.data.D}');
    if (dayModel.data.D > 0) {
      _dayController.text = dayModel.data.D.toString();
//       debugPrint('in if 64 ${_dayController.text}');
    } else {
      _dayController.text = '1';
//       debugPrint('in if 67 ${_dayController.text}');
    }
    cName = dayModel.data.CName;

    setState(() {
      day = int.parse(_dayController.text);
    });
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('_Academic Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getLessonPlanData();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    termType = prefs.getString(LocalConstant.KEY_CURRENT_TERM) as String;
    getLessonPlanData();
  }

  getLessonPlanData() {
    var summary = prefs.getString(getId());
    if (summary == null) {
      getLessonPlan();
    } else {
      getLocalData(summary);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mLessonPlanList.clear();
      isLoading = false;
      LessonPlanResponse response = LessonPlanResponse.fromJson(
        json.decode(data!),
      );
      mLessonPlanList.addAll(response.lessonPlanModelList);
      if (mLessonPlanList.isNotEmpty) {
        cName = mLessonPlanList[0].CName;
      }
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}${classId.toString()}_${LocalConstant.MENU_LESSONPLAN}_${_dayController.text.toString()}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getLessonPlan() async {
    mLessonPlanList.clear();
    if (!await Utility.isInternet()) {
      setState(() {
        isLoading = false;
      });
    } else {
      isLoading = true;
      setState(() {});
      LessonPlanRequest request = LessonPlanRequest(
          ClassId: classId.toString(),
          D: _dayController.text.toString(),
          UserID: uid,
          termType: termType);
      APIService apiService = APIService();
      apiService.getLessonPlan(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is LessonPlanResponse) {
            LessonPlanResponse response = value;
            String json = jsonEncode(response);
            savechildSummery(json);
            mLessonPlanList.addAll(response.lessonPlanModelList);
            try {
              cName = mLessonPlanList[0].CName;
            } catch (e) {}
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
    FirebaseAnalyticsUtils().sendAnalyticsEvent('FacilatorTool:LessonPlan');
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
              getLessonPlan();
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
    } else if (mLessonPlanList.isEmpty) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            Utility.emptyData(context,
                "Data are not available at this moment please check later")
          ],
        ),
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
              itemCount: mLessonPlanList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getLessonPlanWidget(mLessonPlanList[index]);
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
              flex: 20, // 30%
              child: MyWidget()
                  .richText('Select Day', LightColors.textSmallStyle)),
          Expanded(
              flex: 30, // 30%
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
//                         debugPrint('day ase ${_dayController.text.toString()}');
                        getLessonPlanData();
                      });
                    },
                  ),
                ),
              )),
          Expanded(
            flex: 5, // 70%
            child: Text(''),
          ),
          Expanded(
            flex: 20, // 30%
            child: MyWidget().richText(cName, LightColors.textSmallStyle),
          ),
        ],
      ),
    );
  }

  getLessonPlanWidget(LessonPlanModel model) {
    return GestureDetector(
      onTap: () {
        if (model.MediaType == 'pdf') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => goToMyPdf(
                worksheetUrl: model.WebUrl,
                title: model.ContentDescription,
                filename: model.ContentDescription,
                module: 'lessonplan',
                isDownload: false,
              ),
            ),
          );
        } else if (model.MediaType == 'mp4') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => goToVideoPlayer(
                      path: model.WebUrl,
                      Title: model.ContentDescription,
                    )),
          );
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x430F1113),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Padding(
              padding: EdgeInsetsDirectional.all(0),
              child: Text(
                model.ContentDescription,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  color: Color(0xFF4B39EF),
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  model.RefValue,
                  style: LightColors.textvSmallStyle,
                )),
            trailing: OutlinedButton(
              onPressed: () {
                if (model.MediaType == 'pdf') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => goToMyPdf(
                        worksheetUrl: model.WebUrl,
                        title: model.ContentDescription,
                        filename: model.ContentDescription,
                        module: 'lessonplan',
                        isDownload: false,
                      ),
                    ),
                  );
                } else if (model.MediaType == 'mp4') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => goToVideoPlayer(
                              path: model.WebUrl,
                              Title: model.ContentDescription,
                            )),
                  );
                }
              },
              child: Text(
                model.MediaType.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF4B39EF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
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

  showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
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
                              keyboardType: TextInputType.number,
                              controller: _dayController,
                              maxLines: 2,
                              minLines: 2,
                              decoration: InputDecoration(
                                  hintText: "Insert Culmination Day",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Culmination Day can\'t be empty';
                                } else {
                                  _dayController.text = value;
                                  getLessonPlanData();
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

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}
