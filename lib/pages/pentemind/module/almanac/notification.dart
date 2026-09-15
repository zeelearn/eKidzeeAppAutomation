import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/myclass/leave_records.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/myclass/leave_records.dart';
import '../../../../constants.dart';

class AlmanacNotification extends StatefulWidget {
  const AlmanacNotification({super.key});

  @override
  _AlmanacNotificationState createState() => _AlmanacNotificationState();
}

class _AlmanacNotificationState extends State<AlmanacNotification>
    with WidgetsBindingObserver {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  int studentId = 0;
  String token = '';
  int programId = 0;
  List<LeaveNotificationModel> mNotificationList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
//     debugPrint('LeaveRecords Screen didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getLeaveRecords();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;

    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getLeaveRecords();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mNotificationList.clear();
      isLoading = false;
      LeaveRecordResponse response = LeaveRecordResponse.fromJson(
        json.decode(data!),
      );
      mNotificationList.addAll(response.data[0].Notification);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}__${LocalConstant.MENU_MYCLASS_LEAVE_RECORD}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getLeaveRecords() {
//     debugPrint('get Leave note ');
    mNotificationList.clear();
//     debugPrint('clear');
    isLoading = true;
    setState(() {});
    LeaveRecordRequest request = LeaveRecordRequest(
        UserId: uid,
        ProgramId: programId.toString(),
        TeacherId: teacherId,
        StudentID: studentId.toString());
    APIService apiService = APIService();
    apiService.getLeaveRecords(request, token).then((value) {
      if (value != null) {
        isLoading = false;
        mNotificationList.clear();
        LeaveRecordResponse response = value;
        if (response.data.isNotEmpty &&
            response.data[0].Notification.isNotEmpty) {
          mNotificationList.addAll(response.data[0].Notification);
          setState(() {});
        } else {
          setState(() {});
        }
      }
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('MyClass:LeaveRecord');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: userType == 'P'
            ? null
            : AppBar(
                centerTitle: false,
                title: Text(
                  'Leave Records',
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getLeaveRecords();
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
    } else if (mNotificationList.isEmpty) {
//       debugPrint('data ${mNotificationList.length}');
      return Utility.emptyData(context,
          "Notification are not available at this moment please check later");
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: mNotificationList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getLeaveRecordWidget(mNotificationList[index]);
              },
            ))
          ],
        ),
      );
    }
  }

  getLeaveRecordWidget(LeaveNotificationModel model) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
        padding: EdgeInsets.all(2),
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              /*minLeadingWidth: 10,
                leading: SizedBox(
                    width: 20,
                    child: Image.asset(
                      'assets/icons/ic_leave.png',
                      width: 15,
                    )),*/
              title: Padding(
                padding: EdgeInsetsDirectional.all(0),
                child: Text(
                  model.Subject,
                  style: LightColors.textHeaderStyle16,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsetsDirectional.only(start: 0),
                child: Html(
                  data: model.Body,
                  style: {
                    "body": Style(
                      fontSize: FontSize(12.0),
                    ),
                  },
                ),
              ),
            ),
            userType == 'P'
                ? Padding(
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
                              MyWidget()
                                  .richText('', LightColors.textvSmallStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: MyWidget().richText(
                              model.Date, LightColors.textvSmallStyle),
                        ),
                      ],
                    ),
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
