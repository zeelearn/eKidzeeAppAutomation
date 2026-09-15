import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/widget/video_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app_routes.dart';
import '../../../videoplayer/KltChewieRhymes.dart';
import '../kltvideodata.dart';
import '../models/KLTRhymesModel.dart';
import '../models/rhymesmodel.dart';

class NurseryRhymesScreen extends StatefulWidget {
  String className;
  String videoName;
  NurseryRhymesScreen(
      {super.key, required this.className, required this.videoName});

  @override
  _KltHomePageState createState() => _KltHomePageState();
}

class _KltHomePageState extends State<NurseryRhymesScreen> {
  List<String> categories = ["Nursery", "PlayGroup", "Junior KG", "SeniorKG"];
  List<KltRhymesModel> rhymesList = getRhymes();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //debugPrint('Nursery rhymes selected===================');
    rhymesList = getRhymes();
    getRhymesInfo();
  }

  Future<void> getRhymesInfo() async {
    await FCM.init();
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(LocalConstant.FB_ACTIVITY_RHYMES);
    // to get data from all documents sequentially
    rhymesList.clear();
    collectionRef.snapshots().listen((result) {
      for (var res in result.docChanges) {
        ////debugPrint("added----asdasd-");
        //debugPrint('widget videoName is  ${widget.videoName}');
        if (res.type == DocumentChangeType.added) {
          ////debugPrint("added-----");
          setState(() {
            String firebaseData;
            ////debugPrint(res.doc.data().toString());
            if (res.doc.data().toString().contains('rhymes')) {
              firebaseData = res.doc['rhymes'];
              ////debugPrint("MY DATA ------" + firebaseData);
              Map<String, dynamic> user = jsonDecode(firebaseData);
              ////debugPrint('Message ---- , ${user['Message']}!');

              KLTRhymesDataModel rhymesData =
                  KLTRhymesDataModel.fromJson(jsonDecode(firebaseData));

              for (int index = 0;
                  index < rhymesData.videoList.length;
                  index++) {
                if (widget.className == 'Senior KG' &&
                    rhymesData.videoList[index].classId == 4) {
                  ////debugPrint(res.doc.data().toString());
                  rhymesList.add(rhymesData.videoList[index]);
                } else if (widget.className == 'Junior KG' &&
                    rhymesData.videoList[index].classId == 3) {
                  rhymesList.add(rhymesData.videoList[index]);
                } else if (widget.className == 'PlayGroup' &&
                    rhymesData.videoList[index].classId == 6) {
                  rhymesList.add(rhymesData.videoList[index]);
                  ////debugPrint(res.doc.data().toString());
                } else if (widget.className == 'Nursery' &&
                    rhymesData.videoList[index].classId == 5) {
                  ////debugPrint('=======================NURSERY');
                  //rhymesList.add(rhymesData.videoList[index]);
                  if (widget.videoName.isNotEmpty) {
                    ////debugPrint('vide is not empty');
                    for (int jIndex = 0;
                        jIndex < rhymesData.videoList.length;
                        jIndex++) {
                      if (rhymesData.videoList[jIndex].videoName
                          .contains(widget.videoName)) {
                        ////debugPrint('video found for play NUR 93');
                        rhymesList.add(rhymesData.videoList[jIndex]);
                        break;
                      }
                    }
                  } else {
                    ////debugPrint('vide is empty');
                    rhymesList.add(rhymesData.videoList[index]);
                  }
                }
              }
            } else {
              ////debugPrint('0------------------'+res.doc.data().toString());
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
    //debugPrint('Length of list is ${rhymesList.length}');
    return getRhymesVideoWidgetFromListOfVideos(
        rhymesList, widget.videoName, 5);
  }
}

class RhymesAdaptar extends StatelessWidget {
  KltRhymesModel videoModel;
  String currentVideoName;
  int progressPercentage = 0;

  RhymesAdaptar(
      {super.key, required this.videoModel, required this.currentVideoName});

  Future<void> downloadFile(
      BuildContext context, KltRhymesModel specialiti) async {
    String extention = "mp4";
    if (videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }

    var storageReference =
        'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/Nursery/${specialiti.videoName}.$extention';
    final storageRef = FirebaseStorage.instance.refFromURL(storageReference);
    final appDocDir = await getApplicationDocumentsDirectory();
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
        '${appDocDir.path}/${specialiti.classId}/${specialiti.videoName.replaceAll(" ", "")}.$extention');
    progressPercentage = 0;
    //final file = File(filePath);
    //debugPrint(filePath.path);
    final downloadTask = storageRef.writeToFile(filePath);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          //debugPrint("Running");
          progressPercentage = Utility.getPercentage(
              taskSnapshot.bytesTransferred, taskSnapshot.totalBytes);

          break;
        case TaskState.paused:
          //debugPrint("paused");
          break;
        case TaskState.success:
          //debugPrint("success------===============");
          Navigator.pop(context);
          playVideo(context, videoModel);

          //EncrypData.decryptKltFile(filePath.path, specialiti.DecryptionKey);
          //decrypt_file(filePath.path, specialiti.DecryptionKey);
          break;
        case TaskState.canceled:
          //debugPrint("canceled");
          Navigator.pop(context);
          break;
        case TaskState.error:
          Navigator.pop(context);
          //debugPrint("error");
          break;
      }
    });
  }

  Future<void> playVideo(
      BuildContext context, KltRhymesModel videoModel) async {
    String extention = "mp4";
    if (videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = Directory('${appDocDir.path}/${videoModel.classId}');
    if ((await path.exists())) {
      // TODO:
      //debugPrint("exist  --- ");
    } else {
      // TODO:
      //debugPrint("not exist--");
      path.create();
    }
    final File filePath = File(
        '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention');

    if (filePath.existsSync()) {
      if (extention == 'mp3') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KltChewieRhymesPlayer(
                    filePath:
                        '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
                    background: videoModel.thumbanilUrl,
                    Title: videoModel.videoName,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => goToKltChewieVideo(
                  filePath:
                      '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
                  Title: videoModel.videoName)),
        );
      }
    } else {
      _onLoading(context);
      //debugPrint('File not found download and play');
      downloadFile(context, videoModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    String naming;
    if (videoModel.videoName.length < 15) {
      naming = videoModel.videoName + " " * (15 - videoModel.videoName.length);
    } else {
      naming = "${videoModel.videoName.substring(0, 12)}...";
    }
    if (currentVideoName == '') {
    } else if (videoModel.videoName.contains(currentVideoName) ||
        videoModel.videoName.replaceAll(" ", "").contains(currentVideoName)) {
      playVideo(context, videoModel);
    }
    return Card(
      child: Hero(
          tag: videoModel.videoName,
          child: Material(
            child: GridTile(
                child: InkWell(
              onTap: () {
                playVideo(context, videoModel);
              },
              child: GridTile(
                footer: Container(
                  color: Color(0xCCFFFFFF),
                  child: ListTile(
                    leading: Text(naming,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                        textAlign: TextAlign.left),
                    /*title: Text(
                            "Rs."+(oldPrice*0.5).toInt().toString(),
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.0),
                            textAlign: TextAlign.right
                        ),*/
                    /*subtitle: Text(
                            "Rs."+oldPrice.toString(),
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            textAlign: TextAlign.right
                        ),*/
                  ),
                ),
                child: Image.network(
                  videoModel.thumbanilUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )),
          )),
    );
  }

  void _onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(),
              Text("\n Loading \n $progressPercentage"),
            ],
          ),
        );
      },
    );
  }
}
