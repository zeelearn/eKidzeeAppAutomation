import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/api/request/pentemind/update_homework.dart';
import 'package:ekidzee/app_routes.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/ecampus/widget/pdfHomeworkUploadcubit/pdf_homework_upload_cubit.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../../../api/response/pentemind/parent/myhomework.dart';
import '../../../../constants.dart';
import '../../../../helper/DatabaseHelper.dart';
import '../../../../main.dart';
import '../../../../widget/CalendarAppBar.dart';
import '../../../../widget/MyWidget.dart';
import '../../../../widget/image_viewer.dart';
import '../../../ecampus/widget/pdfviewer.dart';
import '../../../notification/NotificationService.dart';

class MyHomeworkScreen extends StatefulWidget {
  bool isToolbar;
  String? culminationId;
  int? programId;
  String? homeworkId;
  MyHomeworkScreen(
      {super.key,
      required this.isToolbar,
      this.culminationId,
      this.programId,
      this.homeworkId});

  @override
  _MyHomeworkScreenState createState() => _MyHomeworkScreenState();
}

class _MyHomeworkScreenState extends State<MyHomeworkScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isPDF = false;
  bool isUpload = false;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  int studentId = 0;
  String className = '';
  String cName = '';
  int programId = 0;
  List<MyHomeworkModel> mHomeworkList = [];
  List<MyHomeworkModel> mTodaysHomework = [];
  late MyHomeworkModel mHomeWork;
  bool isNewUi = false;
  final ImagePicker _picker = ImagePicker();

  MyHomeworkModel? selectedDate;
  Random random = Random();

  @override
  void initState() {
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
    debugPrint('_Academic Screen didChangeAppLifecycleState $state ');
    if (!isUpload && state == AppLifecycleState.resumed) {
      getHomework();
      isUpload = false;
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
    //_dayController.text = '1';
    var childAdvancementSummery = prefs.getString(getId());
    if (childAdvancementSummery == null) {
      getHomework();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mHomeworkList.clear();
      isLoading = false;
      MyHomeworkResponse response = MyHomeworkResponse.fromJson(
        json.decode(data!),
      );
      mHomeworkList.addAll(response.homeworkList);
      mHomeworkList.sort((a, b) => a.AssignedDate.toLowerCase()
          .compareTo(b.AssignedDate.toString().toLowerCase()));
      mHomeworkList = mHomeworkList.reversed.toList();
      //getUniqueDays();
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

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getHomework() {
    mHomeworkList.clear();
    isLoading = true;
    setState(() {});
    BasePentemindRequest request = BasePentemindRequest(
        Program_ID: widget.programId ?? programId, userId: uid);
    APIService apiService = APIService();
    apiService
        .getMyHomework(request, studentId.toString(), token)
        .then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is MyHomeworkResponse) {
          MyHomeworkResponse response = value;
          String json = jsonEncode(response);
          savechildSummery(json);

          debugPrint('response from GetDailyhomeworkParent api is - $json');
          debugPrint(
              'Culmination id from deep link is - ${widget.culminationId}');
          if (widget.culminationId != null) {
            mHomeworkList.clear();
            for (int i = 0; i < response.homeworkList.length; i++) {
              if (response.homeworkList[i].CName == widget.culminationId) {
                mHomeworkList.add(response.homeworkList[i]);
              }
            }
          } else if (widget.homeworkId != null &&
              widget.homeworkId!.isNotEmpty) {
            mHomeworkList.clear();
            for (int i = 0; i < response.homeworkList.length; i++) {
              if (response.homeworkList[i].HomeworkID == widget.homeworkId) {
                mHomeworkList.add(response.homeworkList[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPdfApp(
                      worksheetUrl: response.homeworkList[i].solution,
                      title: response.homeworkList[i].Worksheet,
                      filename: '${response.homeworkList[i].Worksheet}.pdf',
                      module: 'phomework',
                      isDownload: false,
                      model: response.homeworkList[i],
                      imageUploadFunction: () {
                        if (userType != 'P' &&
                            response.homeworkList[i].UploadUrl.isNotEmpty) {
                          showImagePicker(3);
                        } else if (userType != 'P' &&
                            response.homeworkList[i].UploadUrl.isEmpty) {
                        } else {
                          showImageOption(response.homeworkList[i]);
                        }
                      },
                    ),
                  ),
                );
              }
            }
          } else {
            mHomeworkList.clear();
            mHomeworkList.addAll(response.homeworkList);
          }
          mHomeworkList.sort((a, b) => a.AssignedDate.toLowerCase()
              .compareTo(b.AssignedDate.toString().toLowerCase()));

          mHomeworkList = mHomeworkList.reversed.toList();
          setState(() {});
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  saveModel(MyHomeworkModel model) {
    mHomeWork = model;
  }

  Future<void> showImageOption(MyHomeworkModel model) async {
    saveModel(model);
    List<String> options = kIsWeb ? ['Gallery'] : ['Gallery', 'Camera'];
    if (userType != 'P') {
      options = [];
    }
    if (model.UploadUrl.isNotEmpty) {
      options.add('View Image');
    }
    isUpload = true;
    if (options.length == 1) {
      await showImagePicker(0);
      return;
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
                      debugPrint(model.UploadUrl);
                      if (userType != 'P' && model.UploadUrl.isNotEmpty) {
                        showImagePicker(3);
                      } else if (userType != 'P' && model.UploadUrl.isEmpty) {
                      } else {
                        Navigator.pop(context, options[index]);
                        if (options[index] == 'Gallery') {
                          showImagePicker(0);
                        } else if (options[index] == 'Camera') {
                          showImagePicker(1);
                        } else {
                          showImagePicker(3);
                        }
                      }
                    },
                  );
                },
              ),
            ),
          );
        });
  }
