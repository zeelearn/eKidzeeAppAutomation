import 'package:ekidzee/app_routes.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/APIService.dart';
import '../../api/request/pentemind/learningmaterial/learning_material.dart';
import '../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../globals.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/utils.dart';
import '../../iface/onClick.dart';

class PentemindHomeScreen extends StatefulWidget {
  onClickListener listener;
  String currentBatch;
  String className;
  String userType;

  PentemindHomeScreen(
      {super.key,
      required this.currentBatch,
      required this.userType,
      required this.className,
      required this.listener});

  @override
  PentemindHomeScreenState createState() => PentemindHomeScreenState();
}

class PentemindHomeScreenState extends State<PentemindHomeScreen> {
  bool isLoading = false;

  List<PentemindItem> pentemindMenus = [];
  @override
  void initState() {
    super.initState();
    generateFilteredMenu();
    if (widget.className.contains('MDTR')) {
      getMaterials();
    }
  }

  generateFilteredMenu() {
    String userType = widget.userType;
    pentemindMenus.clear();
    if (userType == 'P') {
      if (widget.className.contains('MDTR')) {
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_PENTEMIND_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_ACTIVITY,
            'assets/icons/ParentsCorner.png'));

        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_PENTEMIND_FUN_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
            'assets/icons/ParentsCorner.png'));
      } else {
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_ALMANAC,
            LocalConstant.MODULE_PARENT_ALMANAC,
            LocalConstant.MODULE_PARENT_ALMANAC,
            'assets/icons/ic_announancement.png'));
        pentemindMenus.add(PentemindItem(
            7,
            'Learning Materials',
            LocalConstant.MODULE_LEARNING_MATERIAL,
            'assets/icons/ic_learningmaterials.png'));
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_PENTEMIND_PROCESS,
            LocalConstant.MODULE_PARENT_PARENT_PENTEMIND_PROCESS,
            LocalConstant.MODULE_PARENT_PARENT_PENTEMIND_PROCESS,
            'assets/icons/ic_pentemindprogress.png'));
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_DAILY_HOMEWORK,
            LocalConstant.MODULE_PARENT_PARENT_HOMEWORK,
            LocalConstant.MODULE_PARENT_PARENT_HOMEWORK,
            'assets/icons/ic_homework.png'));
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_ELG,
            LocalConstant.MODULE_PARENT_PARENT_ELG,
            LocalConstant.MODULE_PARENT_PARENT_ELG,
            'assets/icons/ic_elg.png'));
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_ARTSY,
            LocalConstant.MODULE_PARENT_PARENT_ARTSY,
            LocalConstant.MODULE_PARENT_PARENT_ARTSY,
            'assets/icons/ic_artsy.png'));
      }
    } else if (userType == 'AM' ||
        userType == 'ZM' ||
        userType == 'ZAH' ||
        userType == 'PMACAD' ||
        userType == 'RM' ||
        userType == 'TM') {
      pentemindMenus.add(PentemindItem(
          3,
          'Facilitator Tools',
          LocalConstant.MODULE_FACILATORTOOL,
          'assets/icons/ic_facilitatortools.png'));
      pentemindMenus.add(PentemindItem(
          7,
          'Learning Materials',
          LocalConstant.MODULE_LEARNING_MATERIAL,
          'assets/icons/ic_learningmaterials.png'));
    } else {
      if ((userType == 'TEACH' || userType == 'SRTEA') &&
          widget.className.contains('MDTR')) {
        pentemindMenus.add(PentemindItem(
            3,
            'Facilitator Tools',
            LocalConstant.MODULE_FACILATORTOOL,
            'assets/icons/ic_facilitatortools.png'));
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_PENTEMIND_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_ACTIVITY,
            'assets/icons/ParentsCorner.png'));

        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_PARENT_PENTEMIND_FUN_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
            LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
            'assets/icons/ParentsCorner.png'));
      } else {
        pentemindMenus.add(PentemindItem(1, LocalConstant.MODULE_PARENT_TRACKER,
            'Tracker', 'assets/icons/tracker.png'));
        pentemindMenus.add(PentemindItem(
            2, 'My Class', 'attendance', 'assets/icons/ic_attendance.png'));
        pentemindMenus.add(PentemindItem(
            3,
            'Facilitator Tools',
            LocalConstant.MODULE_FACILATORTOOL,
            'assets/icons/ic_facilitatortools.png'));
        pentemindMenus.add(PentemindItem(4, 'Learning Goals', 'learninggoals',
            'assets/icons/ic_learninggoals.png'));
        pentemindMenus.add(PentemindItem(
            5,
            'Daily Activity',
            LocalConstant.MODULE_DAILYACTIVITY,
            'assets/icons/ic_dailyactivity.png'));
        pentemindMenus.add(PentemindItem(6, 'Reports ',
            LocalConstant.MODULE_REPORTS, 'assets/icons/ic_reports.png'));
        pentemindMenus.add(PentemindItem(
            7,
            'Learning Materials',
            LocalConstant.MODULE_LEARNING_MATERIAL,
            'assets/icons/ic_learningmaterials.png'));
        pentemindMenus.add(PentemindItem(
            8,
            'Parents Corner',
            LocalConstant.MODULE_PARENT_CORNER,
            'assets/icons/ic_parentscorner.png'));
      }
    }
