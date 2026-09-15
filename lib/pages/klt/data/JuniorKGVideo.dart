import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../widget/video_widget.dart';
import '../kltvideodata.dart';
import '../models/KLTVideoModel.dart';
import '../models/klthome.dart';

class JuniorKGVideo extends StatefulWidget {
  String className;
  String videoName;

  JuniorKGVideo({super.key, required this.className, required this.videoName});

  @override
  _KltHomePageState createState() => _KltHomePageState();
}

class _KltHomePageState extends State<JuniorKGVideo> {
  late List<KltVideoModel> specialities;
  final _className = 'Junior KG';

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
          //debugPrint("added");

          setState(() {
            if (res.doc.data().toString().contains('myvideo')) {
              String firebaseData = res.doc['myvideo'];
              //debugPrint('Data Found----');
              ////debugPrint("MY DATA ------" + firebaseData);
              Map<String, dynamic> user = jsonDecode(firebaseData);
              //debugPrint('Message ---- , ${user['Message']}!');

              KLTVideoDataModel videoData =
                  KLTVideoDataModel.fromJson(jsonDecode(firebaseData));
              //debugPrint('video data '+_className);
              for (int index = 0; index < videoData.videoList.length; index++) {
                if (_className == 'SeniorKG' &&
                    videoData.videoList[index].classId == 4) {
                  specialities.add(videoData.videoList[index]);
                } else if (_className == 'Junior KG' &&
                    videoData.videoList[index].classId == 3) {
                  //specialities.add(videoData.videoList[index]);
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
    return getVideoWidgetFromListOfVideos(specialities, widget.videoName, 3);
  }
}

Future<void> downloadFile(
    BuildContext context, KltVideoModel specialiti) async {
  // final storageRef = FirebaseStorage.instance.refFromURL(
  //     "gs://kidzeeandroidapp-91faf.appspot.com/klt_content/Videos/3/BLENDING SOUNDS.mp4");
  //debugPrint(specialiti.videoName);
  //debugPrint(specialiti.videoUrl);
  var storageReference =
      'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Videos/Junior KG/${specialiti.videoName}.mp4';
  final storageRef = FirebaseStorage.instance.refFromURL(storageReference);

  final appDocDir = await getApplicationDocumentsDirectory();
  //final filePath = "${appDocDir.absolute}/${specialiti.videoName}.mp4";

  final path = Directory('${appDocDir.path}/${specialiti.classId}');
  if ((await path.exists())) {
    // TODO:
    //debugPrint("exist");
  } else {
    // TODO:
    //debugPrint("not exist");
    path.create();
  }
  final File filePath = File(
      '${appDocDir.path}/${specialiti.classId}/${specialiti.videoName}.mp4');

  //final file = File(filePath);
  //debugPrint(filePath.path);
  final downloadTask = storageRef.writeToFile(filePath);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        //debugPrint("Running");
        break;
      case TaskState.paused:
        //debugPrint("paused");
        break;
      case TaskState.success:
        //debugPrint("success------===============");
        //EncrypData.decryptKltFile(filePath.path, specialiti.DecryptionKey);
        //decrypt_file(filePath.path, specialiti.DecryptionKey);
        break;
      case TaskState.canceled:
        //debugPrint("canceled");
        break;
      case TaskState.error:
        //debugPrint("error");
        break;
    }
  });
}

void onItemClick(BuildContext context, KltVideoModel specialiti) {
  downloadFile(context, specialiti);
}
