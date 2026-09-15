import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/dailyactivity/homework_request.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/dailyactivity/homework_response.dart';
import '../../../../app_routes.dart';
import '../../../../constants.dart';
import 'homework_studentlist.dart';

class HomeworkScreen extends StatefulWidget {
  bool isToolbar;
  String? programID;
  String? day;
  bool? deepLinkingEnabled;
  HomeworkScreen(
      {super.key,
      required this.isToolbar,
      this.deepLinkingEnabled,
      this.programID,
      this.day});

  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen>
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
  List<HomeWorkModel> mHomeworkList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    await FCM.init();
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('HomwWork Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getHomeWork();
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
      getHomeWork();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mHomeworkList.clear();
      isLoading = false;
      GetHomeworkResponse response = GetHomeworkResponse.fromJson(
        json.decode(data!),
      );
      mHomeworkList.addAll(response.homeWorkList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}__${LocalConstant.MENU_DAILY_HOMEWORK}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getHomeWork() {
    mHomeworkList.clear();
    isLoading = true;
    setState(() {});
    GetHomeworkRequest request = GetHomeworkRequest(
        ProgramID: widget.deepLinkingEnabled == null
            ? programId.toString()
            : (widget.programID ?? '0'),
        UserID: uid,
        TransType: 'HW');
    APIService apiService = APIService();
    apiService.getHomeWork(request, token).then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GetHomeworkResponse) {
          GetHomeworkResponse response = value;
          String json = jsonEncode(response);
          savechildSummery(json);
          mHomeworkList.addAll(response.homeWorkList);
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
    FirebaseAnalyticsUtils().sendAnalyticsEvent('DailyActivity:HomeWork');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.isToolbar
            ? AppBar(
                title: const Text('Homework'),
              )
            : null,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getHomeWork();
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
    } else if (mHomeworkList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: mHomeworkList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getHomeworkWidget(mHomeworkList[index]);
              },
            ))
          ],
        ),
      );
    }
  }

  getHomeworkWidget(HomeWorkModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeworkStudentListScreen(
                    model: model,
                  )),
        ).then((value) {
          //do something after resuming screen
          getHomeWork();
        });
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
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
                padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MyWidget().richText(
                              'Culmination : ', LightColors.textvSmallStyle),
                          MyWidget().richText(
                              model.CName, LightColors.textvSmallStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Date : ${Utility.parseDate(model.AssignedDate)}',
                        style: LightColors.textvSmallStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                minLeadingWidth: 10,
                leading: SizedBox(
                  width: 30,
                  child: model.solution.isEmpty
                      ? null
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => goToMyPdf(
                                  worksheetUrl: model.solution,
                                  title: model.Worksheet,
                                  filename: '${model.Worksheet}.pdf',
                                  module: 'homework',
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icons/ic_worksheet.png',
                            width: 15,
                          )),
                ),
                title: Padding(
                  padding: const EdgeInsetsDirectional.all(0),
                  child: Text(
                    model.Worksheet,
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: const Color(0xFF4B39EF),
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
      shape: const RoundedRectangleBorder(
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
        padding: const EdgeInsetsDirectional.only(
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
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsetsDirectional.only(bottom: 10),
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
}