//     debugPrint('Pentemind Menu $AppFlavor');
    if (AppFlavor == 'kidzee' && userType == 'P' ||
        userType == 'F' ||
        userType == 'TEACH' ||
        userType == 'CC' ||
        userType == 'CM' ||
        userType == 'SRTEA') {
      pentemindMenus.add(PentemindItem(
          9,
          LocalConstant.MODULE_PARENT_SUPPORT_DESK,
          LocalConstant.MODULE_PARENT_SUPPORT_DESK,
          'assets/icons/ic_chat.png'));
    }
    // pentemindMenus.add(PentemindItem(
    // 38,
    // LocalConstant.MODULE_K12,
    // LocalConstant.MODULE_K12,
    // 'assets/icons/ic_chat.png'));
  }

  List<LearningMaterialModel> mMaterials = [];
  getMaterials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(LocalConstant.KEY_UID) as String;
    String token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    int programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    mMaterials.clear();
    isLoading = true;
    setState(() {});
    if (widget.className.contains('MDTR')) {
//       debugPrint('in apis');
      LearningMaterialRequest request = LearningMaterialRequest(
          ProgramID: programId.toString(),
          D: '-1',
          ContentCategory: 'Intro',
          UserID: uid);
      APIService apiService = APIService();
      apiService.getLearningMaterials(request, false, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is LearningMaterialResponse) {
            LearningMaterialResponse response = value;
            generateFilteredMenu();
            mMaterials.clear();
            mMaterials.addAll(response.data.mateialList);
            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {});
      });
    }
  }

  Widget introGrid() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: mMaterials
                    .map((item) => Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: GestureDetector(
                          onTap: () async {
                            //debugPrint(item.ThumbnailURL);
                            if (item.MediaType == 'mp4') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => goToVideoPlayer(
                                          path: item.WebUrl,
                                          Title: item.ContentDescription,
                                        )),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(item.ThumbnailURL),
                                    fit: BoxFit.cover)),
                          ),
                        )))
                    .toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: isLoading
            ? Utility.showLoader()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      /*decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/app_background.png"),
                fit: BoxFit.cover,
              ),
            ),*/
                      child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: pentemindMenus.length,
                    itemBuilder: (context, index) =>
                        getPentemindMenu(pentemindMenus[index]),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                    ),
                  )),
                  Expanded(child: introGrid())
                ],
              ));
  }

  Widget getPentemindMenu(PentemindItem item) {
    final Color color = Colors.primaries[item.index % Colors.primaries.length];
    return GestureDetector(
      onTap: () {
        if (widget.currentBatch.isNotEmpty ||
            item.title == LocalConstant.MODULE_CHAT_WITHUS) {
          debugPrint(item.actionKey);
          widget.listener.onClick(LocalConstant.ACTION_PENTEMIND_MODULE, item);
        } else {
          widget.listener
              .onClick(LocalConstant.ACTION_PENTEMIND_CLASS_SELECTION, item);
        }
      },
      child: Padding(
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 126, 182),
                      Color.fromARGB(255, 46, 49, 146)
                    ],
                    stops: [
                      0.0,
                      1.0
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    tileMode: TileMode.repeated),
              ),
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
  String? logbookDay;
  String? logbookProgramId;
  dynamic hiveIndex;

  PentemindItem(this.index, this.title, this.actionKey, this.assetlocation,
      {this.logbookDay, this.logbookProgramId, this.hiveIndex});
}