//   updateImage(String path){
//     debugPrint('update Image');
//     mHomeWork.UploadUrl=path;
//     for(int index=0;index<mHomeworkList.length;index++){
//       if(mHomeworkList[index].HomeworkID==mHomeWork.HomeworkID){
//         mHomeworkList[index].UploadUrl = path;
//       }
//     }
// setState(() {

  updateImage(String path) {
    debugPrint('update Image');
    mHomeWork.UploadUrl = path;
    for (int index = 0; index < mHomeworkList.length; index++) {
      if (mHomeworkList[index].HomeworkID == mHomeWork.HomeworkID) {
        mHomeworkList[index].UploadUrl = path;
      }
    }

    savechildSummery(jsonEncode(
        MyHomeworkResponse(success: 1, homeworkList: mHomeworkList).toJson()));
    setState(() {});
  }

  showImagePicker(int action) async {
    if (action != 3) {
      XFile? photo;
      if (action == 0) {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        photo = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 72);
      }
      if (photo == null) {
        setState(() {
          isUpload = false;
        });
        return;
      }

      if (await Utility.isInternet()) {
        isUpload = true;

        Utility.showLoaderDialog(context);
        APIService().uploadImage(uid, photo, listener: this);
      } else if (!kIsWeb) {
        isUpload = true;
        // debugPrint("----------------------${photo!.path}");
        UploadHomwworkData data = UploadHomwworkData(
            UploadUrl: photo.path,
            StudentID: studentId.toString(),
            PStatusCode: 'C',
            Remarks: '');
        List<UploadHomwworkData> inputData = [data];
        UpdateHomeWorkRequest request = UpdateHomeWorkRequest(
            HomeworkID: mHomeWork.HomeworkID,
            TransType: 'P',
            UserID: uid,
            ProgramID: programId.toString(),
            InputDate: Utility.getDate(),
            InputData: inputData,
            TeacherID: '');

        DBHelper dbHelper = DBHelper();
        dbHelper.insertSyncData(
            request.toJson(),
            LocalConstant.ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD,
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
        BlocProvider.of<PdfHomeworkUploadCubit>(context).updateHomework(
            photo.path,
            mHomeWork.Worksheet,
            'phomework',
            mHomeWork.solution,
            mHomeWork);
        updateImage(photo.path);
      } else {
        isUpload = true;
        Utility.showLoaderDialog(context);
        APIService().uploadImage(uid, photo, listener: this);
      }
    } else {
      debugPrint('in else');
      var result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageViewer(imageUrl: mHomeWork.UploadUrl);
      })); //Navigate to another page
      debugPrint('response from imageviewer');
    }
  }

  List<MyHomeworkModel> dayModel = [];
  getUniqueDays() {
    dayModel.clear();
    Map<String, MyHomeworkModel> homeworkMap = {};
    for (int index = 0; index < mHomeworkList.length; index++) {
      if (!homeworkMap.containsKey(mHomeworkList[index].CName)) {
        dayModel.add(mHomeworkList[index]);
      } else {
        if (mHomeworkList[index].UploadUrl.isEmpty)
          for (int jIndex = 0; jIndex < dayModel.length; jIndex++) {
            if (mHomeworkList[index].CName == dayModel[jIndex].CName) {
              debugPrint(
                  'Uplaoded model is Blanks ${dayModel[jIndex].Worksheet}');
              dayModel[jIndex].UploadUrl = '';
            }
          }
      }
      homeworkMap.putIfAbsent(
          mHomeworkList[index].CName, () => mHomeworkList[index]);
    }
    selectedDate = dayModel[0];
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Parent:Homework');
    ScreenUtil.init(context);
    return Scaffold(
        appBar: !isNewUi
            ? null
            : mHomeworkList.isEmpty
                ? null
                : CalendarAppBar(
                    onDateChanged: (value) {
                      setState(() {
                        selectedDate = value;
                        getTodaysHomework();
                        debugPrint('Selected Value ${selectedDate?.CName}');
                      });
                    },
                    firstDate: dayModel[0],
                    lastDate: dayModel[dayModel.length - 1],
                    events: dayModel),
        /* appBar: widget.isToolbar
            ? AppBar(
                title: const Text(''),
              )
            : null,*/
        backgroundColor: Colors.white,
        body: SafeArea(
          child: isPDF
              ? viewPDF()
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: kPrimaryLightColor,
                  strokeWidth: 4.0,
                  onRefresh: () async {
                    // Replace this delay with the code to be executed during refresh
                    // and return a Future when code finishs execution.
                    getHomework();
                    return Future<void>.delayed(const Duration(seconds: 3));
                  },
                  // Pull from top to show refresh indicator.
                  child: Container(
                    color: LightColors.kLightGrayM,
                    child: getChildList(),
                  ),
                ),
        ));
  }

  Widget getHomeWorkInfo(MyHomeworkModel model, int index) {
    final bool isLocalFile = model.UploadUrl.isNotEmpty &&
        (model.UploadUrl.toLowerCase().contains('data/') ||
            model.UploadUrl.toLowerCase().contains('applica'));

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEADING IMAGE
                GestureDetector(
                  onTap: () {
                    if (userType != 'P' && model.UploadUrl.isNotEmpty) {
                      showImagePicker(3);
                    } else {
                      showImageOption(model);
                    }
                  },
                  child: Hero(
                    tag: "hw_${model.Worksheet}_$index",
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xffFCE4EC),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: isLocalFile
                          ? Image.file(
                              File(model.UploadUrl),
                              fit: BoxFit.cover,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/icons/ic_upload.png',
                              image: model.UploadUrl,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Image.asset(
                                    'assets/icons/ic_error_image.png',
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// CENTER CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.Worksheet,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff131621),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _infoTile(
                        Icons.menu_book_rounded,
                        "Culmination",
                        model.CName,
                      ),
                      const SizedBox(height: 6),
                      _infoTile(
                        Icons.calendar_today_rounded,
                        "Assigned",
                        Utility.parseDate(model.AssignedDate),
                      ),
                      if (model.StatusCode.toString().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_emotions_rounded,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Remark",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              "assets/icons/pentemind/Smile${model.StatusCode.toString().replaceAll('S', '')}.png",
                              height: 22,
                              width: 22,
                            ),
                          ],
                        ),
                      ],
                      if (model.Remarks.toString().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.feedback_outlined,
                                size: 18,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  model.Remarks.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),

                /// TRAILING PDF BUTTON
                if (model.solution.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => goToMyPdf(
                            worksheetUrl: model.solution,
                            title: model.Worksheet,
                            filename: '${model.Worksheet}.pdf',
                            module: 'phomework',
                            isDownload: false,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 52,
                      height: 52,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffFF9800),
                            Color(0xffFF5722),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// REUSABLE INFO TILE
  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.blueGrey,
        ),
        const SizedBox(width: 6),
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  getHomeWorkInfo123(MyHomeworkModel model) {
    if (model.Worksheet.contains('SR_D32_LT_WSH02')) {
      debugPrint('1234 ${model.Worksheet}  ${model.UploadUrl}');
    }
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
              if (userType != 'P' && model.UploadUrl.isNotEmpty) {
                showImagePicker(3);
              } else if (userType != 'P' && model.UploadUrl.isEmpty) {
              } else {
                showImageOption(model);
              }
            },
            child: Container(
              width: ScreenUtil().setWidth(37.0),
              height: ScreenUtil().setHeight(37.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(221, 40, 81, 0.18),
              ),
              child: model.UploadUrl.isNotEmpty &&
                      model.UploadUrl.trim() != '' &&
                      (model.UploadUrl.toLowerCase().contains('data/') ||
                          model.UploadUrl.toLowerCase().contains('applica'))
                  ? SizedBox(
                      width: 37,
                      height: 37,
                      child: CircleAvatar(
                        backgroundImage: FileImage(
                          File(model.UploadUrl),
                        ),
                        radius: 200.0,
                      ))
                  : FadeInImage(
                      key: ValueKey(model.UploadUrl),
                      width: 20,
                      height: 20,
                      placeholder:
                          const AssetImage('assets/icons/ic_upload.png'),
                      image: NetworkImage(model.UploadUrl),
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
                  model.Worksheet,
                  style: const TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                MyWidget.textRow("Culmination", model.CName),
                const SizedBox(
                  height: 5.0,
                ),
                MyWidget.textRow(
                    "AssignedDate", Utility.parseDate(model.AssignedDate)),
                const SizedBox(
                  height: 5.0,
                ),
                model.StatusCode.toString().isNotEmpty
                    ? MyWidget.textWidget(
                        "Remark",
                        Image.asset(
                          "assets/icons/pentemind/Smile${model.StatusCode.toString().replaceAll('S', '')}.png",
                          height: 20,
                          width: 20,
                        ))
                    : const Text(''),
                const SizedBox(
                  height: 5.0,
                ),
                MyWidget.textRow("Feedback", model.Remarks.toString())
              ],
            ),
          ),
          model.solution.isEmpty
              ? const Text('')
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => goToMyPdf(
                          worksheetUrl: model.solution,
                          title: model.Worksheet,
                          filename: '${model.Worksheet}.pdf',
                          module: 'phomework',
                          isDownload: false,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(37.0),
                    height: ScreenUtil().setHeight(37.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 99, 2, 0.15),
                    ),
                    child: Image.asset('assets/images/ic_pdf.png'),
                  ),
                )
        ],
      ),
    );
  }

  Widget getHomeworkView123(MyHomeworkModel model) {
    return Card(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(1),
              //width: MediaQuery.of(context).size.width * 0.5,
              //decoration: BoxDecoration(color: Colors.greenAccent),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          model.Worksheet.replaceAll('.pdf', ''),
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            color: Colors.black87,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          "Date : ${Utility.parseShortDate(model.AssignedDate)}",
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: Colors.black87,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      saveModel(model);
                      await checkFile();
                      setState(() {
                        isPDF = true;
                      });
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/ic_solvedworksheet.png',
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Solution",
                                style: GoogleFonts.roboto(
                                  fontSize: 8.0,
                                  color: Colors.black87,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      if (userType != 'P' && model.UploadUrl.isNotEmpty) {
                        showImagePicker(3);
                      } else if (userType != 'P' && model.UploadUrl.isEmpty) {
                      } else {
                        showImageOption(model);
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.23,
                      child: Card(
                        color: Colors.white,
                        child: model.UploadUrl.isEmpty
                            ? Center(
                                child: Text(
                                  "Upload HW",
                                  style: GoogleFonts.roboto(
                                    background: Paint()
                                      ..color = LightColors.kDarkBlue
                                      ..strokeWidth = 18
                                      ..strokeJoin = StrokeJoin.round
                                      ..strokeCap = StrokeCap.round
                                      ..style = PaintingStyle.stroke,
                                    fontSize: 7.0,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  FadeInImage(
                                    key: ValueKey(model.UploadUrl),
                                    width: 18,
                                    height: 18,
                                    placeholder: const AssetImage(
                                        'assets/icons/ic_hw_upload.png'),
                                    image: NetworkImage(model.UploadUrl),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/icons/ic_hw_upload.png',
                                          fit: BoxFit.fitWidth);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Homework",
                                    style: GoogleFonts.roboto(
                                      fontSize: 8.0,
                                      color: Colors.black87,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderTodaysHomework(MyHomeworkModel model, int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: Colors.blueAccent,
        elevation: 5,
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: model.UploadUrl.isEmpty
                            ? LightColors.kRed
                            : LightColors.kLightGreen,
                        width: 10)),
                color: Colors.white60,
              ),
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                      title: MyWidget().richText(
                          model.Worksheet, LightColors.textHeaderStyle16),
                      subtitle: MyWidget()
                          .richText(model.CName, LightColors.textHeaderStyle13),
                      leading: CircleAvatar(
                        backgroundColor: LightColors.kHeaderColor,
                        child: FadeInImage(
                          key: ValueKey(model.UploadUrl),
                          width: 25,
                          height: 25,
                          placeholder:
                              const AssetImage('assets/icons/ic_upload.png'),
                          image: NetworkImage(model.UploadUrl),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                'assets/icons/ic_error_image.png',
                                fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.cover,
                        ),
                      )),
                  /*Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 45,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon( // <-- Icon
                              Icons.picture_as_pdf,
                              size: 16.0,
                            ),
                            label: Text('Solution'), // <-- Text
                          ),
                        ),
                      ],
                    ),
                  )*/
                ],
              )),
        ),
      ),
    );
  }

  Widget getHomeworkGrid(MyHomeworkModel model, int index) {
    return Card(
      color: index % 2 == 0 ? LightColors.kAbsent : Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(1),
              //width: MediaQuery.of(context).size.width * 0.5,
              //decoration: BoxDecoration(color: Colors.greenAccent),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          model.Worksheet.replaceAll('.pdf', ''),
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            color: Colors.black87,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          "Date : ${Utility.parseShortDate(model.AssignedDate)}",
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: Colors.black87,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      saveModel(model);
                      await checkFile();
                      setState(() {
                        isPDF = true;
                      });
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: Card(
                          color: index % 2 == 0
                              ? LightColors.kAbsent
                              : Colors.white,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/ic_solvedworksheet.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Solution",
                                style: GoogleFonts.roboto(
                                  fontSize: 8.0,
                                  color: Colors.black87,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      if (userType != 'P' && model.UploadUrl.isNotEmpty) {
                        showImagePicker(3);
                      } else if (userType != 'P' && model.UploadUrl.isEmpty) {
                      } else {
                        showImageOption(model);
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: Card(
                        color:
                            index % 2 == 0 ? LightColors.kAbsent : Colors.white,
                        child: model.UploadUrl.isEmpty
                            ? Center(
                                child: Text(
                                  "Upload HW",
                                  style: GoogleFonts.roboto(
                                    background: Paint()
                                      ..color = LightColors.kDarkBlue
                                      ..strokeWidth = 18
                                      ..strokeJoin = StrokeJoin.round
                                      ..strokeCap = StrokeCap.round
                                      ..style = PaintingStyle.stroke,
                                    fontSize: 7.0,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  FadeInImage(
                                    key: ValueKey(model.UploadUrl),
                                    width: 16,
                                    height: 16,
                                    placeholder: const AssetImage(
                                        'assets/icons/ic_hw_upload.png'),
                                    image: NetworkImage(model.UploadUrl),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/icons/ic_hw_upload.png',
                                          fit: BoxFit.fitWidth);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Homework",
                                    style: GoogleFonts.roboto(
                                      fontSize: 8.0,
                                      color: Colors.black87,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (mHomeworkList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else if (isNewUi) {
      return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 5.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Lets pass the order to a new widget and render it there
          return renderTodaysHomework(mHomeworkList[index], index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 15.0,
          );
        },
        itemCount: mHomeworkList.length,
      );
      /*return  Container(
        */ /*height: MediaQuery
            .of(context)
            .size
            .height,*/ /*
        child: GridView.builder(
            itemCount: mTodaysHomework.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (3 / 2.8),
                crossAxisCount: 1),
            itemBuilder: (BuildContext context, int index) {
              return renderTodaysHomework(mTodaysHomework[index],index);
            }
        ),
      );*/
    } else {
      return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 5.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Lets pass the order to a new widget and render it there
          return getHomeWorkInfo(mHomeworkList[index], index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 15.0,
          );
        },
        itemCount: mHomeworkList.length,
      );
    }
  }

  openPDF(MyHomeworkModel model) {
    checkFile();
  }

  checkFile() async {
    String dir = (await getTemporaryDirectory()).path;
    String path = '$dir/phomework/${mHomeWork.Worksheet}.pdf';
    debugPrint('path s $path');
    if (!await Directory('$dir/phomework').exists()) {
      Directory myNewDir =
          await Directory('$dir/phomework').create(recursive: true);
      debugPrint('directory created');
    }
    debugPrint('path is $path');
    if (await File(path).exists()) {
      mFile = File(path);
      setState(() {
        isLoading = false;
      });
    } else {
      debugPrint('download starting...');
      setState(() {
        isLoading = true;
      });
      Utility.downloadContent(mHomeWork.solution, path).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  File? mFile;
  Widget viewPDF() {
    debugPrint('view file ${mHomeWork.solution}');
    return Scaffold(
      /*appBar:  AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: (){
            if(isPDF){
              setState(() {
                isPDF=false;
              });
            }else
              Navigator.of(context).pop();
          },
        ),
        title: Text(mHomeWork.Worksheet),
      ),*/
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (userType != 'P' && mHomeWork.UploadUrl.isNotEmpty) {
            showImagePicker(3);
          } else if (userType != 'P' && mHomeWork.UploadUrl.isEmpty) {
          } else {
            showImageOption(mHomeWork);
          }
        },
        isExtended: true,
        label: const Text('Upload Homework'),
        icon: mHomeWork.UploadUrl.isNotEmpty
            ? mHomeWork.UploadUrl.isNotEmpty &&
                    mHomeWork.UploadUrl.toLowerCase().contains('data/')
                ? SizedBox(
                    width: 37,
                    height: 37,
                    child: CircleAvatar(
                      backgroundImage: FileImage(
                        File(mHomeWork.UploadUrl),
                      ),
                      radius: 200.0,
                    ))
                : FadeInImage(
                    key: ValueKey(mHomeWork.UploadUrl),
                    width: 24,
                    height: 24,
                    placeholder:
                        const AssetImage('assets/icons/ic_hw_upload.png'),
                    image: NetworkImage(mHomeWork.UploadUrl),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/icons/ic_hw_upload.png',
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.cover,
                  )
            : Image.asset('assets/icons/ic_hw_upload.png'),
      ),
      body: isLoading
          ? Utility.showLoader()
          : mFile != null
              ? PdfViewer.file(mFile!.path)
              : PdfViewer.uri(
                  Uri.parse(mHomeWork.solution),
                ),
    );
  }

  @override
  void onClick(int action, value) {
    debugPrint('onClick $action');
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      if (value is UploadImageResponse) {
        UploadImageResponse response = value;
        if (value.message.contains('Successfully')) {
          //mHomeWork.UploadUrl = value.imageModel![0].location;
          UploadHomwworkData data = UploadHomwworkData(
              UploadUrl: value.imageModel![0].location,
              StudentID: studentId.toString(),
              PStatusCode: 'C',
              Remarks: '');
          List<UploadHomwworkData> inputData = [data];
          UpdateHomeWorkRequest request = UpdateHomeWorkRequest(
              HomeworkID: mHomeWork.HomeworkID,
              TransType: 'P',
              UserID: uid,
              ProgramID: programId.toString(),
              InputDate: Utility.getDate(),
              InputData: inputData,
              TeacherID: '');

          APIService().updateHomework(request, token).then((value) {
            debugPrint(value.toString());
            isLoading = false;
            if (value != null) {
              if (value == null) {
                Utility.showMessage(context, 'Unable to save...');
              } else if (value is GenericResponse) {
                GenericResponse response = value;
                if (response.success == 200) {
                  debugPrint('Image is getting updagted - ${data.UploadUrl}');
                  updateImage(data.UploadUrl);
                  try {
                    Utility.showMessage(
                        context,
                        response.response is String
                            ? response.response
                            : response.response.response.toString());
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
            //getHomework();
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

  void getTodaysHomework() {
    mTodaysHomework.clear();
    mTodaysHomework.addAll(mHomeworkList);
    setState(() {});
  }
}
