import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/app_assets.dart';
import 'package:ekidzee/widget/MyWebSiteView.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/base_request.dart';
import '../../../../api/response/pentemind/pentemindprogress/student_report.dart';
import '../../../../helper/LocalConstant.dart';
import '../../../../helper/LocalStrings.dart';
import '../../../../helper/utils.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key});

  @override
  MyProgressScreenState createState() => MyProgressScreenState();
}

class MyProgressScreenState extends State<MyProgressScreen> {
  bool isLoading = false;

  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String entityId = '';
  int studentId = 0;
  int classId = 0;
  String className = '';
  String cName = '';
  int programId = 0;
  List<ReportModel> mReportList = [];

  List<PentemindItem> mMenus = [];
  @override
  void initState() {
    super.initState();
    getUserInfo();
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

    entityId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    //mMenus.add(PentemindItem(1,LocalConstant.MODULE_STUDENT_PROFILE,LocalConstant.MODULE_STUDENT_PROFILE,'assets/icons/ic_announancement.png'));
    mMenus.add(PentemindItem(
        2,
        LocalConstant.MODULE_STUDENT_REPORT,
        LocalConstant.MODULE_STUDENT_REPORT,
        'assets/icons/ic_announancement.png'));
    getReports();
  }

  getReports() {
    mReportList.clear();
    isLoading = true;
    setState(() {});
    BasePentemindRequest request = BasePentemindRequest(
        Program_ID: programId, userId: studentId.toString());
    APIService apiService = APIService();
    apiService.getStudentReports(request, token).then((value) {
      debugPrint(value);
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is StudentReportResponse) {
          StudentReportResponse response = value;
//           debugPrint('in if condition....');
          mReportList.addAll(response.data);
          debugPrint(response.data.toString());
          updateMenu();
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      isLoading = false;
      setState(() {});
    });
  }

  updateMenu() {
    mMenus.clear();
    for (int index = 0; index < mReportList.length; index++) {
      for (int jIndex = 0;
          jIndex < mReportList[index].reportaccess.length;
          jIndex++) {
        debugPrint(mReportList[index].reportaccess[jIndex].ReportID);
        /*if (mReportList[index].reportaccess[jIndex].ReportID.trim()=='1'){
          mMenus.add(PentemindItem(1,LocalConstant.MODULE_STUDENT_PROFILE,LocalConstant.MODULE_STUDENT_PROFILE,'assets/icons/ic_announancement.png'));
        }else if (mReportList[index].reportaccess[jIndex].ReportID.trim()=='2'){
          mMenus.add(PentemindItem(2,LocalConstant.MODULE_STUDENT_REPORT,LocalConstant.MODULE_STUDENT_REPORT,'assets/icons/ic_announancement.png'));
        }*/
        mMenus.add(PentemindItem(
            2,
            LocalConstant.MODULE_STUDENT_REPORT,
            LocalConstant.MODULE_STUDENT_REPORT,
            'assets/icons/ic_announancement.png'));
      }
    }
    debugPrint(mMenus.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.APP_BACKGROUND),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: mMenus.length,
          itemBuilder: (context, index) => getPentemindMenu(mMenus[index]),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 1,
          //   childAspectRatio: MediaQuery.of(context).size.width /
          //       2 /
          //       MediaQuery.of(context).size.height /
          //       2,
          // ),
        ));
  }

  Widget getPentemindMenu(PentemindItem item) {
    final Color color = Colors.primaries[item.index % Colors.primaries.length];

    return GestureDetector(
      onTap: () async {
        int academicYear = await KidzeePref().getAcademicYear();
        if (item.index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyWebsiteView(
                    title: 'Student Profile',
                    url:
                        '${LocalStrings.baseUrl}/studentprofile?sid=$studentId&pid=$programId&UserType=$userType&$academicYear',
                  )));
        } else if (item.index == 2) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyWebsiteView(
                    title: 'Student Report',
                    url:
                        '${LocalStrings.baseUrl}/studentreportList/$studentId&$programId&$userType&$classId&$entityId&$uid&mobile&$academicYear',
                  )));
        }
      },
      child: isLoading == true
          ? Center(
              child: Lottie.asset('assets/json/kidzee_loader.json'),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                child: Card(
                  color: Colors.indigo,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Container(
                    color: kPrimaryLightColor,
                    // decoration: const BoxDecoration(
                    //   gradient:
                    //   LinearGradient(colors: [Color.fromARGB(255, 0, 126, 182),Color.fromARGB(255, 46, 49, 146)],stops: [0.0, 1.0],
                    //       begin: FractionalOffset.topCenter,
                    //       end: FractionalOffset.bottomCenter,
                    //       tileMode: TileMode.repeated),
                    // ),
                    child: ListTile(
                      title: Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      trailing: Image.asset(
                        item.assetlocation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class PentemindItem {
  final int index;
  final String title;
  final String actionKey;
  final String assetlocation;

  const PentemindItem(
    this.index,
    this.title,
    this.actionKey,
    this.assetlocation,
  );
}
