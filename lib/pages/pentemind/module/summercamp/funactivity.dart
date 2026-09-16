import 'dart:io';

import 'package:ekidzee/api/request/pentemind/learningmaterial/learning_material.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../../../app_routes.dart';
import '../../../../constants.dart';
import '../../../../videoplayer/AudioPlayer.dart';

class PentemindFunActivityScreen extends StatefulWidget {
  String contentType;
  PentemindFunActivityScreen({super.key, required this.contentType});

  @override
  _LearningMaterialScreenState createState() => _LearningMaterialScreenState();
}

class _LearningMaterialScreenState extends State<PentemindFunActivityScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isLoading = true;
  late final prefs;
  String uid = '';
  late int programId;
  String token = '';
  List<LearningMaterialModel> mMaterials = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getMaterials();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;

    getMaterials();
  }

  getMaterials() {
    mMaterials.clear();
    isLoading = true;
    setState(() {});
    if (widget.contentType.isNotEmpty) {
//       debugPrint('in apis');
      LearningMaterialRequest request = LearningMaterialRequest(
          ProgramID: programId.toString(),
          D: '-1',
          ContentCategory: widget.contentType,
          UserID: uid);
      APIService apiService = APIService();
      apiService.getLearningMaterials(request, false, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is LearningMaterialResponse) {
            LearningMaterialResponse response = value;
            mMaterials.clear();
            mMaterials.addAll(response.data.mateialList);
            checkFileStatus();

            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {});
      });
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  checkFileStatus() async {
    if (kIsWeb) {
      imageList.clear();
      if (mounted) setState(() {});
      return;
    }
    debugPrint(widget.contentType);
    imageList.clear();
    for (int index = 0; index < mMaterials.length; index++) {
      String dir = (await getTemporaryDirectory()).path;
      String path = '$dir/${mMaterials[index].ContentDescription}.png';
      debugPrint(path);
      if (await File(path).exists()) {
        imageList.putIfAbsent(
          mMaterials[index].ContentDescription,
          () => true,
        );
      }
    }
    if (mounted) setState(() {});
  }

  isFileExists(LearningMaterialModel item) async {
    if (kIsWeb) return false;
    bool isImage = false;
    String dir = (await getTemporaryDirectory()).path;
    String path = '$dir/${item.ContentDescription}.png';
    debugPrint(path);
    if (await File(path).exists()) {
      isImage = true;
    } else {
      isImage = false;
    }
    return isImage;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('PentemindActivities');
    ScreenUtil.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getMaterials();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Utility.showLoader();
    } else if (mMaterials.isEmpty) {
      return Column(
        children: [
          Utility.emptyData(context,
              "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: imageGrid(),
      );
    }
  }

  Widget imageGrid() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: mMaterials
                    .map((item) => Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return goToImageViewer(imageUrl: item.WebUrl);
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(item.WebUrl),
                                    fit: BoxFit.cover)),
                            child: Transform.translate(
                              offset: Offset(50, -50),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 60),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: imageList.containsKey(
                                            item.ContentDescription)
                                        ? Colors.blueAccent
                                        : Colors.white),
                                child: GestureDetector(
                                  onTap: () async {
                                    (await isFileExists(item))
                                        ? shareFile(item)
                                        : setState(() {
                                            isLoading = true;
                                          });
                                    Utility.downloadFile(item.WebUrl,
                                            "${item.ContentDescription}.png")
                                        .then((value) {
                                      isLoading = false;
                                      getMaterials();
                                    });
                                    //Utility.requestDownload(item.WebUrl, item.ContentDescription);
                                    /*Utility.downloadFile(item.WebUrl, item.ContentDescription).then((value) {
                                    isLoading = false;
                                    getMaterials();
                                  });*/
                                  },
                                  child: Icon(
                                      imageList.containsKey(
                                              item.ContentDescription)
                                          ? Icons.share
                                          : Icons.download,
                                      size: 20,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )))
                    .toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  getActivityWidget(LearningMaterialModel model, int index) {
    return GestureDetector(
      onTap: () {
        if (model.MediaType == 'mp3') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AudioPlayer(
                      path: model.WebUrl,
                      background: model.BackgroundURL,
                      Title: model.ContentDescription,
                    )),
          );
        } else if (model.MediaType == 'mp4') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => goToVideoPlayer(
                      path: model.WebUrl,
                      Title: model.ContentDescription,
                    )),
          );
        } else if (model.MediaType == 'pdf') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => goToMyPdf(
                worksheetUrl: model.WebUrl,
                title: model.ContentDescription,
                filename: model.ContentDescription,
                module: 'material',
                isDownload: false,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x430F1113),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                  leading: getTrailingImage(getImage(model.MediaType)),
                  title: Padding(
                    padding: EdgeInsetsDirectional.all(0),
                    child: Text(
                      model.ContentDescription,
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                        color: Color(0xFF4B39EF),
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                  trailing:
                      model.MediaType == 'mp4' ? null : getIcon(model, index)),
            ],
          ),
        ),
      ),
    );
  }

  getImage(String type) {
    if (type == 'pdf') {
      return 'assets/icons/ic_worksheet.png';
    } else if (type == 'mp3') {
      return 'assets/icons/ic_rhymes.png';
    } else if (type == 'mp4') {
      return 'assets/icons/ic_video.png';
    } else {
      return 'assets/icons/ic_worksheet.png';
    }
  }

  Map<String, bool> imageList = {};

  shareFile(LearningMaterialModel model) async {
    if (kIsWeb) {
      await Utility.downloadFile(
          model.WebUrl, '${model.ContentDescription}.png');
      return;
    }
    String dir = (await getTemporaryDirectory()).path;
    String path = '$dir/${model.ContentDescription}.png';
    Share.shareXFiles([XFile(path)], text: model.ContentDescription);
  }

  getIcon(LearningMaterialModel model, int index) {
    return GestureDetector(
      onTap: () {
        imageList.containsKey(model.ContentDescription)
            ? shareFile(model)
            : setState(() {
                isLoading = true;
              });
        Utility.downloadFile(model.WebUrl, '${model.ContentDescription}.png')
            .then((value) {
          isLoading = false;
          getMaterials();
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(37.0),
        height: ScreenUtil().setHeight(37.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: imageList.containsKey(model.ContentDescription)
              ? Color.fromRGBO(234, 250, 241, 0.94)
              : Color.fromRGBO(221, 40, 81, 0.18),
        ),
        child: Icon(
          imageList.containsKey(model.ContentDescription)
              ? Icons.share
              : Icons.download,
          color: Color.fromRGBO(52, 152, 219, 1),
        ),
      ),
    );
  }

  getTrailingImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        image,
        height: 40.0,
        width: 40.0,
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }

  showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),*/
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 8,
        ),
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                list.length,
                (index) => Card(
                  borderOnForeground: true,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        //updateSelection(action, list[index]);
                      },
                      child: MyWidget()
                          .richText(list[index], LightColors.textbigStyle),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
