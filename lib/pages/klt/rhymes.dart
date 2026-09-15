import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_routes.dart';
import 'kltvideodata.dart';
import 'models/KLTRhymesModel.dart';
import 'models/rhymesmodel.dart';

class KltRhymesScreen extends StatefulWidget {
  String className;
  KltRhymesScreen({super.key, required this.className});

  @override
  _KltHomePageState createState() => _KltHomePageState();
}

class _KltHomePageState extends State<KltRhymesScreen> {
  List<String> categories = ["Nursery", "PlayGroup", "Junior KG", "SeniorKG"];
  List<KltRhymesModel> rhymesList = getRhymes();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //debugPrint("init   ====== KltRhymesScreen  "+widget.className);
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
        ////debugPrint("added-----");
        if (res.type == DocumentChangeType.added) {
          ////debugPrint("added-----");
          setState(() {
            String firebaseData;
            ////debugPrint(res.doc.data().toString());
            if (res.doc.data().toString().contains('rhymes')) {
              firebaseData = res.doc['rhymes'];
              Map<String, dynamic> user = jsonDecode(firebaseData);
              KLTRhymesDataModel rhymesData =
                  KLTRhymesDataModel.fromJson(jsonDecode(firebaseData));

              for (int index = 0;
                  index < rhymesData.videoList.length;
                  index++) {
                if (widget.className == 'Senior KG' &&
                    rhymesData.videoList[index].classId == 3) {
                  rhymesList.add(rhymesData.videoList[index]);
                  ////debugPrint(rhymesData.videoList[index].toString());
                } else if (widget.className == 'Junior KG' &&
                    rhymesData.videoList[index].classId == 4) {
                  rhymesList.add(rhymesData.videoList[index]);
                } else if (widget.className == 'PlayGroup' &&
                    rhymesData.videoList[index].classId == 5) {
                  rhymesList.add(rhymesData.videoList[index]);
                  ////debugPrint(res.doc.data().toString());
                } else if (widget.className == 'Nursery' &&
                    rhymesData.videoList[index].classId == 6) {
                  ////debugPrint(res.doc.data().toString());
                  rhymesList.add(rhymesData.videoList[index]);
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
          itemCount: rhymesList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return RhymesAdaptar(
              videoModel: rhymesList[index],
            );
          }),
    );
  }
}

class RhymesAdaptar extends StatelessWidget {
  KltRhymesModel videoModel;

  RhymesAdaptar({super.key, required this.videoModel});

  Future<void> downloadFile(
      BuildContext context, KltRhymesModel specialiti) async {
    String extention = "mp4";
    if (videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }

    var storageReference =
        'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/Junior KG/${specialiti.videoName}.$extention';
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
        '${appDocDir.path}/${specialiti.classId}/${specialiti.videoName}.$extention');

    //final file = File(filePath);
    ////debugPrint(filePath.path);
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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => goToKltChewieVideo(
                    filePath:
                        '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName}.$extention',
                    Title: videoModel.videoName)),
          );

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
      extention = "mp";
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
        '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName}.$extention');

    if (filePath.existsSync()) {
      //debugPrint('Path Found play File');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => goToKltChewieVideo(
                filePath:
                    '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName}.$extention',
                Title: videoModel.videoName)),
      );
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
              Text("\nLoading\n"),
            ],
          ),
        );
      },
    );
  }
}
