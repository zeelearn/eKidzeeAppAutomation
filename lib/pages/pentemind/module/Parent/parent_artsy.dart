import 'dart:convert';
import 'dart:io';

import 'package:ekidzee/api/request/pentemind/parent_corner/artsy_request.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/update_artsy_parent.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/main.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../../../api/response/pentemind/parent_corner/artst.dart';
import '../../../../app_routes.dart';
import '../../../../constants.dart';
import '../../../../helper/DatabaseHelper.dart';
import '../../../../widget/image_viewer.dart';
import '../../../notification/NotificationService.dart';

class ParentArtsyScreen extends StatefulWidget {
  const ParentArtsyScreen({super.key});

  @override
  _ParentArtsyScreenState createState() => _ParentArtsyScreenState();
}

class _ParentArtsyScreenState extends State<ParentArtsyScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  int studentId = 0;
  int classId = 0;
  String className = '';
  String cName = '';
  int programId = 0;
  List<ArtsyModel> mArtsyList = [];
  late ArtsyModel mArtsyModel;

  String _chosenValue = 'Select Culmination';
  List<String> options = ['Select Culmination', '2', '4', '6'];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  Future<void> loadData() async {
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('_Academic Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      //getArtsyList();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    //_dayController.text = '1';
    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getArtsyList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  bool getLocalData(data) {
    bool isLoad = false;
    try {
      mArtsyList.clear();
      isLoading = false;
      ArtsyResponse response = ArtsyResponse.fromJson(
        json.decode(data!),
      );
      mArtsyList.addAll(response.artsyList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_LOGBOOK}';
  }

  Future<void> savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  void getArtsyList() {
    mArtsyList.clear();
    if (_chosenValue == 'Select Culmination') {
      isLoading = false;
      setState(() {});
    } else {
      isLoading = true;
      setState(() {});
      ArtsyRequest request = ArtsyRequest(
          ProgramID: programId,
          C: _chosenValue,
          FeeType: 'Classic',
          UserID: uid,
          StudentID: studentId);
      APIService apiService = APIService();
      apiService.getArtsy(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is ArtsyResponse) {
            ArtsyResponse response = value;
            String json = jsonEncode(response);
            savechildSummery(json);
            mArtsyList.addAll(response.artsyList);
            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {});
      });
    }
  }

  void saveModel(ArtsyModel model) {
    mArtsyModel = model;
  }

  void showImageOption(ArtsyModel model) {
    saveModel(model);
    List<String> options = ['Gallery', 'Camera'];
    if (model.ParentMediaUrl.isNotEmpty) {
      options.add('View Image');
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select'),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(options[index]),
                    leading: Icon(
                      index == 0
                          ? Icons.image
                          : index == 1
                              ? Icons.camera
                              : Icons.image_search,
                      size: 25,
                    ),
                    onTap: () {
                      Navigator.pop(context, options[index]);
                      if (options[index] == 'Gallery') {
                        showImagePicker(0);
                      } else if (options[index] == 'Camera') {
                        showImagePicker(1);
                      } else {
                        showImagePicker(3);
                      }
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  Future<void> showImagePicker(int action) async {
    if (action != 3) {
      XFile? photo;
      if (action == 0) {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        photo = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 72);
      }
      if (photo != null) {
        //offline imageupload
        updateImage(photo.path);
        if (!kIsWeb && !await Utility.isInternet()) {
          UpdateParentArtsyModel model = UpdateParentArtsyModel(
              PCID: mArtsyModel.PCID,
              StatusCode: 'D',
              ParentMediaUrl: photo.path,
              TransType: mArtsyModel.TransType);
          UpdateArtsyRequest request = UpdateArtsyRequest(
              ProgramID: programId.toString(),
              ClassId: classId.toString(),
              StudentID: studentId.toString(),
              UserID: uid,
              InputData: model);
          DBHelper dbHelper = DBHelper();
          dbHelper.insertSyncData(
              request.toJson(),
              LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY,
              int.parse(teacherId));
          Utility.getConfirmationDialog(
              context,
              LocalConstant.LBL_REQUEST_RECEIVED,
              LocalConstant.LBL_REQUEST_SEND,
              this);
          NotificationService notificationService = NotificationService();
          notificationService.showNotification(
              14,
              LocalConstant.LBL_REQUEST_RECEIVED,
              LocalConstant.LBL_REQUEST_SEND,
              LocalConstant.LBL_REQUEST_SEND);
          initializeService();
        } else {
          Utility.showLoaderDialog(context);
          APIService().uploadImage(uid, photo, listener: this);
          //APIService().updateImageUpload(uid, photo.path);
        }
      }
    } else {
//       debugPrint('in else');
      var result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageViewer(imageUrl: mArtsyModel.ParentMediaUrl);
      })); //Navigate to another page
//       debugPrint('response from imageviewer');
    }
  }

  void updateImage(String photo) {
    mArtsyModel.ParentMediaUrl = photo;
//     debugPrint('image is $photo');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Parent:Artsy');
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
              getArtsyList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                            color: LightColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Expanded(
                          flex: 5, // 30%
                          child: Text(''),
                        ),
                        Expanded(
                            flex: 25, // 30%
                            child: MyWidget().richText(
                                'Culmination', LightColors.textSmallStyle)),
                        Expanded(
                            flex: 50, // 30%
                            child: MyWidget().getDropdownButton(
                                'Select Culmination',
                                _chosenValue,
                                options,
                                Utility.ACTION_OBSERVATION,
                                this)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  getChildList()
                  // Let's create an order model
                ],
              ),
            ),
          ),
        ));
  }

  Container getHomeWorkInfo(ArtsyModel model) {
    //debugPrint(model.UploadUrl);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color.fromRGBO(220, 233, 245, 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => goToVideoPlayer(
                          path: model.MediaUrl,
                          Title: model.Title,
                        )),
              );
            },
            child: Container(
              width: ScreenUtil().setWidth(37.0),
              height: ScreenUtil().setHeight(37.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(221, 40, 81, 0.18),
              ),
              child: true
                  ? Image.asset('assets/icons/ic_video.png')
                  : FadeInImage(
                      width: 20,
                      height: 20,
                      placeholder:
                          const AssetImage('assets/icons/ic_upload.png'),
                      image: NetworkImage(model.MediaUrl),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/icons/ic_error_image.png',
                            fit: BoxFit.fitWidth);
                      },
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.Title,
                  style: const TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                MyWidget.textRow("Trans Type", model.TransType),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showImageOption(model);
            },
            child: model.ParentMediaUrl.isNotEmpty &&
                    model.ParentMediaUrl.toLowerCase().contains('data/')
                ? SizedBox(
                    width: 37,
                    height: 37,
                    child: CircleAvatar(
                      backgroundImage: FileImage(
                        File(model.ParentMediaUrl),
                      ),
                      radius: 200.0,
                    ))
                : Container(
                    width: ScreenUtil().setWidth(37.0),
                    height: ScreenUtil().setHeight(37.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 99, 2, 0.15),
                    ),
                    child: FadeInImage(
                      width: 30,
                      height: 30,
                      placeholder: const AssetImage(
                          'assets/icons/image_placeholder.png'),
                      image: NetworkImage(model.ParentMediaUrl.toString()),
                      imageErrorBuilder: (context, error, stackTrace) {
                        debugPrint(error.toString());
                        return Image.asset(
                            'assets/icons/ic_no_img_uploaded.png',
                            fit: BoxFit.fitWidth);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (_chosenValue.trim() == 'Select Culmination') {
      return Column(
        children: [
          _chosenValue.trim() == 'Select Culmination' || _chosenValue == '0'
              ? Utility.filter(context, 'Select Culmination')
              : Utility.emptyData(context,
                  "Data are not available at this moment please check later")
        ],
      );
    } else if (mArtsyList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else if (_chosenValue == 'Select Culmination') {
      return Utility.filter(context, "Please Select the Culmination");
    } else {
      return Flexible(
          child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Lets pass the order to a new widget and render it there
          return getHomeWorkInfo(mArtsyList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 15.0,
          );
        },
        itemCount: mArtsyList.length,
      ));
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      setState(() {
        _chosenValue = value;
        getArtsyList();
      });
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      if (value is UploadImageResponse) {
//         debugPrint('534 ${value.toJson()}');
        UploadImageResponse response = value;
        if (value.message.contains('Successfully')) {
          //mHomeWork.UploadUrl = value.imageModel![0].location;
          UpdateParentArtsyModel model = UpdateParentArtsyModel(
              PCID: mArtsyModel.PCID,
              StatusCode: 'D',
              ParentMediaUrl: value.imageModel![0].location,
              TransType: mArtsyModel.TransType);
          UpdateArtsyRequest request = UpdateArtsyRequest(
              ProgramID: programId.toString(),
              ClassId: classId.toString(),
              StudentID: studentId.toString(),
              UserID: uid,
              InputData: model);
          APIService().updateArtsy(request, token).then((value) {
            debugPrint(value.toString());
            isLoading = false;
            if (value != null) {
              if (value == null) {
                Utility.showMessage(context, 'Unable to save...');
              } else if (value is GenericResponse) {
                GenericResponse response = value;
                if (response.success == 200) {
                  try {
                    Utility.showMessage(context, response.response.response);
                  } catch (e) {
                    Utility.showMessage(
                        context,
                        response.response is String
                            ? response.response
                            : response.response.response.toString());
                  }
                }
              } else {
                Utility.showMessage(context, 'Unable to save...');
              }
            }
            Navigator.of(context, rootNavigator: true).pop('dialog');
            getArtsyList();
          });
        } else {
          Utility.showMessageCallback(context, 'Alert', value.message, this);
        }
      }
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      //Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
