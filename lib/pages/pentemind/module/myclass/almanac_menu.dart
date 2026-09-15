import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/app_assets.dart';
import 'package:ekidzee/pages/k12/presentation/pages/leaves/leave_record_kes.dart'
    as leaveRecordKes;
import 'package:ekidzee/pages/pentemind/module/myclass/parent_note.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import 'announancement.dart';
import 'approvals/approvals.dart';
import 'leave_record.dart';
import 'notification.dart';

class AlmanacMenu extends StatefulWidget {
  onClickListener listener;

  AlmanacMenu({super.key, required this.listener});

  @override
  AlmanacMenuState createState() => AlmanacMenuState();
}

class AlmanacMenuState extends State<AlmanacMenu> {
  bool isLoading = false;
  String className = '';
  String userType = '';
  String userName = '';
  String carriculumn = '';
  int programId = 0;

  List<PentemindItem> pentemindMenus = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String curriculamType = prefs
            .containsKey(LocalConstant.KEY_CURRENT_CURRICULAMTYPE)
        ? prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String
        : '';
    String term = prefs.getString(LocalConstant.KEY_CURRENT_TERM) as String;
    pentemindMenus.clear();
    if (curriculamType.isNotEmpty && curriculamType.toLowerCase() == 'k12' ||
        curriculamType.toLowerCase() == 'kes') {
      pentemindMenus.add(PentemindItem(
          LocalConstant.MENU_MYCALSS_ANNOUNANCEMENT,
          'Announcement',
          'Announcement',
          ''));
      pentemindMenus.add(PentemindItem(LocalConstant.MENU_MYCLASS_LEAVE_RECORD,
          'Leave Record', 'Leave Record', ''));
    } else {
      pentemindMenus.add(PentemindItem(
          LocalConstant.MENU_MYCALSS_ANNOUNANCEMENT,
          'Announcement',
          'Announcement',
          ''));
      if (term != LocalConstant.TERM_EARLY) {
        pentemindMenus.add(PentemindItem(LocalConstant.MENU_MYCLASS_PARENT_NOTE,
            'Parent Note Resources', 'Parent Note Resources', ''));
      }
      pentemindMenus.add(PentemindItem(LocalConstant.MENU_MYCLASS_LEAVE_RECORD,
          'Leave Record', 'Leave Record', ''));
    }
    setState(() {});
    loadData();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    userName = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
    carriculumn =
        prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String;
    debugPrint(userType);
    if (!Utility.isKES(carriculumn)) {
      if (userType == 'CM' || userType == 'CC') {
        pentemindMenus.add(PentemindItem(
            LocalConstant.MENU_MYCLASS_APPROVALS, 'Approval ', 'Approval', ''));
      }
    }
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
        child: GridView.builder(
          itemCount: pentemindMenus.length,
          itemBuilder: (context, index) =>
              getPentemindMenu(pentemindMenus[index]),
          gridDelegate: Utility.getGridViewStyle(),
        ));
  }

  Widget getPentemindMenu(PentemindItem item) {
    final Color color = Colors.primaries[item.index % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        child: Card(
          color: kPrimaryLightColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //set border radius more than 50% of height and width to make circle
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            highlightColor: Colors.yellow.withOpacity(0.3),
            splashColor: Colors.red.withOpacity(0.8),
            focusColor: Colors.green.withOpacity(0.0),
            hoverColor: Colors.yellow.withOpacity(0.3),
            onTap: () {
              //widget.listener.onClick(item.index, item);
              if (item.index == LocalConstant.MENU_MYCALSS_ANNOUNANCEMENT) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Utility.isKES(carriculumn)
                            ? KESNotificationScreen(
                                sectinId: /* 98825 */ programId,
                                userName: /* 'EMCT1076' */ userName,
                              )
                            : AnnoucementListScreen()));
              } else if (item.index == LocalConstant.MENU_MYCLASS_PARENT_NOTE) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParentNoteScreen(
                              isToolbar: true,
                            )));
              } else if (item.index ==
                  LocalConstant.MENU_MYCLASS_LEAVE_RECORD) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Utility.isKES(carriculumn)
                            ? leaveRecordKes.LeaveRecordScreen()
                            : LeaveRecordScreen(
                                isAppbar: true,
                              )));
              } else if (item.index == LocalConstant.MENU_MYCLASS_APPROVALS) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApprovalsScreen()));
              }
              /*Navigator.push(context,
            MaterialPageRoute(builder: (context) => LearningGoalScreen(url: Uri.encodeFull(LocalConstant.PENTEMIND_URL+"/"+item.actionKey), title: item.title)));*/
            },
            child: Container(
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
                trailing: item.assetlocation.isNotEmpty
                    ? Image.asset(
                        item.assetlocation,
                      )
                    : null,
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
