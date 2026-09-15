import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/app_routes.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:ekidzee/pages/k12/core/widgets/vimeo_player.dart';
import 'package:ekidzee/pages/klt/models/KLTVideoModel.dart';
import 'package:ekidzee/videoplayer/KltChewieRhymes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../pages/klt/models/KLTRhymesModel.dart';
import '../pages/klt/models/rhymesmodel.dart';

class KidzeeQRScreen extends StatefulWidget {
  const KidzeeQRScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class QRContent {
  late String type = '';
  late String root = '';
  late String videoId = '';
  late String classId = '';
  late String videoName = '';
}

class _QRViewState extends State<KidzeeQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String progressPercentage = "";
  QRContent content = QRContent();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Scan QR Code"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                    )
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      debugPrint("===QRCODE SCANNED - ${scanData.code}");
      setState(() {
        result = scanData;
        try {
          //debugPrint("===QRCODE${scanData.code}");
          parseQrCode(scanData.code!);
          // return;
        } catch (e) {}
      });
    });
  }

  void parseQrCode(String data) async {
    var dataArray = data.split(";");
    controller?.pauseCamera();
    for (int index = 0; index < dataArray.length; index++) {
      var value = dataArray[index].split(":");
      if (value[0] == 'Type') {
        content.type = value[1];
      } else if (value[0] == 'Root') {
        content.root = value[1];
      } else if (value[0] == 'Video_ID') {
        content.videoId = value[1];
      } else if (value[0] == 'Rhyme_Id') {
        content.videoId = value[1];
      } else if (value[0] == 'Class_Id') {
        content.classId = value[1];
      } else if (value[0] == 'Video_Name') {
        content.videoName = value[1];
      } else if (value[0] == 'Video_Name') {
        content.videoName = value[1];
      } else if (value[0] == 'Rhyme_Name') {
        content.videoName = value[1];
      }
    }

    debugPrint("===QRCODE ${content.videoName} ${content.classId}");

    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(LocalConstant.FB_ACTIVITY_RHYMES);

    QuerySnapshot result = await collectionRef.get();
    bool isMatchFound = false;

    /* 6	Playgroup
5	Nursery
3	Junior KG
4	Senior KG */
    if (content.type == 'Rhymes') {
      for (var doc in result.docs) {
        if (doc.data().toString().contains('rhymes')) {
          String firebaseData = doc['rhymes'];

          KLTRhymesDataModel rhymesData =
              KLTRhymesDataModel.fromJson(jsonDecode(firebaseData));

          for (int index = 0; index < rhymesData.videoList.length; index++) {
            String eName =
                rhymesData.videoList[index].videoName.replaceAll(" ", "");
            String vName = content.videoName.replaceAll(" ", "");
            if (eName == vName &&
                rhymesData.videoList[index].classId.toString() ==
                    content.classId) {
              isMatchFound = true;
              debugPrint(
                  '========Scanned content found Rhymes ===== - ${rhymesData.videoList[index].videoName} - ${rhymesData.videoList[index].videoUrl}');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KltChewieRhymesPlayer(
                          filePath: rhymesData.videoList[index].videoUrl,
                          background: rhymesData.videoList[index].thumbanilUrl,
                          Title: rhymesData.videoList[index].videoName,
                        )),
              ).then(
                (value) {
                  Navigator.pop(context);
                },
              );
              return;
            }
          }
        }
      }
    } else {
      for (var doc in result.docs) {
        if (doc.data().toString().contains('myvideo')) {
          String firebaseData = doc['myvideo'];

          KLTVideoDataModel videoData =
              KLTVideoDataModel.fromJson(jsonDecode(firebaseData));

          for (int index = 0; index < videoData.videoList.length; index++) {
            String eName =
                videoData.videoList[index].videoName.replaceAll(" ", "");
            String vName = content.videoName.replaceAll(" ", "");
            if (eName == vName &&
                videoData.videoList[index].classId.toString() ==
                    content.classId) {
              isMatchFound = true;
              debugPrint(
                  '========Scanned content found video ===== - ${videoData.videoList[index].videoName} - ${videoData.videoList[index].videoUrl}');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => videoData.videoList[index].videoUrl
                            .contains('vimeo.com')
                        ? Scaffold(
                            appBar: AppBar(
                              title: Text(videoData.videoList[index].videoName),
                              automaticallyImplyLeading: true,
                            ),
                            body: VimeoPlayerLocal(
                                videoId: videoData.videoList[index].videoUrl
                                    .split('/')
                                    .last,
                                mId: 0,
                                isPip: false),
                          )
                        : goToKltChewieVideo(
                            filePath: videoData.videoList[index].videoUrl,
                            Title: videoData.videoList[index].videoName)),
              ).then(
                (value) {
                  Navigator.pop(context);
                },
              );
              return;
            }
          }
        }
      }
    }

    if (!isMatchFound) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Not Found"),
            content: Text(
                "No matching ${content.type} found for the scanned content."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      ).then(
        (value) => Navigator.pop(context),
      );
    }
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
              Text("\n Loading $progressPercentage \n"),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> getRhymes(final String className) async {
    await FCM.init();
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(LocalConstant.FB_ACTIVITY_RHYMES);
    // to get data from all documents sequentially
    collectionRef.snapshots().listen((result) {
      for (var res in result.docChanges) {
        if (res.type == DocumentChangeType.added) {
          setState(() {
            String firebaseData;
            ////debugPrint(res.doc.data().toString());
            if (res.doc.data().toString().contains('rhymes')) {
              firebaseData = res.doc['rhymes'];
              Map<String, dynamic> user = jsonDecode(firebaseData);
              KLTRhymesDataModel rhymesData = KLTRhymesDataModel.fromJson(
                jsonDecode(firebaseData),
              );
              for (int index = 0;
                  index < rhymesData.videoList.length;
                  index++) {
                if (content.classId.toString() ==
                        rhymesData.videoList[index].classId.toString() &&
                    rhymesData.videoList[index].videoName.contains(
                      content.videoName,
                    )) {
                  //debugPrint('========Scanned content found=====');
                  playAudio(context, rhymesData.videoList[index], className);
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

  Future<void> playAudio(
    BuildContext context,
    KltRhymesModel videoModel,
    String className,
  ) async {
    String extention = "mp4";
    if (videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = Directory('${appDocDir.path}/${videoModel.classId}');
    if ((await path.exists())) {
      // TODO:
      //debugPrint("exist  --223 qr_scanner- ");
    } else {
      // TODO:
      //debugPrint("not exist--");
      path.create();
    }
    final File filePath = File(
      '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
    );
    //debugPrint(filePath.path);
    if (filePath.existsSync()) {
      //debugPrint('file extension is ${extention}');
      if (extention == 'mp3') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => goToKltChewieVideo(
              filePath:
                  '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
              Title: videoModel.videoName,
            ),
          ),
        );
        /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KltChewieRhymesPlayer(
                filePath: '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.${extention}',
                background : videoModel.thumbanilUrl,
                Title: videoModel.videoName,
              )),
        );*/
      } else {
        //debugPrint('Playing....');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => goToKltChewieVideo(
              filePath:
                  '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
              Title: videoModel.videoName,
            ),
          ),
        );
      }
    } else {
      _onLoading(context);
      //debugPrint('File not found download and play 267');
      downloadRhymes(context, videoModel, className);
    }
  }

  Future<void> downloadRhymes(
    BuildContext context,
    KltRhymesModel videoModel,
    String className,
  ) async {
    String extention = "mp4";
    if (videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }
    var storageReference =
        'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/${videoModel.classId}/${videoModel.videoName}.$extention';
    //debugPrint('gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/${videoModel.classId}/${videoModel.videoName}.${extention}');
    final storageRef = FirebaseStorage.instance.refFromURL(storageReference);
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = Directory('${appDocDir.path}/${videoModel.classId}');
    if ((await path.exists())) {
      // TODO:
      //debugPrint("exist");
    } else {
      // TODO:
      //debugPrint("not exist");
      path.create();
    }
    final File filePath = File(
      '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName}.$extention',
    );

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
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => goToRhymesPlayer(
                videoModel: videoModel,
                filePath:
                    '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName}.$extention',
                Title: videoModel.videoName,
              ),
            ),
          );

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
}
