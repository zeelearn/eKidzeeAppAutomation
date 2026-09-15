import 'package:ekidzee/pages/klt/models/rhymesmodel.dart';
import 'package:ekidzee/pages/klt/rhymes/rhymes_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/klt/klddashboard.dart';
import '../pages/klt/models/klthome.dart';

Widget getVideoWidgetFromListOfVideos(
    List<KltVideoModel> specialities, String videoName, int classId) {
  KltVideoModel? kltVideo = specialities.firstWhereOrNull((element) {
    String eName = element.videoName.replaceAll(" ", "");
    String vName = videoName.replaceAll(" ", "");
    return eName == vName && element.classId == classId;
  });
  debugPrint(
      'Selected Video Name: ${kltVideo?.videoName} - ${kltVideo?.videoId} - ${kltVideo?.classId}');
  return Scaffold(
    body: SafeArea(
      child: specialities.isEmpty
          ? Center(
              child: SizedBox(
                  height: 40, width: 40, child: CircularProgressIndicator()))
          : kltVideo == null
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No Video Found'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(Get.context!);
                        },
                        child: Text('Go to Dashboard'),
                      )
                    ],
                  ),
                )
              : VideoAdaptar(
                  videoModel: kltVideo,
                  currentVideoName: videoName,
                ),
    ),
  );
}

Widget getRhymesVideoWidgetFromListOfVideos(
    List<KltRhymesModel> rhymesList, String videoName, int classId) {
  KltRhymesModel? rhymeVideo = rhymesList.firstWhereOrNull(
    (element) {
      String eName = element.videoName.replaceAll(" ", "");
      String vName = videoName.replaceAll(" ", "");
      return eName == vName && element.classId == classId;
    },
  );
  return Scaffold(
    body: SafeArea(
      child: rhymesList.isEmpty
          ? Center(
              child: SizedBox(
                  height: 40, width: 40, child: CircularProgressIndicator()))
          : rhymeVideo == null
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No Rhyme Found'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(Get.context!);
                        },
                        child: Text('Go to Dashboard'),
                      )
                    ],
                  ),
                )
              : RhymesAdaptar(
                  currentVideoName: videoName,
                  videoModel: rhymeVideo,
                ),
    ),
  );
}

String getClassName(String classid) {
  String className = "Nursery";
  if (classid == '5') {
    className = "Nursery";
  } else if (classid == '6') {
    className = "PlayGroup";
  } else if (classid == '3') {
    className = "JUNIORKG";
  } else if (classid == '4') {
    className = "SENIORKG";
  }
  return className;
}
