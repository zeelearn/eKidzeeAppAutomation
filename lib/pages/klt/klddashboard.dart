import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:ekidzee/pages/klt/data/PlayGroupVideo.dart';
import 'package:ekidzee/pages/klt/data/SeniorKGVideo.dart';
import 'package:ekidzee/pages/klt/data/data.dart';
import 'package:ekidzee/pages/klt/rhymes.dart';
import 'package:ekidzee/pages/klt/rhymes/JRKGRhymes.dart';
import 'package:ekidzee/pages/klt/rhymes/NurseryRhymes.dart';
import 'package:ekidzee/pages/klt/rhymes/PlayGroupRhymes.dart';
import 'package:ekidzee/pages/klt/rhymes/SRKGRhymes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_routes.dart';
import '../../helper/utils.dart';
import 'data/JuniorKGVideo.dart';
import 'kltvideodata.dart';
import 'models/KLTVideoModel.dart';
import 'models/klthome.dart';

String selectedCategorie = "Nursery";

class KLTScreen extends StatefulWidget {
  const KLTScreen({super.key});

  @override
  _KLTScreen createState() => _KLTScreen();
}

class _KLTScreen extends State<KLTScreen> {
  int _selectedIndex = 0;
  List<String> applicableClass = [
    'PlayGroup',
    'Nursery',
    'Junior KG',
    'Senior KG'
  ];
  var _chosenValue = 'PlayGroup';
  final pgRhymes = KltRhymesScreen(className: 'PlayGroup');
  final nurseryRhymes = KltRhymesScreen(className: 'Nursery');
  final jkgRhymes = KltRhymesScreen(className: 'Junior KG');
  final skgRhymes = KltRhymesScreen(className: 'SeniorKG');

  final pages = [
    PGRhymesScreen(
      className: "PlayGroup",
      videoName: '',
    ),
    PGVideo(
      className: "Nursery",
      videoName: '',
    ),
  ];

  var currentScreen;
  void _onItemTapped(int index) {
    _selectedIndex = index;
    //debugPrint("_selectedIndex ${_selectedIndex}");
  }

  void _onChanged(String className) {
    _chosenValue = className;
    //debugPrint("className _oncheange  ${className}  ${_selectedIndex}  ${_chosenValue} choosen class");
    if (_selectedIndex == 1) {
      if (_chosenValue == 'Nursery') {
        currentScreen = NurseryVideo(
          className: 'Nursery',
          videoName: '',
        );
      } else if (_chosenValue == 'Junior KG') {
        currentScreen = JuniorKGVideo(
          className: 'Junior KG',
          videoName: '',
        );
      } else if (_chosenValue == 'Senior KG') {
        currentScreen = SeniorKGVideo(
          className: 'SeniorKG',
          videoName: '',
        );
      } else {
        currentScreen = PGVideo(
          className: 'PlayGroup',
          videoName: '',
        );
      }
    } else {
      if (_chosenValue == 'Nursery') {
        currentScreen =
            NurseryRhymesScreen(className: _chosenValue, videoName: '');
      } else if (_chosenValue == 'Junior KG') {
        //debugPrint('jrkg selected');
        currentScreen = JRKGRhymesScreen(className: className, videoName: '');
      } else if (_chosenValue == 'Senior KG') {
        currentScreen = SRKGRhymesScreen(className: className, videoName: '');
      } else {
        currentScreen = PGRhymesScreen(className: className, videoName: '');
      }
      //debugPrint(_chosenValue+"------");
    }
  }

  @override
  void initState() {
    super.initState();
    //debugPrint('init state ${this._selectedIndex}');
    currentScreen = KltRhymesScreen(className: 'PlayGroup');
    _onChanged('PlayGroup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          DropdownButton<String>(
            focusColor: Colors.white,
            value: _chosenValue,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            items:
                applicableClass.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            hint: const Text(
              "Please choose a Class",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (value) {
              //debugPrint('onChange');
              setState(() {
                _chosenValue = value as String;
                _onChanged(_chosenValue);
                //debugPrint('_chosenValue  '+_chosenValue);
                //currentScreen = new KltRhymesScreen(className: _chosenValue);
              });
            },
          ),
          Expanded(child: currentScreen),
        ],
      )),
      /*body: Center(
        child: pages[_selectedIndex],
      ),*/
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_music),
                label: 'Rhymes',
                backgroundColor: Colors.blueAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_collection),
                label: 'Av\'s',
                backgroundColor: Colors.blueGrey),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 20,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              _onChanged(_chosenValue);
              _selectedIndex = index;
            });
          },
          elevation: 5),
    );
  }
}

