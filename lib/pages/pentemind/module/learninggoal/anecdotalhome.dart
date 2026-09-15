import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/app_assets.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/pentemind/module/learninggoal/what_went_well.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helper/LocalConstant.dart';
import '../../../../iface/onClick.dart';
import '../../../home/pentemindhome.dart';
import 'child_personal_information.dart';
import 'childs_advancement.dart';
import 'facilator_says.dart';
import 'general_health_hygiene.dart';

class AnecdotalHomeScreen extends StatefulWidget {
  onClickListener listener;

  AnecdotalHomeScreen({super.key, required this.listener});

  @override
  AnecdotalHomeScreenState createState() => AnecdotalHomeScreenState();
}

class AnecdotalHomeScreenState extends State<AnecdotalHomeScreen> {
  bool isLoading = false;

  List<PentemindItem> anecdotalMenus = [];
  @override
  void initState() {
    super.initState();
    anecdotalMenus.clear();
    anecdotalMenus.add(PentemindItem(LocalConstant.MENU_LG_CHILD_INFORMATION,
        'Child\'s Personal Information', 'ChildsPersonalInformation', ''));
    anecdotalMenus.add(PentemindItem(LocalConstant.MENU_LG_HELTHHYGINE,
        'Child\'s General Health and Hygiene Chart', 'Healthandhygiene', ''));
    anecdotalMenus.add(PentemindItem(LocalConstant.MENU_LG_FACILATOR_SAYS,
        'Facilitator  Says', 'FacilitatorSays', ''));
    anecdotalMenus.add(PentemindItem(LocalConstant.MENU_LG_CHILD_ADVANCEMENT,
        'Child\'s Advancement', 'ChildsAdvancement', ''));
    anecdotalMenus.add(PentemindItem(
        LocalConstant.MENU_LG_WWW, 'What Went Well', 'WhatWentWell', ''));
    anecdotalMenus.add(PentemindItem(LocalConstant.MENU_LG_EVEN_BETTER_IF,
        'Even Better If ', 'EvenBetterIf', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.APP_BACKGROUND),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          itemCount: anecdotalMenus.length,
          itemBuilder: (context, index) =>
              getPentemindMenu(anecdotalMenus[index]),
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
                if (item.index == LocalConstant.MENU_LG_CHILD_ADVANCEMENT) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChildsAdvancementScreen()));
                } else if (item.index == LocalConstant.MENU_LG_WWW) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WhatWentWellScreen(
                            type: 'WWW',
                          )));
                } else if (item.index == LocalConstant.MENU_LG_EVEN_BETTER_IF) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WhatWentWellScreen(
                            type: 'EVNBTR',
                          )));
                } else if (item.index == LocalConstant.MENU_LG_CHILD_INFORMATION) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildPersonalinformationScreen()));
                } else if (item.index == LocalConstant.MENU_LG_FACILATOR_SAYS) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacilatorSaysScreen()));
                } else if (item.index == LocalConstant.MENU_LG_HELTHHYGINE) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GeneralHealthAndHygieneScreen()));
                } else {
                  widget.listener.onClick(item.index, item);
                }
              },
              child: Container(
              child: ListTile(
                title: kIsWeb ? MouseRegion(cursor: SystemMouseCursors.click, child: Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                )) : Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
