import 'dart:io';

import 'package:ekidzee/widget/video_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app_routes.dart';
import '../../../helper/utils.dart';
import '../../../videoplayer/KltChewieRhymes.dart';
import '../models/rhymesmodel.dart';

class RhymesAdaptar extends StatefulWidget {
  KltRhymesModel videoModel;
  String currentVideoName;
  RhymesAdaptar(
      {super.key, required this.videoModel, required this.currentVideoName});

  @override
  State<RhymesAdaptar> createState() => _RhymesAdaptarState();
}

class _RhymesAdaptarState extends State<RhymesAdaptar> {
  String naming = '';
  int progressPercentage = 0;
  @override
  void initState() {
    initRhymes();
    super.initState();
  }

  void initRhymes() {
    if (widget.videoModel.videoName.length < 15) {
      naming = widget.videoModel.videoName +
          " " * (15 - widget.videoModel.videoName.length);
    } else {
      naming = "${widget.videoModel.videoName.substring(0, 12)}...";
    }
    playVideo(context, widget.videoModel);
    setState(() {});
    /*    if (widget.currentVideoName == '') {
    } else if (widget.videoModel.videoName.contains(widget.currentVideoName) ||
        widget.videoModel.videoName
            .replaceAll(" ", "")
            .contains(widget.currentVideoName)) {
      playVideo(context, widget.videoModel);
    } */
  }

  Future<void> downloadFile(
      BuildContext context, KltRhymesModel specialiti) async {
    String className = getClassName(specialiti.classId.toString());
    String extention = "mp4";
    if (widget.videoModel.Rhyme_Type == 'AUDIO') {
      extention = "mp3";
    }

    // var storageReference =
    //     'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/${specialiti.classId}/${specialiti.videoName}.$extention';
    var storageReference =
        'klt_content/Rhymes/${specialiti.classId}/${specialiti.videoName}.$extention';
    debugPrint('Rhymes download path: $storageReference');
    // var storageReference =
    //     'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Rhymes/Junior KG/${specialiti.videoName}.$extention';
    final storageRef = FirebaseStorage.instance.ref(storageReference);
    // final storageRef = FirebaseStorage.instance.refFromURL(storageReference);
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

    //final file = File(filePath);
    //debugPrint(filePath.path);
    final downloadTask = storageRef.writeToFile(filePath);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          progressPercentage = Utility.getPercentage(
              taskSnapshot.bytesTransferred, taskSnapshot.totalBytes);
          if (mounted) {
            setState(() {});
          }
          //debugPrint("Running");
          break;
        case TaskState.paused:
          //debugPrint("paused");
          break;
        case TaskState.success:
          //debugPrint("success------===============");
          // Navigator.pop(context);
          // playVideo(context, widget.videoModel);

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

    await downloadTask.whenComplete(() async {
      playVideo(context, widget.videoModel);
      // Navigator.pop(context);
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
        ).then(
          (value) {
            Navigator.pop(context);
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => goToKltChewieVideo(
                  filePath:
                      '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.$extention',
                  Title: videoModel.videoName)),
        ).then(
          (value) {
            Navigator.pop(context);
          },
        );
      }
    } else {
      // _onLoading(context);
      //debugPrint('File not found download and play');
      downloadFile(context, videoModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              value: progressPercentage / 100,
            ),
          ),
          Text('Please wait...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
              textAlign: TextAlign.left)
        ],
      ),
    ) /* Card(
      child: Hero(
          tag: widget.videoModel.videoName,
          child: Material(
            child: GridTile(
                child: InkWell(
              onTap: () {
                playVideo(context, widget.videoModel);
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
                  widget.videoModel.thumbanilUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )),
          )),
    ) */
        ;
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
