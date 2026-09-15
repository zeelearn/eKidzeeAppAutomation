import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:flutter/material.dart';

import '../../../widget/video_widget.dart';
import '../kltvideodata.dart';
import '../models/KLTVideoModel.dart';
import '../models/klthome.dart';

class SeniorKGVideo extends StatefulWidget {
  String className;
  String videoName;
  SeniorKGVideo({super.key, required this.className, required this.videoName});

  @override
  _KltHomePageState createState() => _KltHomePageState();
}

class _KltHomePageState extends State<SeniorKGVideo> {
  late List<KltVideoModel> specialities;
  final _className = 'SeniorKG';
  String progressPercentage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    specialities = getVideoList();
    getRhymesInfo();
  }

  Future<void> getRhymesInfo() async {
    await FCM.init();
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(LocalConstant.FB_ACTIVITY_RHYMES);
    // to get data from all documents sequentially
    specialities.clear();
    collectionRef.snapshots().listen((result) {
      for (var res in result.docChanges) {
        if (res.type == DocumentChangeType.added) {
          setState(() {
            if (res.doc.data().toString().contains('myvideo')) {
              String firebaseData = res.doc['myvideo'];
              ////debugPrint("MY DATA ------" + firebaseData);
              Map<String, dynamic> user = jsonDecode(firebaseData);
              ////debugPrint('Message ---- , ${user['Message']}!');

              KLTVideoDataModel videoData =
                  KLTVideoDataModel.fromJson(jsonDecode(firebaseData));

              for (int index = 0; index < videoData.videoList.length; index++) {
                if (_className == 'SeniorKG' &&
                    videoData.videoList[index].classId == 4) {
                  if (widget.videoName.isNotEmpty) {
                    ////debugPrint('vide is not empty');
                    for (int jIndex = 0;
                        jIndex < videoData.videoList.length;
                        jIndex++) {
                      if (videoData.videoList[index].videoName
                          .replaceAll(" ", "")
                          .contains(widget.videoName.replaceAll(" ", ""))) {
                        specialities.add(videoData.videoList[index]);
                        break;
                      }
                    }
                  } else {
                    //debugPrint('vide is empty');
                    specialities.add(videoData.videoList[index]);
                  }
                } else if (_className == 'JuniorKG' &&
                    videoData.videoList[index].classId == 3) {
                  specialities.add(videoData.videoList[index]);
                } else if (_className == 'PlayGroup' &&
                    videoData.videoList[index].classId == 6) {
                  specialities.add(videoData.videoList[index]);
                } else if (_className == 'Nursery' &&
                    videoData.videoList[index].classId == 5) {
                  specialities.add(videoData.videoList[index]);
                }
              }
            }
          });
        } else if (res.type == DocumentChangeType.modified) {
          //debugPrint("modified");
          ////debugPrint(res.doc.data());
        } else if (res.type == DocumentChangeType.removed) {
          //debugPrint("removed");
          ////debugPrint(res.doc.data());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return getVideoWidgetFromListOfVideos(specialities, widget.videoName, 4);
  }
}
