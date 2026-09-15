import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/pentemindprogress/tracker_response.dart';
import '../../../../constants.dart';

class ParentTrackerScreen extends StatefulWidget {
  const ParentTrackerScreen({super.key});

  @override
  _ParentTrackerScreenState createState() => _ParentTrackerScreenState();
}

class _ParentTrackerScreenState extends State<ParentTrackerScreen>
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
  int studentId = 0;
  String className = '';
  String cName = '';
  int programId = 0;
  List<ParentTrackerInfo> mTrackerList = [];

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
//     debugPrint('_Academic Screen didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getTrackerList();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    //_dayController.text = '1';
    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getTrackerList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mTrackerList.clear();
      isLoading = false;
      ParentTrackerResponse response = ParentTrackerResponse.fromJson(
        json.decode(data!),
      );
      mTrackerList.addAll(response.trackerList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_PARENT_PENTEMIND_PROCESS_TRACKER}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getTrackerList() {
    mTrackerList.clear();
    isLoading = true;
    setState(() {});
    BasePentemindRequest request =
        BasePentemindRequest(Program_ID: programId, userId: uid);
    APIService apiService = APIService();
    apiService
        .getParentTracker(request, studentId.toString(), token)
        .then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is ParentTrackerResponse) {
          ParentTrackerResponse response = value;
          String json = jsonEncode(response);
          savechildSummery(json);
          mTrackerList.addAll(response.trackerList);
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
    FirebaseAnalyticsUtils().sendAnalyticsEvent('FacilatorTool:Logbook');
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
              getTrackerList();
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
    } else if (mTrackerList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 1),
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: mTrackerList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return getTrackerWidget(mTrackerList[index]);
                },
              )),
            ],
          ));
    }
  }

  getTrackerWidget(ParentTrackerInfo model) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push( context, MaterialPageRoute( builder: (context) => LogbookDetailsScreen(logbookModel: logbookModel,day: _dayController.text.toString()), ), ).then((value)
        {
          getLogbook();
        });*/
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
                        children: [],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Date : ${Utility.parseDate(model.AttendanceDate)}',
                        style: LightColors.textSmallStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Padding(
                    padding: EdgeInsets.all(0),
                    child: Html(style: {
                      "body": Style(
                        fontSize: FontSize(14.0),
                      ),
                    }, data: model.Activity)),
                subtitle: Padding(
                  padding: EdgeInsetsDirectional.only(start: 8),
                  child: Text(
                    model.CName,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color(0xFF4B39EF),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
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
}

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}