class KltHomePage extends StatefulWidget {
  String className;

  KltHomePage({super.key, required this.className});

  @override
  _KltHomePageState createState() => _KltHomePageState();
}

class _KltHomePageState extends State<KltHomePage> {
  List<String> categories = ["Nursery", "PlayGroup", "Junior KG", "SeniorKG"];
  late List<KltVideoModel> specialities;

  List<String> applicableClass = [
    'PlayGroup',
    'Nursery',
    'Junior KG',
    'Senior KG'
  ];
  final _chosenValue = 'PlayGroup';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    specialities = getVideoList();
    getRhymesInfo();
  }

  Future<void> getRhymesInfo() async {
    await FCM.init();
    selectedCategorie = widget.className;
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(LocalConstant.FB_ACTIVITY_RHYMES);
    // to get data from all documents sequentially
    specialities.clear();
    collectionRef.snapshots().listen((result) {
      for (var res in result.docChanges) {
        if (res.type == DocumentChangeType.added) {
          //debugPrint("added");
          ////debugPrint(res.doc.data());
          setState(() {
            if (res.doc.data().toString().contains('myvideo')) {
              String firebaseData = res.doc['myvideo'];
              ////debugPrint("MY DATA ------" + firebaseData);
              Map<String, dynamic> user = jsonDecode(firebaseData);
              //debugPrint('Message ---- , ${user['Message']}!');

              KLTVideoDataModel videoData =
                  KLTVideoDataModel.fromJson(jsonDecode(firebaseData));

              for (int index = 0; index < videoData.videoList.length; index++) {
                if (selectedCategorie == 'SeniorKG' &&
                    videoData.videoList[index].classId == 3) {
                  specialities.add(videoData.videoList[index]);
                } else if (selectedCategorie == 'Junior KG' &&
                    videoData.videoList[index].classId == 4) {
                  specialities.add(videoData.videoList[index]);
                } else if (selectedCategorie == 'PlayGroup' &&
                    videoData.videoList[index].classId == 5) {
                  specialities.add(videoData.videoList[index]);
                } else if (selectedCategorie == 'Nursery' &&
                    videoData.videoList[index].classId == 6) {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
          itemCount: specialities.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return VideoAdaptar(
              videoModel: specialities[index],
              currentVideoName: '',
            );
          }),
    );
  }
}

bool isFileExists() {
  return false;
}

ByteData getFileBytes(File file) {
  Uint8List bytes = file.readAsBytesSync();
  return ByteData.view(bytes.buffer);
}

void decode(ByteData bytes, String key) {
  final encoded = base64.encode(key.codeUnits);
  //debugPrint('base64: $encoded');
}

Future<void> downloadFile(
    BuildContext context, KltVideoModel specialiti) async {
  // final storageRef = FirebaseStorage.instance.refFromURL(
  //     "gs://kidzeeandroidapp-91faf.appspot.com/klt_content/Videos/3/BLENDING SOUNDS.mp4");
  //debugPrint(specialiti.videoName);
  //debugPrint(specialiti.videoUrl);
  var storageReference =
      'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Videos/Nursery/NUR_${specialiti.videoName}.mp4';
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
        //debugPrint("success------===========${specialiti.videoName}====");
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
  // FileDetail fileDetail = FileDetail(
  //     name: specialiti.videoName,
  //     time: specialiti.duration,
  //     type: FileType.Video,
  //     path: specialiti.videoUrl);

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) => VideoApp(
  //             fileDetails: fileDetail,
  //           )),
  // );
}

class VideoAdaptar extends StatefulWidget {
  KltVideoModel videoModel;
  String currentVideoName;
  VideoAdaptar(
      {super.key, required this.videoModel, required this.currentVideoName});

  @override
  State<VideoAdaptar> createState() => _VideoAdaptarState();
}

class _VideoAdaptarState extends State<VideoAdaptar> {
  int progressPercentage = 0;
  String naming = '';

  @override
  void initState() {
    initVideo();
    super.initState();
  }

  void initVideo() {
    debugPrint('Video name is - ${widget.videoModel.videoName}');
    if (widget.videoModel.videoName.length < 15) {
      naming = widget.videoModel.videoName +
          " " * (15 - widget.videoModel.videoName.length);
    } else {
      naming = "${widget.videoModel.videoName.substring(0, 12)}...";
    }
    debugPrint(
        'CURRVID====${widget.videoModel.videoName}====================${widget.currentVideoName}');
    playVideo(context, widget.videoModel);
    // if (!mounted) return;
    setState(() {});
    /*  if (widget.currentVideoName.isNotEmpty &&
        (widget.videoModel.videoName.contains(widget.currentVideoName) ||
            widget.videoModel.videoName
                .replaceAll(" ", "")
                .contains(widget.currentVideoName))) {
      debugPrint(
          'CURRVID===QEUAL =${widget.videoModel.videoName.replaceAll(" ", "")}====================${widget.currentVideoName}');
      playVideo(context, widget.videoModel);
      // if (!mounted) return;
      setState(() {});
    } else {
      debugPrint(
          'CURRVID===NOT QEUAL =${widget.videoModel.videoName.replaceAll(" ", "")}====================${widget.currentVideoName}');
    } */
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

  Future<void> downloadFile(
      BuildContext context, KltVideoModel specialiti) async {
    try {
      String className = getClassName(specialiti.classId.toString());
      // className = 'PlayGroup';
      // var storageReference =
      //     'gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Videos/${specialiti.classId}/${specialiti.videoName}.mp4';
      var storageReference =
          'klt_content/Videos/${specialiti.classId}/${specialiti.videoName}.mp4';
      // 'klt_content/Videos/$className/${specialiti.videoName}.mp4';

      final storageRef = FirebaseStorage.instance.ref(storageReference);
      // final storageRef = FirebaseStorage.instance.refFromURL(storageReference);
      debugPrint(
          'Class Name for download file: $className class Id is - ${specialiti.classId} - $storageReference - $storageRef');
      final appDocDir = await getApplicationDocumentsDirectory();
      final path = Directory('${appDocDir.path}/${specialiti.classId}');
      if ((await path.exists())) {
        // TODO:
        ////debugPrint("exist");
      } else {
        // TODO:
        ////debugPrint("not exist");
        path.create();
      }
      // final File filePath =
      //     File('${appDocDir.path}/${specialiti.classId}/COLOURS.mp4');
      final File filePath = File(
          '${appDocDir.path}/${specialiti.classId}/${specialiti.videoName.replaceAll(" ", "")}.mp4');

      //final file = File(filePath);
      //debugPrint(filePath.path);
      if (await filePath.exists()) {
        //debugPrint('file exists ===${specialiti.videoName}');
      } else {
        final downloadTask = storageRef.writeToFile(filePath);
        //debugPrint("START------========${specialiti.videoName.replaceAll(" ", "")}=======");
        //debugPrint('gs://kidzeeandroidapp-91faf.appspot.com//klt_content/Videos/${className}/${specialiti.videoName}.mp4');
        downloadTask.snapshotEvents.listen((taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              progressPercentage = Utility.getPercentage(
                  taskSnapshot.bytesTransferred, taskSnapshot.totalBytes);
              if (mounted) {
                setState(() {});
              }
              debugPrint(
                  "Running ${specialiti.videoName.replaceAll(" ", "")} - $progressPercentage");
              // ${progressPercentage}");

              break;
            case TaskState.paused:
              ////debugPrint("paused");
              break;

            case TaskState.success:
              // Navigator.pop(context);
              // playVideo(context, widget.videoModel);
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
    } catch (e) {
      debugPrint('exeption catch $e');
    }
  }

  Future<void> playVideo(BuildContext context, KltVideoModel videoModel) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = Directory('${appDocDir.path}/${videoModel.classId}');
    debugPrint(
        'Downloading video path - ${appDocDir.path}/${videoModel.classId}');
    if ((await path.exists())) {
      // TODO:
      debugPrint("exist  --- ");
    } else {
      // TODO:
      debugPrint("not exist--");
      path.create();
    }
    final File filePath = File(
        '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.mp4');

    if (filePath.existsSync()) {
      debugPrint('Path Found play File --507');
      //Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => goToKltChewieVideo(
                filePath:
                    '${appDocDir.path}/${videoModel.classId}/${videoModel.videoName.replaceAll(" ", "")}.mp4',
                Title: videoModel.videoName)),
      ).then(
        (value) {
          Navigator.pop(context);
        },
      );
    } else {
      // _onLoading(context);
      debugPrint('File not found download and play ${videoModel.videoName}');
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
    ) /*Card( 
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
              Text("\n Loading $progressPercentage \n"),
            ],
          ),
        );
      },
    );
  }
}
