import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/k12/presentation/pages/folders/folder_page.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class FacilatorToolPage extends StatelessWidget {
  final String classid;
  final int projectId;
  final String userName;

  FacilatorToolPage(
      {required this.classid, required this.projectId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              pinned: true,
              backgroundColor: LightColors.kLightGrayM,
              foregroundColor: kPrimaryLightColor,
              floating: true,
              title: TabBar(
                indicatorColor: kPrimaryLightColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black26,
                isScrollable: true,
                tabs: [
                  //Tab(child: Text(LocalConstant.MODULE_K12_LOGBOOK)),
                  Tab(child: Text('ZLL Documents')),
                  Tab(child: Text('Lesson Plan'))
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            // LogbookPage(
            //   userName: userName,
            //   classId: classid,
            // ),
            FolderPage(
              parentFolderName: 'ZLL Documents',
              classId: classid,
              projectid: projectId,
              subject: 0,
              userName: userName,
            ),
            FolderPage(
              parentFolderName: 'Lesson Plan',
              classId: classid,
              projectid: projectId,
              subject: 0,
              userName: userName,
            )
          ],
        ),
      )),
    );
  }
}



