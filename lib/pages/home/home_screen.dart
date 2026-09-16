import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:app_version_update/app_version_update.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/api/request/celibration/celibration_request.dart';
import 'package:ekidzee/api/request/parent_request.dart';
import 'package:ekidzee/api/request/pentemind/update_student_profile.dart';
import 'package:ekidzee/firebase/anylatics.dart';
import 'package:ekidzee/firebase_options.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/DBConstant.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/helper/app_assets.dart';
import 'package:ekidzee/helper/deepLinkingConstants.dart';
import 'package:ekidzee/helper/notification.dart';
import 'package:ekidzee/helper/protectus.dart';
import 'package:ekidzee/iface/onResponse.dart';
import 'package:ekidzee/models/user_payload.dart';
import 'package:ekidzee/pages/about/about_screen.dart';
import 'package:ekidzee/pages/bpms/bpms_db.dart';
import 'package:ekidzee/pages/feedback/app_feedback.dart';
import 'package:ekidzee/pages/feedback/firestore/survey_firestore.dart';
import 'package:ekidzee/pages/feedback/survery_hive_model/survey_model.dart';
import 'package:ekidzee/pages/holiday_master_page.dart';
import 'package:ekidzee/pages/home/homeProvider/notificationCountProvider.dart';
import 'package:ekidzee/pages/home/model/StatusModel.dart';
import 'package:ekidzee/pages/home/pentemindhome.dart';
import 'package:ekidzee/pages/k12/presentation/pages/LG/learninggoal.dart';
import 'package:ekidzee/pages/k12/presentation/pages/facilatortool/facilator_tool.dart';
import 'package:ekidzee/pages/k12/presentation/pages/learning_resource/learning_resource.dart';
import 'package:ekidzee/pages/k12/presentation/pages/logbook/logbook_page.dart';
import 'package:ekidzee/pages/k12/presentation/pages/myclass/myclasskes.dart';
import 'package:ekidzee/pages/k12/presentation/pages/myclass/mycogniclass.dart';
import 'package:ekidzee/pages/k12/presentation/pages/reports/learninggoalreport.dart';
import 'package:ekidzee/pages/pentemind/module/almanac/almanac.dart';
import 'package:ekidzee/pages/pentemind/module/class_details/class_details_page.dart';
import 'package:ekidzee/pages/pentemind/module/homework/homework_home.dart';
import 'package:ekidzee/pages/pentemind/module/homework/homework_home_kes.dart';
import 'package:ekidzee/pages/pentemind/module/myclass/announancement.dart';
import 'package:ekidzee/pages/pentemind/module/progress/progress.dart';
import 'package:ekidzee/pages/pentemind/module/summercamp/funactivity.dart';
import 'package:ekidzee/qr/qr_scannerv2.dart';
import 'package:ekidzee/theme/kidzee_light.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/bottomsheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:literaoctave/core/class_format.dart';
import 'package:literaoctave/litera_nova_octave.dart' as octave;
import 'package:literaoctave/litera_nova_octave.dart' hide AppFlavor;
import 'package:literaoctave/model/userinfo.dart';
import 'package:literaoctave/octive_config.dart';
import 'package:literaoctave/presentation/pages/litranova/literianova_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saathi/zllsaathi.dart' hide initFirebase;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/APIService.dart';
import '../../api/ServiceHandler.dart';
import '../../api/request/fantacyboxrequest.dart';
import '../../api/request/pentemind/get_day.dart';
import '../../api/request/pentemind/learningmaterial/learning_material.dart';
import '../../api/response/celibration/zll_celibration_response.dart';
import '../../api/response/pentemind/GenericResponse.dart';
import '../../api/response/pentemind/get_day_response.dart';
import '../../api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import '../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../api/response/pentemind/myclass/day_calender.dart';
import '../../app_routes.dart';
import '../../constants.dart';
import '../../helper/DatabaseHelper.dart';
import '../../helper/utils.dart';
import '../../iface/onClick.dart';
import '../../main.dart';
import '../../model/ActivityPlanerModel.dart';
import '../../model/parent_info.dart';
import '../../model/user_model.dart';
import '../../pushNotification/promoNotificationDialog.dart';
import '../../videoplayer/VideoPlayer.dart';
import '../../widget/MyWebSiteView.dart';
import '../Login/PrivacyPolicyScreen.dart';
import '../k12/presentation/pages/folders/folder_page.dart';
import '../login/change_password_page.dart';
import '../login/ui2/login.dart';
import '../notification/NotificationService.dart';
import '../pentemind/module/Parent/parent_artsy.dart';
import '../pentemind/module/Parent/parent_homework.dart';
import '../pentemind/module/celibrations/celibrations.dart';
import '../pentemind/module/dailyactivity/daily_activity.dart';
import '../pentemind/module/facilatorsays/facilator_says.dart';
import '../pentemind/module/learninggoal.dart';
import '../pentemind/module/learninggoal/childs_advancement.dart';
import '../pentemind/module/learninggoal/developmental/developmental_feedback.dart';
import '../pentemind/module/learningmaterial/learning_material.dart';
import '../pentemind/module/myclass/almanac_menu.dart' as almanac_placeholder;
import '../pentemind/module/myclass/leave_record.dart';
import '../pentemind/module/myclass/my_class.dart';
import '../pentemind/module/myclass/parent_note.dart';
import '../pentemind/module/parentcorner/elg.dart';
import '../pentemind/module/parentcorner/parent_corner.dart';
import '../pentemind/module/reports/reports.dart';
import '../pentemind/module/summercamp/pentemindactivity.dart';
import '../pentemind/module/tracker/tracker.dart';
import '../tracker_indent/TrackerOrderScreen.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  String profileImage = '';
  String? day, status, programId, type;

  MyHomePage(
      {super.key,
      required this.profileImage,
      required this.title,
      this.day,
      this.status,
      this.programId,
      this.type});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver
    implements onClickListener, onResponse {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  TextEditingController classController = TextEditingController();

  List<PentemindItem> pentemindMenus = [];
  String userId = "";
  String uid = "0";

  String userName = '';
  String displayName = '';
  String userType = '';
  String country = '';
  String _pentemindModuleUrl = '';
  var _currentProgramId = 0;
  var _currentClassId = 0;
  var _currentProgramName = '';
  var _curriculamType = '';
  var _curriculamTern = '';
  int ayId = 0;
  int localAcademicYearID = 0;
  var _className = '';
  int businessId = 1;
  ProgramModel? classProgram;
  bool isUrlLoadingCompleted = false;
  String url = "";
  double progress = 0;
  final ImagePicker _picker = ImagePicker();
  static const int MENU_ATTENDANCE = 4;
  static const int MENU_HOLIDAYS = 12;
  static const int MENU_EVENT_HAPPENING = 13;
  static const int MENU_STUDENT_DIARY = 14;
  static const int MENU_INDUCTION = 20;
  static const int MENU_LEARNING_GOAL = 21;
  static const int MENU_LEARNING_GOAL_M = 31;

  static const int MENU_QUICK_CONTACT = 22;
  static const int MENU_NEWS = 23;
  static const int MENU_TIPS = 24;
  static const int MENU_HELPDESK = 25;
  static const int MENU_LEDGER = 26;
  static const int MENU_ARTSY = 27;
  static const int PENTEMIND_LEARNING_GOAL = 28;
  static const int PRIVACY_POLICY = 29;
  static const int CHANGE_PASSWORD = 30;
  static const int MENU_COMMUNICATION = 32;
  static const int MENU_INDENT = 33;
  static const int MENU_CELIBRATION = 34;
  static const int MENU_PARENT_SUPPORT_DESK = 35;
  static const int MENU_TRACKER_INDENT = 36;
  static const int MENU_ZEESARTHI = 37;
  static const int MENU_K12_LG = 38;
  static const int MENU_K12_FACILATOR_TOOL = 39;
  static const int MENU_K12_REPORT_LG = 40;
  static const int MENU_K12_MYCLASS = 41;
  static const int MENU_K12_LOGBOOK = 42;
  static const int MENU_K12_HOMEWORK = 43;
  static const int MENU_K12_LEARNINGRESOURCE = 44;
  static const int MENU_K12_HPCREPORT = 45;
  static const int MENU_K12_ALMANAC = 46;
  static const int MENU_K12_HOMELINK = 47;
  static const int MENU_OCTAVE = 49;

  LoginData? userProfile;
  int _selectedDestination = MENU_LEARNING_GOAL;
  String _moduleTitle = 'Home';
  late String mTitle = "", mClassName = "";
  KidzeePref mKidzeePref = KidzeePref();

  SharedPreferences? sharedPref;

  late List<String> applicableClass = [];
  final InAppReview _inAppReview = InAppReview.instance;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String encoded = '';

  int studentId = 0;
  int francinseeId = 0;
  int currentAcademicYear = 0;

  bool isLoading = false;
  bool isInternet = false;

  AnimationController? animationController;
  List<ActivityPlanerModel> bannerList = ActivityPlanerModel.bannerlList;

  bool isNativePentemind = true;
  dynamic _currentPentemind;

  bool isLogBookCompleted = true;
  bool isAttendanceCompleted = true;

  AppUpdateInfo? _updateInfo;

  int? attendanceLogbookProgramId;
  int? currentProgramId;

  Box? logbookattendanceStatusBox;

  bool isInitialSnapshot = true;

  bool isFeedbackEnabled = false;
  String activeSurveyId = '';
  bool isFeedbackApiCalled = false;

  Future<List<ConnectivityResult>> _updateConnectionStatus(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      isInternet = true;
      initializeService();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      initializeService();
      isInternet = true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      isInternet = true;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      isInternet = true;
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // debugPrint('// I am connected to a bluetooth.');
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      //debugPrint('// I am connected to a network which is not in the above mentioned networks.');
      isInternet = true;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      //debugPrint('// I am not connected to any network.');
      isInternet = false;
    }
    if (isInternet && !kIsWeb) {
      DBHelper helper = DBHelper();
      List<Map<String, dynamic>> unSyncList = await helper.getUnSyncData(
        userId.toString(),
      );
      if ((unSyncList.isNotEmpty)) {
        await initializeService();
        final flutterService = FlutterBackgroundService();
        Future.delayed(const Duration(seconds: 4), () async {
          if (!await flutterService.isRunning()) {
            if (await flutterService.startService()) {
              flutterService.invoke('syncPendingData');
            }
          } else {
            flutterService.invoke('syncPendingData');
          }
        });
      }
    }
    if (isInternet) {
      if (!isFeedbackApiCalled) {
        checkFeedback();
      }
      notificationSettingCheck();
    }
    if (mounted) {
      setState(() {});
    }
    return connectivityResult;
  }

  /* Deep link and custom url scheme setting variables */
  StreamSubscription? _streamSubscription;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  List<NotificationPermission> channelPermissions = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Light,
    NotificationPermission.Vibration,
    NotificationPermission.CriticalAlert,
    NotificationPermission.FullScreenIntent,
  ];

  void refreshScheduleChannelPermissions() {
    AwesomeNotifications()
        .checkPermissionList(
          channelKey: 'scheduled',
          permissions: channelPermissions,
        )
        .then(
          (List<NotificationPermission> permissionsAllowed) => debugPrint(
            'Permission for schedule notification is - true and permission is - $permissionsAllowed',
          ),
        );
  }

  @override
  void initState() {
    if (kIsWeb) {
      isInternet = true;
    }
    classController.text = 'Select Class';
    ProtectMyScreen().proectScreen(context);
    WidgetsBinding.instance.addObserver(this);
    isFeedbackApiCalled = false;
    logbookattendanceStatusBox = Hive.box(LocalConstant.logbookStatus);

    mKidzeePref.init();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    super.initState();
    // Timer(const Duration(milliseconds: 5000), () {
    //   ZllResourceResponse resource = ZllResourceResponse(data: [
    //     CelibrationModel(
    //         eventId: 100,
    //         title: 'Teachers Celibration',
    //         validfrom: '2023-01-01',
    //         validto: '2027-12-31',
    //         contenturl:
    //             'https://kidzee.com/<userid>/<displayname>/<username>/<uid>',
    //         viewurl:
    //             'https://kidzee.com/<userid>/<displayname>/<username>/<uid>',
    //         displayIn: 'main')
    //   ], success: 200);
    //   onSuccess(resource);
    // });

    initUserData();
    OctiveConfig().initTheme(ChristmasTheme.octaveTheme);
    _incomingLinkHandler();
  }

  void updateInternetStatus() {
    try {
      Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) {
        try {
          _updateConnectionStatus(result);
        } catch (e) {}
      });
    } catch (e) {}
  }

  Future<void> initFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        name: 'kidzee',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  Future<void> initUserData() async {
    // await initFirebase();
    await loadData();
    currentAcademicYear = await KidzeePref().getAcademicYear();
    if (userName.isEmpty) {
      loginsilently();
    } else {
      currentAcademicYear = await KidzeePref().getAcademicYear();
      initAppConfig();
      if (!kIsWeb) {
        refreshScheduleChannelPermissions();
        FlutterDownloader.registerCallback(downloadCallback);
      } else {
        isInternet = true;
        getToken();
      }
      isInternet = true;
      updateInternetStatus();
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print('A new onMessageOpenedApp event was published!');
        Map<String, String> data = {};

        if (message.notification != null && message.data == null) {
          debugPrint('its simple Notification home 376');
        } else {
          debugPrint('its data Notification 316');
          final resolvedUrl = await Utility.resolveUserPlaceholdersFromSession(
            (message.data['url'] ?? '').toString(),
          );
          final resolvedActionUrl =
              await Utility.resolveUserPlaceholdersFromSession(
            (message.data['actionUrl'] ?? message.data['url'] ?? '').toString(),
          );

          if (kIsWeb) {
            Get.snackbar(
              message.data['title'], // Title
              message.data['body'], // Message
              snackPosition: SnackPosition.BOTTOM, // Position
              backgroundColor: kPrimaryColor,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          } else if (message.data['type'] == 'rateUs') {
            rateUs();
          } else if (resolvedUrl.isNotEmpty &&
              resolvedUrl.contains('kidzeeapp')) {
            deepLinkCommonFunction(Uri.tryParse(resolvedUrl));
          } else if (message.data.containsKey('type') &&
              message.data['type'] == 'td') {
            debugPrint('its zllSaathiNotification Notification 410');
            zllSaathiNotification(message);
          } else if (message.data.containsKey('topic') &&
              message.data['topic'] != '') {
            identifyNotification(message);
          } else if (resolvedUrl.isNotEmpty) {
            await openCelebrationWebsite(
              context,
              title: (message.data['title'] ?? '').toString(),
              url: resolvedUrl,
            );
          } else if (resolvedActionUrl.isNotEmpty &&
              message.data['type'] == 'promo') {
            PromoNotification.displayPromoNotification(
              message.data['title'],
              message.data['body'],
              message.data['bigimage'],
              resolvedActionUrl,
            );
          } else {
            NotificationService notificationService = NotificationService();
            notificationService.showSimpleNotification(
              message.data['title'],
              message.data['body'],
              message,
            );
          }
        }
      });

      notificationSettingCheck();
      if (!kIsWeb) checkForInitialMessage();

      loadAppEvents();
    }
  }

  void loadAppEvents() {
    Future.delayed(const Duration(milliseconds: 500), () {
      getCelibrationEvent();
    });
  }

  Future<void> feedbackForAll() async {
    // bool isInternet = await Utility.isInternet();

    debugPrint('No Internet for feedback - $isInternet');
    if (!isInternet) {
      return;
    }
    isFeedbackApiCalled = true;
    await SurveyFirestore.getFireStore();
    SurveyFirestore.fireStore!.collection('survey').snapshots().listen((event) {
      if (isInitialSnapshot) {
        Get.log('Initial Snapshot - ${event.docs.length}');
        getCurrentSurveyForUser(event);
        isInitialSnapshot = false;
        return;
      }

      if (event.docChanges.any(
        (element) =>
            element.type == DocumentChangeType.added ||
            element.type == DocumentChangeType.modified,
      )) {
        getCurrentSurveyForUser(event);
      }
    });
  }

  void getCurrentSurveyForUser(QuerySnapshot<Map<String, dynamic>> event) {
    if (event.docs.isNotEmpty) {
      var masterSurvey = event.docs[0].data()['master_survey'];
      Get.log('goToFeedbackScreen open - $masterSurvey');
      if (masterSurvey != null && masterSurvey is List<dynamic>) {
        for (var element in masterSurvey) {
          if (element['role_type']?.toString().toLowerCase() ==
              userType.toLowerCase()) {
            Get.log('goToFeedbackScreen open - ${element['active_survey_id']}');
            goToFeedbackScreen(element['active_survey_id']);
            // return;
          }
        }
      }
    }
  }

  Future<void> loginsilently() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String userName = pref.getString(LocalConstant.KEY_USER_NAME) as String;
    String userPassword =
        pref.getString(LocalConstant.KEY_USER_PASSWORD) as String;
    Map<String, String> param = {};
    if (userName.isNotEmpty) param.putIfAbsent('username', () => userName);
    if (userPassword.isNotEmpty)
      param.putIfAbsent('password', () => userPassword);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreenV2()),
    );
  }

  Future<void> getLogbookStatus() async {
    sharedPref = await SharedPreferences.getInstance();

    var localAttendanceStatus =
        sharedPref!.getBool(LocalConstant.ATTENDANCE_STATUS) ?? false;
    var attendanceDate = sharedPref!.getString(LocalConstant.ATTENDANCE_DATE);
    var logBookDate = sharedPref!.getString(LocalConstant.LOGBOOK_DATE);

    attendanceLogbookProgramId = sharedPref!.getInt(
      LocalConstant.ATTENDANCE_LOGBOOK_PROGRAMID,
    );
    currentProgramId = sharedPref!.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID);

    if (attendanceLogbookProgramId == null ||
        attendanceLogbookProgramId == currentProgramId) {
      if (attendanceDate == null ||
          (DateTime.now().isAfter(DateTime.parse(attendanceDate)) &&
              DateTime.now().difference(DateTime.parse(attendanceDate)) ==
                  const Duration(days: 1))) {
        isAttendanceCompleted = false;
      } else {
        isAttendanceCompleted = true;
      }
      var localLogbookStatus =
          sharedPref!.getBool(LocalConstant.LOGBOOK_STATUS) ?? false;
      if (logBookDate == null ||
          (DateTime.now().isAfter(DateTime.parse(logBookDate)) &&
              DateTime.now().difference(DateTime.parse(logBookDate)) ==
                  const Duration(days: 1))) {
        isLogBookCompleted = false;
      } else {
        isLogBookCompleted = true;
      }
    } else {
      isLogBookCompleted = false;
      isAttendanceCompleted = false;
      sharedPref!.setInt(
        LocalConstant.ATTENDANCE_LOGBOOK_PROGRAMID,
        currentProgramId!,
      );
    }
  }

  String getObservationType() {
    return 'DAILY';
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      final appLinks = AppLinks();
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = appLinks.uriLinkStream.listen(
        (Uri? uri) async {
          if (!mounted) {
            return;
          }
          debugPrint('Received URI: $uri');

          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // String uid = prefs.getString(LocalConstant.KEY_UID) as String;
          deepLinkCommonFunction(uri);
        },
        onError: (Object err) {
          if (!mounted) {
            return;
          }
          debugPrint('Error occurred: $err');
        },
      );
    }
  }

  Future<void> initAppConfig() async {
    await getLastSelection();
    checkUpdate();
    setState(() {});
  }

  void clearall() {
    try {
      Lottie.cache.clear();
      animationController!.clearListeners();
      pentemindMenus.clear();
    } catch (e) {}
  }

  @override
  void dispose() {
    ProtectMyScreen().removeProtection();
    if (_streamSubscription != null) _streamSubscription?.cancel();
    // _connectivitySubscription.cancel();
    if (!kIsWeb)
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    clearall();
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      'downloader_send_port',
    );
    send!.send([id, status, progress]);
  }

  void getCelibrationEvent() {
    debugPrint('calling get Celibration ---------------');
    ApiServiceHandler().getCelibration(
      CelibrationRequest(display: 'main'),
      this,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('in home Status ${state.name}');
    if (state == AppLifecycleState.resumed && _moduleTitle == 'HOME') {
      /*if(mEventModel!=null)
        KidzeeBottomSheet().showBSPromo(context, mEventModel!.data[0], this);*/
      notificationSettingCheck();
      if (!kDebugMode) {
        checkUpdate();
      }
    }
  }

  //update class selection if only one class set show alert for multiple
  void checkClassSelection() {
    if (_currentProgramId <= 0) {
      if (userProfile != null && userProfile!.program!.length == 1) {
        // Auto-select the only available class without showing dialog
        updateClass(userProfile!.program![0]);
      } else {
        // Show dialog only when user needs to choose between multiple classes
        showClassDialog();
      }
    }
    // Don't show dialog if a class is already selected (_currentProgramId > 0)
  }

  Future<void> checkUpdate() async {
    if (kIsWeb) {
    } else if (!kIsWeb && Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        _updateInfo = info;
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate().catchError(
            (e) => showSnack(e.toString()),
          );
        }
      }).catchError((e) {
        //showSnack(e.toString());
      });
    } else if (Platform.isIOS) {
      _verifyVersion();
    }
  }

  void _verifyVersion() async {
    await AppVersionUpdate.checkForUpdates(
      appleId: '1338356944',
      playStoreId:
          appFlavor == 'mlzs' ? 'com.zeelearn.mlzs' : 'com.zeelearn.kidzee',
    ).then((result) async {
      debugPrint('IOs update available - ${result.canUpdate}');
      if (result.canUpdate!) {
        await AppVersionUpdate.showBottomSheetUpdate(
          context: context,
          appVersionResult: result,
          mandatory: true,
          title: 'App Update Avaliable',
          content: const Text(
            'New version of our Kidzee application is now available, and we highly recommend that you install it to benefit from its enhanced features and improved security.',
          ),
        );
      }
    });
    // TODO: implement initState
  }

  /* @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
//     debugPrint('Message sent via notification input: ========== ');
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      debugPrint(
        'Message sent via notification input: "${receivedAction.buttonKeyInput}"',
      );
      //await executeLongTaskInBackground();
    } else {
      /*MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notification-page',
              (route) =>
          (route.settings.name != '/notification-page') || route.isFirst,
          arguments: receivedAction);*/
    }
  } */

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(
        _scaffoldKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> notificationSettingCheck() async {
    debugPrint('notificationSettingCheck called');
    if (kIsWeb)
      await Firebase.initializeApp(
        name: "kidzee",
        options: DefaultFirebaseOptions.currentPlatform,
      );
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString(LocalConstant.KEY_UID) ?? "0";
      userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
      String fcmToken = (await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BHGE6JChODel_ADUDWd0zGTFL2uwQEZU7i_hdnwYSFa8rbpLpqEL8Ana0gx4DVPtBXeKDsRfQUXlqz5oNcnzvy4'))!;
      print('FCM Token is - $fcmToken');
      FirebaseAnalyticsUtils().setUserType(userType);
      if (fcmToken.isNotEmpty) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        appVersion = packageInfo.version;
        String model = '';
        String source = 'Android';
        String id = '';
        String useragent = '';
        if (kIsWeb) {
          WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
          model = webInfo.userAgent ?? 'Web';
          id = webInfo.vendor ?? 'Web'; // unique ID on Web
          useragent = 'Web_${webInfo.userAgent}_$appVersion';
          source = 'Web';
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          model = androidInfo.model;
          id = androidInfo.id; // unique ID on Android
          useragent = 'Android_${androidInfo.brand}_${androidInfo.model}';
          source = 'Android';
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          useragent = 'IOS_${iosInfo.model}_$appVersion';
          id = iosInfo.identifierForVendor as String;
          source = 'IOS';
        }
        FCM.updateFCM(
          fcmToken,
          uid.toString(),
          userType,
          int.parse(packageInfo.buildNumber),
          model,
          'intranet',
          source,
          useragent,
          this,
        );
        FCM().setNotifications(
          uid.toString(),
          userType,
          int.parse(packageInfo.buildNumber),
          model,
          useragent,
          'intranet',
          source,
          this,
        );
      }
    } catch (e) {
      debugPrint('Error while fetching FCM token: $e');
    }
  }

  HolidayMasterPage onHolidyClick() {
    UserPayload demoPayload = UserPayload(
      usertype: userType,
      userid: userId,
      academicyear: currentAcademicYear,
      frid: francinseeId,
    );
    return HolidayMasterPage(
      payload: demoPayload,
    );
  }

  Future<void> initTopic() async {
    try {
      // if (!kIsWeb) {
//       debugPrint('Subscribe the topic for $userType');
      await FCM.init();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      //is24 = await BpmsDB.getACYear();
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Subscribe to Firebase topic
      final topic = "0_0_${userType}_0";
      if (kIsWeb) {
        APIService.subscribeToTopicForWeb(token, topic);
      } else {
        messaging.subscribeToTopic(topic);
      }

      if (kIsWeb) {
        APIService.subscribeToTopicForWeb(token, '0_0_0_0');
      } else {
        messaging.subscribeToTopic("0_0_0_0");
      }
      if (userType == 'TEACH' ||
          userType == 'SRTEA' ||
          userType == 'P' ||
          userType == 'F' ||
          userType == 'CM' ||
          userType == 'CC') {
        if (kIsWeb) {
          APIService.subscribeToTopicForWeb(token, 'saathi');
          if (kDebugMode) {
            await APIService.subscribeToTopicForWeb(token, 'zllsaathi');
          }
        } else {
          messaging.subscribeToTopic("saathi");
          if (kDebugMode) messaging.subscribeToTopic("zllsaathi");
        }
//         debugPrint('ZllSaathi Topic has been subscribed');
      }
      //messaging.subscribeToTopic("KIDZEE_DEBUG");
      if (kDebugMode) {
        if (kIsWeb) {
          APIService.subscribeToTopicForWeb(token, 'KIDZEE_DEBUG');
        } else {
          messaging.subscribeToTopic("KIDZEE_DEBUG");
        }
//         debugPrint('Kidzee web Topic has been subscribed');
      } else if (AppFlavor == 'mlzs') {
        if (kIsWeb) {
          APIService.subscribeToTopicForWeb(token, 'mlzs');
        } else {
          messaging.subscribeToTopic("mlzs");
        }
//         debugPrint('mlzs Topic has been subscribed');
      } else {
        if (kIsWeb) {
          APIService.subscribeToTopicForWeb(token, 'KIDZEE_STEG');
        } else {
          messaging.subscribeToTopic("KIDZEE_STEG");
        }
//         debugPrint('Kidzee Topic has been subscribed');
      }
      initNotification(AppFlavor!);
      // }
    } catch (e) {}
  }

  void goToFeedbackScreen(String surveyId) {
    activeSurveyId = surveyId;
    var box = Hive.box<SurveyModel>(LocalConstant.surveyBox);
    List<SurveyModel> surveyList = box.values.toList().cast<SurveyModel>();
    for (var element in surveyList) {
      Get.log(
        'Box offline data is -${element.survey_id} - ${element.survey_json} - ${element.completed} - ${element.userId}',
      );
    }
    final completedList = surveyList
        .where((element) => element.completed && element.userId == userId)
        .toList();
    final hasCompleted = completedList.any(
      (e) => e.survey_id == activeSurveyId,
    );

    if (!hasCompleted) {
//       debugPrint('show Feedback PaGE');
      isFeedbackEnabled = true;
      showFeedbackBottomSheet(context, activeSurveyId);
      // Get.to(() => FeedbackHome(
      //       surveyId: activeSurveyId,
      //       userId: userId,
      //     ));
    } else {
      debugPrint('Survey already comoleted...');
      //showFeedbackBottomSheet(context, activeSurveyId);
    }
  }

  void showFeedbackBottomSheet(BuildContext context, String activeSurveyId) {
    Future.delayed(Duration(milliseconds: 1000), () async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      final result = await showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          useSafeArea: true, // 👈 This is important
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: AppFeedbackScreen(
                  surveyId: activeSurveyId, userId: userId.toString()),
            );
          });
      debugPrint('Feedback result is  - $result');
      // Handle result
      if (result == true) {
        isFeedbackEnabled = false;
        isFeedbackApiCalled = false;
//         debugPrint("✅ Feedback submitted successfully");
        // Call controller or update UI
      } else {
        isFeedbackEnabled = false;
        isFeedbackApiCalled = false;
//         debugPrint("❌ Feedback not submitted or cancelled");
      }
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Initialize preferences
    await mKidzeePref.init();

    // Load saved login model
    userProfile = await mKidzeePref.getLoginResponse();

    if (userProfile == null) {
      debugPrint("⚠ No login data found in SharedPreferences");
      return;
    }

    // Basic details
    userName = userProfile!.userName ?? "";
    country = userProfile!.country ?? "";
    displayName = userProfile!.displayName ?? "";
    userId = userProfile!.userId ?? "0";
    userType = userProfile!.userType ?? "";
    francinseeId = userProfile!.franchiseeId ?? 0;

    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? "";
    ayId = prefs.getInt(LocalConstant.KEY_ACADEMICYEAR) ?? 0;
    localAcademicYearID = await KidzeePref().getAcademicYear();

    businessId = AppFlavor == null
        ? 1
        : AppFlavor == "kidzee"
            ? 1
            : 2;

    // Load Parent Specific
    if (userType == "P") {
      studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) ?? 0;
      displayName =
          prefs.getString(LocalConstant.KEY_STUDENT_NAME) ?? displayName;
    }

    // Load program/class details
    _currentProgramName =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? "";
    _className = prefs.getString(LocalConstant.KEY_CURRENT_CLASS_NAME) ?? "";
    _currentProgramId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    _curriculamType =
        prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) ?? "";
    _curriculamTern = prefs.getString(LocalConstant.KEY_CURRENT_TERM) ?? "";

    // Load Saved login response (entire JSON)

    if (userProfile!.program!.isNotEmpty) {
      debugPrint("📌 Loaded saved login JSON → $userProfile!");

      try {
        // Student setup
        // if (pentemindUserProfile!.data.StudentData.isNotEmpty) {
        //   final s = pentemindUserProfile!.data.StudentData.first;
        //
        //   prefs.setInt(LocalConstant.KEY_STUDENT_ID, s.StudentID);
        //   prefs.setString(LocalConstant.KEY_USER_AVTAR, s.studentprofileURL);
        //   prefs.setString(LocalConstant.KEY_STUDENT_NAME, s.StudentName);
        //
        //   if (s.Franchisee_Id > 0) {
        //     prefs.setString(LocalConstant.KEY_FRANCHISEE_ID,
        //         s.Franchisee_Id.toString());
        //   }
        // } else {
        //   prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
        // }

        // Program Selection
        if (_currentProgramId == 0) {
          checkClassSelection();
        } else {
          final programs = userProfile!.program;

          if (programs!.length == 1) {
            updateClass(programs[0]);
          } else {
            for (var p in programs) {
              if (p.programId == _currentProgramId) {
                updateClass(p);
                break;
              }
            }
          }
        }
      } catch (e) {
        debugPrint("❌ Error loading saved login JSON → $e");
      }
    }

    // Generate menu and user info
    generateFilteredMenu();
    getUserInfo();

    if (userType == "P") getParentInfo();

    setState(() {
      _selectedDestination = _className.contains("MDTR")
          ? MENU_LEARNING_GOAL_M
          : MENU_LEARNING_GOAL;
    });

    // Load avatar
    final avatar = prefs.getString(LocalConstant.KEY_USER_AVTAR);
    if (avatar != null) {
      widget.profileImage = avatar;
    }

    initTopic();
    getMaterials();
  }

  // void getPentemindToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userName = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
  //   String password =
  //       prefs.getString(LocalConstant.KEY_USER_PASSWORD) as String;
  //   LoginRequestModel loginRequestModel = LoginRequestModel(
  //     User_Name: userName,
  //     User_Password: password,
  //     Device_id: '',
  //     Otp: '',
  //   );
  //   //debugPrint(loginRequestModel.toJson());
  //   APIService apiService = APIService();
  //   bool is24 = await BpmsDB.getACYear();
  //   apiService.getPentemindLogin(loginRequestModel, is24).then((value) {
  //     if (value != null) {
  //       PentemindLoginResponse pentemindResponseModel =
  //           value as PentemindLoginResponse;
  //       if (pentemindResponseModel.success == 200) {
  //         if (pentemindResponseModel.token.isNotEmpty) {
  //           prefs.setString(
  //             LocalConstant.KEY_APP_TOKEN,
  //             pentemindResponseModel.token,
  //           );
  //         }
  //       }
  //     }
  //
  //     ////debugPrint('Captured in Listener value is null' );
  //   });
  // }

  Future<void> showClassDialog() {
    if (userProfile == null || userProfile!.program!.isEmpty) {
      setState(() {
        _selectedDestination = MENU_LEARNING_GOAL;
      });
      return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Alert"),
            content: Text('Class not mapped, Please contact with your Center'),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Select Batch"),
            content: SizedBox(
              width: 300.0,
              child: ListView.builder(
                itemCount: userProfile!.program!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      color: _currentProgramId ==
                              userProfile!.program![index].programId
                          ? Colors.white54
                          : Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          updateClass(
                            userProfile!.program![index],
                          );
                          setState(() {
                            _selectedDestination = 0;
                          });
                        },
                        child: ListTile(
                          title: Text(
                            userProfile!.program![index].programName!,
                          ),
                          subtitle: Text(userProfile!.program![index].term!),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  Future<bool> getLastSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//     debugPrint('getting last selection...');
    if (prefs.containsKey(LocalConstant.KEY_CURRENT_PROGRAM_NAME)) {
      _currentProgramName =
          prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
//       debugPrint('getting last _currentProgramName $_currentProgramName');
      _currentProgramId =
          prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
//       debugPrint('getting last _currentProgramId $_currentProgramId');
      _className =
          prefs.getString(LocalConstant.KEY_CURRENT_CLASS_NAME) as String;
//       debugPrint('getting last _className $_className');
      _currentClassId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
//       debugPrint('getting last _currentClassId $_currentClassId');
      _curriculamType = prefs
              .containsKey(LocalConstant.KEY_CURRENT_CURRICULAMTYPE)
          ? prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String
          : '';

      if (_className.contains('MDTR')) {
        _selectedDestination = MENU_LEARNING_GOAL_M;
      } else {
        _selectedDestination = MENU_LEARNING_GOAL;
      }
    }
    ayId = prefs.getInt(LocalConstant.KEY_ACADEMICYEAR) ?? 0;
    debugPrint('Academic year id is - $ayId');
    setState(() {});
    return true;
  }

  Future<void> updateClass(ProgramModel program) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    classController.text = program.className!;
    prefs.setString(
      LocalConstant.KEY_CURRENT_PROGRAM_NAME,
      program.programName!,
    );
    prefs.setInt(LocalConstant.KEY_CURRENT_PROGRAM_ID, program.programId!);
    prefs.setInt(LocalConstant.KEY_CURRENT_CLASS_ID, program.classId!);
    prefs.setString(LocalConstant.KEY_CURRENT_CLASS_NAME, program.className!);
    prefs.setString(LocalConstant.KEY_CURRENT_TERM, program.term!);
    _curriculamTern = program.term!;
    if (program.curriculumType!.isNotEmpty)
      prefs.setString(
        LocalConstant.KEY_CURRENT_CURRICULAMTYPE,
        program.curriculumType!,
      );

    _currentClassId = program.classId!;
    classProgram = program;
    _curriculamType = program.curriculumType!;

    debugPrint(
        'Current year is - $ayId  Local year is $localAcademicYearID - isKES - ${isKES()}');

    LocalConstant.isCognimind = localAcademicYearID >= 26 && isKES();

    _currentProgramName = program.programName!;
    _className = program.className!;
    _currentClassId = program.classId!;
    if (_className.contains('MDTR')) {
      _selectedDestination = MENU_LEARNING_GOAL_M;
    } else {
      _selectedDestination = MENU_LEARNING_GOAL;
    }
    try {
      prefs.setBool(
        LocalConstant.KEY_IS_KES,
        program.curriculumType!.toLowerCase() == 'k12' ||
                program.curriculumType!.toLowerCase() == 'kes'
            ? true
            : false,
      );
    } catch (e) {}
    //();

    Get.log(
        'Logging class selection - $_curriculamTern - ${program.className} - $_curriculamType');
    debugPrint(
        'Logging class selection - $_curriculamTern - ${program.className} - $_curriculamType');

    // Set _currentProgramId BEFORE calling getDay() to avoid showing dialog again
    _currentProgramId = program.programId!;

    getDay();
    generateFilteredMenu();

    setState(() {});

    if (attendanceLogbookProgramId != program.programId) {
      attendanceLogbookProgramId = program.programId;
      isAttendanceCompleted = false;
      isLogBookCompleted = false;
    }

    Get.log(
        'Logging class selection - $_curriculamTern - ${program.className} - $_curriculamType');
    debugPrint(
        'Logging class selection - $_curriculamTern - ${program.className} - $_curriculamType');

    FirebaseAnalyticsUtils().logClassSelection(
        term: _curriculamTern,
        className: program.className!,
        curriculumType: _curriculamType);
  }

  Future<void> getParentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(LocalConstant.KEY_USER_TYPE) == 'P') {
      // 1. Offline First: Load from DB immediately
      await _loadParentInfoFromDB();

      // 2. Fetch from API if online
      if (isInternet) {
        try {
          APIService apiService = APIService();
          ParentRequest request = ParentRequest(parentId: userId.toString());
          final value = await apiService.getParentInfo(request);

          if (value != null && value.data.isNotEmpty) {
            DBHelper helper = DBHelper();
            String cdate =
                DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());

            // Clear old data to maintain sync
            await helper.deleteData(LocalConstant.TABLE_PARENT_INFO);

            for (var parentData in value.data) {
              await helper.insert(LocalConstant.TABLE_PARENT_INFO,
                  _mapParentInfoToMap(parentData, cdate));
            }

            // 3. Update UI with fresh data
            await _loadParentInfoFromDB();
          }
        } catch (e) {
          debugPrint('Error fetching parent info: $e');
        }
      }
    }
  }

  Future<void> _loadParentInfoFromDB() async {
    List<ParentInfo> dbList = await DBHelper().getParentInfoList();
    if (dbList.isNotEmpty) {
      applicableClass.clear();
      List<ProgramModel> mappedPrograms = [];
      for (var info in dbList) {
        applicableClass.add(info.classId.toString());
        mappedPrograms.add(_mapParentInfoToProgram(info));
      }

      setState(() {
        if (userProfile != null) {
          userProfile!.program = mappedPrograms;
        }
      });
    }
  }

  Map<String, Object> _mapParentInfoToMap(ParentInfo info, String date) {
    return {
      DBConstant.FRANCHISEE_ID: info.franchiseeId,
      DBConstant.STUDENT_PROGRAM_ID: info.studentProgramId,
      DBConstant.STUDENT_ID: info.studentID,
      DBConstant.CLASS_ID: info.classId,
      DBConstant.PARENT_ID: info.parentID,
      DBConstant.PARENT_NAME: info.parentName,
      DBConstant.CLASS_NAME: info.className,
      DBConstant.STUDENT_DOB: info.studentDOB,
      DBConstant.IS_PARENT_VERIFY: info.isParentVerified,
      DBConstant.ADDRESS: info.address1,
      DBConstant.ADDRESS_ALT: info.address2,
      DBConstant.PHONE_NUMBER: info.phoneNumber,
      DBConstant.MOBILE_NUMBER: info.mobileNo,
      DBConstant.MAIL_ADDRESS: info.emailId,
      DBConstant.STATE: info.stateName,
      DBConstant.CITY: info.cityName,
      DBConstant.PLACE: info.place,
      DBConstant.STUDENT_NAME: info.studentName,
      DBConstant.STUDENT_GENDER: info.studentGender,
      DBConstant.SCHOOL_NAME: info.schoolName,
      DBConstant.PROGRAM_NAME: info.programName,
      DBConstant.ADMISSION_DATE: info.admissionDate,
      DBConstant.FRANS_TYPE: info.franchiseeType,
      DBConstant.STUDENT_AVTAR: info.studentLargeImage,
      DBConstant.DATE: date,
    };
  }

  ProgramModel _mapParentInfoToProgram(ParentInfo info) {
    return ProgramModel(
      programName: "${info.studentName} (${info.programName})",
      programId: info.studentProgramId,
      className: info.className,
      classId: info.classId,
      term: "", // Parent data might not have term, default to empty
      curriculumType: info.franchiseeType,
    );
  }

  // For handling notification when the app is in terminated state
  Future<void> checkForInitialMessage() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        FirebaseMessaging.instance.getInitialMessage().then((value) async {
          log('Message from initial function is - ${value?.data}');
          if (value == null) return;

          final resolvedUrl = await Utility.resolveUserPlaceholdersFromSession(
            (value.data['url'] ?? '').toString(),
          );
          final resolvedActionUrl =
              await Utility.resolveUserPlaceholdersFromSession(
            (value.data['actionUrl'] ?? value.data['url'] ?? '').toString(),
          );

          if (value.data['type'] != null && value.data['type'] == 'promo') {
            PromoNotification.displayPromoNotification(
              value.data['title'],
              value.data['body'],
              value.data['bigimage'],
              resolvedActionUrl.isNotEmpty ? resolvedActionUrl : resolvedUrl,
            );
          } else if (resolvedUrl.isNotEmpty &&
              resolvedUrl.contains('kidzeeapp')) {
            deepLinkCommonFunction(Uri.tryParse(resolvedUrl));
          } else if (resolvedUrl.isNotEmpty) {
            await openCelebrationWebsite(
              context,
              title: (value.data['title'] ?? '').toString(),
              url: resolvedUrl,
            );
          } else if (value.data['type'] != null &&
              value.data['type'] == 'LogbookStatus') {
            var day = value.data['day'];
            var status = value.data['status'];
            var programId = value.data['programId'];
            !status
                ? onClick(
                    LocalConstant.ACTION_PENTEMIND_MODULE,
                    PentemindItem(
                      3,
                      'Facilitator Tools',
                      LocalConstant.MODULE_FACILATORTOOL,
                      'assets/icons/ic_facilitatortools.png',
                      logbookDay: day,
                      logbookProgramId: programId,
                      hiveIndex: 0,
                    ),
                  )
                : onClick(
                    LocalConstant.ACTION_PENTEMIND_MODULE,
                    PentemindItem(
                      4,
                      'Learning Goals',
                      'learninggoals',
                      'assets/icons/ic_learninggoals.png',
                      logbookDay: day,
                      logbookProgramId: programId,
                      hiveIndex: 0,
                    ),
                  );
          }
        });
      });
    } catch (e) {}
  }

  Future<void> getUserInfo() async {
    await FCM.init();
    final prefs = await SharedPreferences.getInstance();
    String className = ''; //mKidzeePref.getString(LocalConstant.KEY_EMAILID);
    userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    prefs.setBool(
      LocalConstant.KEY_SCHEDULE_NOTIFICATION,
      LocalStrings.isSchedule,
    );
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    // Get.log('App token in home is - $token');
    //debugPrint('userinfo ${userId}');
    setState(() {
      //debugPrint(title);
      if (userType == 'P') {
        studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
        displayName = prefs.getString(LocalConstant.KEY_STUDENT_NAME) as String;
        mTitle = displayName;
      } else {
        mTitle = prefs.getString(LocalConstant.KEY_DISPLAY_NAME) as String;
      }
      mClassName = className;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
//     debugPrint('in the Kidzee Home page build ');
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: kPrimaryLightColor,
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.light,
    //   ),
    // );
    EasyLoading.init();
    ScreenUtil.init(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
//         debugPrint('isFeedbackEnabled  didPop$didPop $result');
        if (!didPop) {
          // Show a message or bottom sheet
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Please complete the mandatory feedback first.'),
          //   ),
          // );

          if (_currentProgramId <= 0) {
//             debugPrint('_currentProgramId is 0');
            checkClassSelection();
          }
          if (isFeedbackEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please complete the mandatory feedback first.'),
              ),
            );
          } else {
//             debugPrint('back button listener $_currentPentemind');
            onBackClickListener();
          }

          //showFeedbackBottomSheet(context, activeSurveyId);
        } else {}
      },
      // onPopInvoked: (didPop) async {
      //   debugPrint('isFeedbackEnabled Back called ${isFeedbackEnabled}');
      //   // if (isFeedbackEnabled) return false;
      //   // onBackClickListener();
      //   // return false;
      // },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: /*_selectedDestination == MENU_LEARNING_GOAL ? null :*/
            getAppbar(),
        drawer: getNavigationalDrawar(),
        bottomNavigationBar: SafeArea(child: footer()),
        body: getScreen(),
      ),
    );
  }

  void onChat() {
    setState(() {
      _pentemindModuleUrl =
          'https://tawk.to/chat/63ecbef5c2f1ac1e20336586/1gpacjsrv';
      _selectedDestination = LocalConstant.ACTION_PENTEMIND_MODULE;
    });
  }

  void getActionBarMenuList() {
    List<Widget> list = [];
    debugPrint('UserType is - $userType');

    if (userType == 'CC' || userType == 'CM') {
      list.add(
        IconButton(
          onPressed: () {
            onClick(LocalConstant.ACTION_OPENCLASSDETAILS, '');
          },
          icon: Icon(Icons.edit_note, size: 20),
        ),
      );
    }
    if (!kIsWeb && _curriculamType != 'K12') {
      list.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDestination = MENU_QUICK_CONTACT;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => goToKidzeeQRScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.qr_code, size: 20),
          ),
        ),
      );
    }
    list.add(
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => goToUserNotification()),
          ).then((value) {
            KidzeePref().setString(
              LocalConstant.KEY_SHOWNOTIFICATION_COUNT,
              'false',
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              const Icon(Icons.notifications, size: 20),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: FutureBuilder(
                    future: DBHelper().getData(
                      LocalConstant.TABLE_NOTIFICATION,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> list =
                            snapshot.data as List<Map<String, dynamic>>;
                        return Text(
                          list.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget getPentemindAppbar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: getActionBarMenuList(),
  //   );
  // }

  AppBar getAppbar() {
//     debugPrint('inAppbar userRole $userRole');
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: kPrimaryLightColor, // Same as app bar
      //   statusBarIconBrightness: Brightness.light,
      //   statusBarBrightness: Brightness.light,
      // ),
      backgroundColor: kPrimaryLightColor,
      centerTitle: false,
      title: userType == 'P'
          ? Text(
              displayName,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                Text(
                  userType == 'P' ? '' : userType,
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
      actions: !Responsive.isMobile(context)
          ? [
              Container(
                height: 40,
                width: _currentProgramName.length * 10,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: LightColors.kLightGray1,
                  border: Border.all(color: kPrimaryLightColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => showClassDialog(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // const Spacer(),
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          _currentProgramName,
                          style: LightColors.subTextStyle
                              .copyWith(color: kPrimaryLightColor),
                        ),
                      ),
                      //const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              userType == 'CC' || userType == 'CM'
                  ? IconButton(
                      onPressed: () {
                        onClick(LocalConstant.ACTION_OPENCLASSDETAILS, '');
                      },
                      icon: Icon(Icons.edit_note, size: 20),
                    )
                  : SizedBox.shrink(),
              // InkWell(
              //   onTap: () {
              //     showClassDialog();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Image.asset('assets/icons/ic_classselection.png'),
              //   ),
              // ),
            ]
          : [
              userType == 'CC' || userType == 'CM'
                  ? IconButton(
                      onPressed: () {
                        onClick(LocalConstant.ACTION_OPENCLASSDETAILS, '');
                      },
                      icon: Icon(Icons.edit_note, size: 20),
                    )
                  : SizedBox.shrink(),
              InkWell(
                onTap: () {
                  showClassDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image.asset('assets/icons/ic_classselection.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  if (kIsWeb) {
                    Utility.showMessage(
                      context,
                      'QR scanning is available on the Android and iOS apps.',
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KidzeeQRScreenV2(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.qr_code, color: Colors.white, size: 20),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => goToUserNotification(),
                    ),
                  ).then((value) {
                    KidzeePref().setString(
                      LocalConstant.KEY_SHOWNOTIFICATION_COUNT,
                      'false',
                    );
                    KidzeePref().setString(
                      LocalConstant.KEY_NOTIFICATION_COUNT,
                      '0',
                    );
                    setState(() {});
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.notifications, size: 20, color: Colors.white),
                      Positioned(
                        top: 2,
                        right: 0,
                        child: Consumer(
                          builder: (context, ref, child) {
                            var count = ref.watch(countProvider);
                            return count == 0
                                ? Text('')
                                : FutureBuilder(
                                    builder: (context, prefSnapshot) {
                                      if (prefSnapshot.hasData) {
                                        return prefSnapshot.data == 'true'
                                            ? Container(
                                                padding: const EdgeInsets.all(
                                                  1,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 12,
                                                  minHeight: 12,
                                                ),
                                                child: Text(
                                                  count.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                /* FutureBuilder(
                                    future: DBHelper().getData(
                                        LocalConstant.TABLE_NOTIFICATION),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Map<String, dynamic>> list = snapshot
                                            .data as List<Map<String, dynamic>>;
                                        return Text(
                                          list.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ), */
                                              )
                                            : const SizedBox.shrink();
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                    future: KidzeePref().getString(
                                      LocalConstant.KEY_SHOWNOTIFICATION_COUNT,
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: Container(
          // height: 30,
          // padding: EdgeInsets.zero,
          color: isInternet ? const Color(0xffe9ebf0) : LightColors.kLightRed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
                label: Text(
                  _moduleTitle,
                  style: LightColors.textHeaderStyle13.copyWith(
                    color: kPrimaryLightColor,
                  ),
                ),
                icon: Icon(
                  Icons.home,
                  color: kPrimaryLightColor,
                  // size: 15,
                ),
                onPressed: () {
                  setState(() {
                    _moduleTitle = 'HOME';
                    _selectedDestination = MENU_LEARNING_GOAL;
                    _currentPentemind = 'HOME';
                  });
                },
              ),
              isInternet
                  ? const SizedBox(width: 0)
                  : SizedBox(
                      height: 32,
                      child: Lottie.asset(
                        'assets/json/animation_nointernet.json',
                        fit: BoxFit.contain,
                      ),
                    ),
              if (Responsive.isMobile(context))
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: InkWell(
                    onTap: () => showClassDialog(),
                    child: Text(
                      _currentProgramName,
                      style: LightColors.smallTextStyle.copyWith(
                        color: kPrimaryLightColor,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void selectDestination(int index) {
    if (index == MENU_HOLIDAYS) {
      _moduleTitle = 'Holidays';
    } else {
      _currentPentemind = 'HOME';
    }
    Navigator.of(context).pop();
    setState(() {
      _selectedDestination = index;
    });
  }

  static const channel = MethodChannel('com.zeelearn.literahub/literaubapp');

  Future<void> openMusePlay() async {
    //debugPrint('in method openMusePlay');
    if (Platform.isAndroid || Platform.isIOS) {
      //debugPrint('in method openMusePlay Android platform');
      if (userProfile != null && userProfile!.program!.isNotEmpty) {
        List<FantacyBoxClasses> classes = [];
        List<Culminations> culminationList = [
          Culminations(culmination: 'culmination 01', status: 1),
          Culminations(culmination: 'culmination 02', status: 0),
          Culminations(culmination: 'culmination 03', status: 0),
          Culminations(culmination: 'culmination 04', status: 0),
          Culminations(culmination: 'culmination 05', status: 0),
        ];
        GetDayResponse? dayModel = await KidzeePref.getDay(context);
        int culmination = dayModel.data.getCulmination();
        if (userName == 'T192335') {
          culmination = 5;
        }
//         debugPrint('Culmination list ${culminationList.length}');
        for (int index = 0; index < culminationList.length; index++) {
          culminationList[index].status = 1;
          // debugPrint(culminationList[index]);
        }
        String className =
            _currentProgramName; //pentemindUserProfile!.data!.program![index].className.replaceAll(" ", "");
        if (className.contains("Play & Learn")) {
          className = 'playnlearn';
        } else if (className.contains("SENIORKG") ||
            className.contains("Senior")) {
          className = 'SENIOR';
        } else if (className.contains("JUNIORKG") ||
            className.contains("Junior KG")) {
          className = 'JUNIOR';
        } else if (className.contains("Play Group") ||
            className.contains("PLAYGROUP")) {
          className = 'PLAYGROUP';
        } else if (className.contains("Nursery")) {
          className = 'NURSERY';
        }

        classes.add(
          FantacyBoxClasses(
            className: className,
            culminations: culminationList,
          ),
        );
        FantacyBoxRequest request = FantacyBoxRequest(
          userType: userType,
          userId: int.parse(userId),
          classes: classes,
        );
//         debugPrint('fantasyBox Data ${Uri.encodeFull(request.toJson())}');
        if (Platform.isIOS) {
          // iOS doesn't allow to get installed apps.
          //applaunchUrl(Uri.parse("literaubapp://?${Uri.encodeFull(request.toJson())}"));
          applaunchUrl(
            Uri.parse(
              "kidzeeFantasyBox://?${Uri.encodeFull(request.toJson())}",
            ),
          );
        } else {
          bool isOpen = await applaunchUrlAndroid(
            Uri.encodeFull(request.toJson()),
          );
          // try {
          //   if (!isOpen) {
          //     final String callToast =
          //     await channel.invokeMethod('showToast', request.toJson());
          //   }
          // } on PlatformException catch (e) {
          //   debugPrint(e);
          // }
        }
        /*var intent = AndroidIntent(
          action: 'action_view',
          //data: Uri.encodeFull(request.toJson()),
          package: 'com.google.android.apps.maps',
          arguments: <String, dynamic>{
            'data': request.toJson(),
            'source': 'android',
          },
        );
        intent.launch();*/
        /*final intent = AndroidIntent(
            action: 'com.zeelearn.ekidzee.muse_view',
            //data: Uri.encodeFull(request.toJson()),
            arguments: <String, dynamic>{
              'data': request.toJson(),
              'source': 'android',
            },
            package: 'com.zeelearn.intranet');
        intent.launch();
//         debugPrint('in method openMusePlay invoke ');
        debugPrint(request.toJson());*/
      } else {
//         debugPrint('in method openMusePlay in else');
        Utility.showMessage(
          context,
          'Please install the Kidzee Fantasy Box and continue',
        );
      }
    }
  }

  Future<void> applaunchUrl(url) async {
//     debugPrint('url status');
    bool isFound = await canLaunchUrl(url);
//     debugPrint('is Found $isFound');
    if (!isFound) {
      //https://apps.apple.com/in/app/kidzeeapp/id1338356944
      await launchUrl(
        Uri.parse('https://apps.apple.com/in/app/fantasy-box/id6459878117'),
      );
//       debugPrint('app store');
    } else {
      await launchUrl(url);
//       debugPrint('App Found $url');
    }
  }

  Future<bool> applaunchUrlAndroid(url) async {
    debugPrint('url status');
    bool isFound = await canLaunchUrl(Uri.parse('fantasybox://?$url'));
    debugPrint('is Found $isFound');
    if (!isFound) {
      //https://apps.apple.com/in/app/kidzeeapp/id1338356944
      await launchUrl(
        Uri.parse(
          'https://play.google.com/store/apps/details?id=com.zeelearn.kidzeeFantasyBox&hl=en_US&gl=US',
        ),
      );
//       debugPrint('app store');
    } else {
      await launchUrl(Uri.parse('fantasybox://?$url'));
//       debugPrint('App Found $url');
    }
    return isFound;
  }

  Widget getCommonMenuForWeb() {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_drawar_home.png'),
          ),
          title: const Text('Home'),
          selected: _selectedDestination == MENU_LEARNING_GOAL,
          onTap: () => selectDestination(MENU_LEARNING_GOAL),
        ),
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_myinfo.png'),
          ),
          title: const Text('My Info'),
          selected: _selectedDestination == 1,
          onTap: () => selectDestination(1),
        ),
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_holiday.png'),
          ),
          title: const Text('Holiday List'),
          selected: _selectedDestination == MENU_HOLIDAYS,
          onTap: () => selectDestination(MENU_HOLIDAYS),
        ),
      ],
    );
  }

  Widget getCommonMenu() {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_drawar_home.png'),
          ),
          title: const Text('Home'),
          selected: _selectedDestination == MENU_LEARNING_GOAL,
          onTap: () => selectDestination(MENU_LEARNING_GOAL),
        ),
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_fantasy.png'),
          ),
          title: const Text('Fantasy Box'),
          selected: _selectedDestination == 0,
          onTap: () => openMusePlay(),
        ),
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_myinfo.png'),
          ),
          title: const Text('My Info'),
          selected: _selectedDestination == 1,
          onTap: () => selectDestination(1),
        ),
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_myinfo.png')),
          title: Text('ARTSY Demo'),
          selected: _selectedDestination == MENU_ARTSY,
          onTap: () => selectDestination(MENU_ARTSY),
        ),*/
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_ledger.png')
          ),
          title: Text('Ledger'),
          selected: _selectedDestination == MENU_LEDGER,
          onTap: () => selectDestination(MENU_LEDGER),
        ),*/
        /* ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_rhymes_avs.png')),
          title: Text('Rhymes and AV'),
          selected: _selectedDestination == 10,
          onTap: () => selectDestination(10),
        ),*/
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_rhymes_avs.png')),
          title: Text('Pentemind'),
          selected: _selectedDestination == MENU_LEARNING_GOAL,
          onTap: () => selectDestination(MENU_LEARNING_GOAL),
        ),*/
        /* ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_ecampus.png')),
          title: Text('Digital Support'),
          selected: _selectedDestination == 2,
          onTap: () => selectDestination(2),
        ),*/
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_ecampus.png')
          ),
          title: Text('Induction'),
          selected: _selectedDestination == MENU_INDUCTION,
          onTap: () => onInductionClicked(),
        ),*/
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_helpdesk.png')
          ),
          title: Text('HelpDesk'),
          selected: _selectedDestination == MENU_HELPDESK,
          onTap: () => selectDestination(MENU_HELPDESK),
        ),*/
        /*  ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_news.png')),
          title: const Text('News'),
          selected: _selectedDestination == MENU_NEWS,
          onTap: () => selectDestination(MENU_NEWS),
        ), */
        /*  ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_news.png')),
          title: const Text('TIPS'),
          selected: _selectedDestination == MENU_TIPS,
          onTap: () => selectDestination(MENU_TIPS),
        ), */
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_holiday.png'),
          ),
          title: const Text('Holiday List'),
          selected: _selectedDestination == MENU_HOLIDAYS,
          onTap: () => selectDestination(MENU_HOLIDAYS),
        ),
        /*  ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_socialmedia.png')),
          title: const Text('Social'),
          selected: _selectedDestination == 11,
          onTap: () => selectDestination(11),
        ), */
      ],
    );
  }

  Widget parentMenu() {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_event.png'),
          ),
          title: const Text('Event and Happening'),
          selected: _selectedDestination == MENU_EVENT_HAPPENING,
          onTap: () => selectDestination(MENU_EVENT_HAPPENING),
        ),
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_event.png')
          ),
          title: Text('Student Diary'),
          selected: _selectedDestination == MENU_STUDENT_DIARY,
          onTap: () => selectDestination(MENU_STUDENT_DIARY),
        ),*/
        /*ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/action_attendance.png')),
          title: Text('Attendance'),
          selected: _selectedDestination == MENU_ATTENDANCE,
          onTap: () => selectDestination(MENU_ATTENDANCE),
        )*/
      ],
    );
  }

  Column getTeachersMenu() {
    return Column(
      children: [
        // ListTile(
        //   leading: SizedBox(
        //     height: 32.0,
        //     width: 32.0,
        //     child: Image.asset('assets/icons/ic_helpdesk.png'),
        //   ),
        //   title: const Text('HelpDesk'),
        //   selected: _selectedDestination == MENU_HELPDESK,
        //   onTap: () => selectDestination(MENU_HELPDESK),
        // ),
      ],
    );
  }

  Column getFranchiseeMenu() {
    //debugPrint('Franchisee Menu');
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_ledger.png'),
          ),
          title: const Text('Tracker Indent'),
          selected: _selectedDestination == MENU_TRACKER_INDENT,
          onTap: () => selectDestination(MENU_TRACKER_INDENT),
        ),
        ListTile(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset('assets/icons/ic_chat.png'),
          ),
          title: const Text('Communication'),
          selected: _selectedDestination == MENU_COMMUNICATION,
          onTap: () => selectDestination(MENU_COMMUNICATION),
        ),
        /* ListTile(
          leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/images/ic_business.png')),
          title: const Text('Indent'),
          selected: _selectedDestination == MENU_INDENT,
          onTap: () => selectDestination(MENU_INDENT),
        ), */
        // ListTile(
        //   leading: SizedBox(
        //     height: 32.0,
        //     width: 32.0,
        //     child: Image.asset('assets/icons/ic_helpdesk.png'),
        //   ),
        //   title: const Text('HelpDesk'),
        //   selected: _selectedDestination == MENU_HELPDESK,
        //   onTap: () => selectDestination(MENU_HELPDESK),
        // ),
        /***
         * As per disscussion with @Anurag ledger no longer in use
        * */
        // ListTile(
        //   leading: SizedBox(
        //     height: 32.0,
        //     width: 32.0,
        //     child: Image.asset('assets/icons/ic_ledger.png'),
        //   ),
        //   title: const Text('Ledger'),
        //   selected: _selectedDestination == MENU_LEDGER,
        //   onTap: () => selectDestination(MENU_LEDGER),
        // ),
      ],
    );
  }

  void profileClicked() {
    showImageOption();
  }

  void showImageOption() {
    Navigator.pop(context);
    List<String> options = ['Gallery', 'Camera'];
    if (widget.profileImage.isNotEmpty) {
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
      },
    );
  }

  Future<void> showImagePicker(int action) async {
    if (action != 3) {
      XFile? photo;
      if (action == 0) {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 72,
        );
      }
      if (photo != null) {
        showLoader(context);
        APIService().uploadImage(userId.toString(), photo, listener: this);
      }
    } else {
      //debugPrint('Image Profile is ${widget.profileImage}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String imageAvtar =
          prefs.getString(LocalConstant.KEY_USER_AVTAR) as String;
      //debugPrint(imageAvtar);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return goToImageViewer(imageUrl: widget.profileImage.toString());
          },
        ),
      );
    }
  }

  void showLoader(BuildContext context) {
    if (isKES()) {
      Utility.showKESLoaderDialog(context);
    } else {
      Utility.showLoaderDialog(context);
    }
  }

  void updateStudentProfile(String url) {
    showLoader(context);
    UpdateStudentProfileRequest request = UpdateStudentProfileRequest(
      StudentId: studentId,
      studentprofileURL: url,
    );
    APIService apiService = APIService();
    apiService.updateStudentProfile(request, token).then((value) {
      if (value != null) {
        Utility.hideDialog(context);
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            //Navigator.of(context, rootNavigator: true).pop('dialog');
            Utility.showMessage(
              context,
              response.response[0].response.toString(),
            );
          }
        } else {
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          Utility.showMessage(context, 'data not found');
        }
        setState(() {});
      }
    });
  }

  UserAccountsDrawerHeader getHeader() {
    getToken();
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: kPrimaryLightColor),
      accountEmail: mTitle.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mTitle),
            ),
      accountName: mClassName.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mClassName),
            ),
      otherAccountsPictures: AppFlavor == 'mlzs'
          ? null
          : [
              IconButton(
                icon: Image.asset(
                  'assets/icons/ic_facebook.png',
                  height: 24,
                  width: 24,
                ),
                onPressed: () => launchUrl(
                  Uri.parse('https://www.facebook.com/KidzeeIndia/'),
                ),
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/ic_instagram.png',
                  height: 24,
                  width: 24,
                ),
                // icon: const Icon(
                //   FontAwesomeIcons.instagram,
                //   color: Colors.purple,
                // ),
                onPressed: () => launchUrl(
                  Uri.parse('https://www.instagram.com/kidzeeindia/'),
                ),
              ),
            ],
      otherAccountsPicturesSize: const Size.square(60),
      currentAccountPicture: GestureDetector(
        onTap: () {
          if (userType == 'P') {
            profileClicked();
          }
        },
        child: Container(
          width: ScreenUtil().setWidth(37.0),
          height: ScreenUtil().setHeight(37.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white /* Color.fromRGBO(221, 40, 81, 0.18) */,
          ),
          child: FadeInImage(
            width: 20,
            height: 20,
            placeholder: const AssetImage('assets/icons/ic_myinfo.png'),
            image: NetworkImage(widget.profileImage),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/icons/ic_myinfo.png',
                fit: BoxFit.fitWidth,
              );
            },
            fit: BoxFit.cover,
          ),
        ) /*CircleAvatar(
          radius: 50.0,
          backgroundColor: Color(0xFF778899),
          backgroundImage:  widget.profileImage.isNotEmpty ? NetworkImage(widget.profileImage) : null,
        ),*/
        ,
      ),
    );
  }

  ListView getMenu() {
//     debugPrint('generate menu type $_curriculamType');
    if (_curriculamType == 'K12') {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          getHeader(),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/ic_review.png'),
              ),
              title: const Text('Rate Us'),
              selected: _selectedDestination == 9,
              onTap: () => rateUs(),
            ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_holiday.png'),
            ),
            title: const Text('Holiday List'),
            selected: _selectedDestination == MENU_HOLIDAYS,
            onTap: () => selectDestination(MENU_HOLIDAYS),
          ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_elg.png'),
            ),
            title: const Text('Change Password'),
            selected: _selectedDestination == CHANGE_PASSWORD,
            onTap: () => changePassword(),
          ),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/privacy.png'),
              ),
              title: const Text('Privacy Policy'),
              selected: _selectedDestination == PRIVACY_POLICY,
              onTap: () => privacyPolicy(),
            ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_logout.png'),
            ),
            title: const Text('Log Out'),
            selected: _selectedDestination == 9,
            onTap: () => signOut(),
          ),
        ],
      );
    } else if (userType == 'P') {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          getHeader(),
          kIsWeb ? getCommonMenuForWeb() : getCommonMenu(),
          userType == 'P'
              ? parentMenu()
              : userType == 'TEACH' || userType == 'SRTEA'
                  ? getTeachersMenu()
                  : getFranchiseeMenu(),
          // ListTile(
          //   leading: SizedBox(
          //       height: 32.0,
          //       width: 32.0,
          //       child: Image.asset('assets/icons/ic_quickconnect.png')),
          //   title: const Text('Quick Contact'),
          //   selected: _selectedDestination == MENU_QUICK_CONTACT,
          //   onTap: () => selectDestination(MENU_QUICK_CONTACT),
          // ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_elg.png'),
            ),
            title: const Text('Change Password'),
            selected: _selectedDestination == CHANGE_PASSWORD,
            onTap: () => changePassword(),
          ),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/ic_review.png'),
              ),
              title: const Text('Rate Us'),
              selected: _selectedDestination == 9,
              onTap: () => rateUs(),
            ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_logout.png'),
            ),
            title: const Text('Log Out'),
            selected: _selectedDestination == 9,
            onTap: () => signOut(),
          ),
        ],
      );
    } else {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          getHeader(),
          kIsWeb ? getCommonMenuForWeb() : getCommonMenu(),
          userType == 'P'
              ? parentMenu()
              : userType == 'TEACH' || userType == 'SRTEA'
                  ? getTeachersMenu()
                  : getFranchiseeMenu(),
          // ListTile(
          //   leading: SizedBox(
          //       height: 32.0,
          //       width: 32.0,
          //       child: Image.asset('assets/icons/ic_quickconnect.png')),
          //   title: const Text('Quick Contact'),
          //   selected: _selectedDestination == MENU_QUICK_CONTACT,
          //   onTap: () => selectDestination(MENU_QUICK_CONTACT),
          // ),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/ic_starttime.png'),
              ),
              title: const Text('Sync Interval'),
              onTap: () => Utility.showSyncIntervalDialog(context),
            ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_elg.png'),
            ),
            title: const Text('Change Password'),
            selected: _selectedDestination == CHANGE_PASSWORD,
            onTap: () => changePassword(),
          ),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/privacy.png'),
              ),
              title: const Text('Privacy Policy'),
              selected: _selectedDestination == PRIVACY_POLICY,
              onTap: () => privacyPolicy(),
            ),
          if (!kIsWeb)
            ListTile(
              leading: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Image.asset('assets/icons/ic_review.png'),
              ),
              title: const Text('Rate Us'),
              selected: _selectedDestination == 9,
              onTap: () => rateUs(),
            ),
          ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset('assets/icons/ic_logout.png'),
            ),
            title: const Text('Log Out'),
            selected: _selectedDestination == 9,
            onTap: () => signOut(),
          ),
        ],
      );
    }
  }

  Widget getNavigationalDrawar() {
    return Drawer(child: getMenu());
  }

  Future<void> rateUs() async {
    final InAppReview inAppReview = InAppReview.instance;
    Navigator.of(context).pop();
    if (await inAppReview.isAvailable()) {
      //inAppReview.requestReview();
      _inAppReview.openStoreListing();
    } else {
//       debugPrint('Review not working........');
    }
  }

  void changePassword() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ChangePasswordPage(),
      ),
    );
    _selectedDestination == MENU_LEARNING_GOAL;
  }

  void privacyPolicy() {
    if (kIsWeb) {
    } else {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PrivacyPolicyScreen(),
        ),
      );
      //_selectedDestination == MENU_LEARNING_GOAL;
      setState(() {
        isLoading = false;
      });
    }
  }

  // onInductionClicked() {
  //   //debugPrint('User type is ${userType}');
  //   if (userType == 'TEACH' || userType == 'SRTEA') {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => EnrollInductinonScreen()),
  //     );
  //   } else {
  //     selectDestination(MENU_INDUCTION);
  //   }
  // }

  Widget getScreen() {
    //int yearid = is24 ? 24 : 25;
    switch (_selectedDestination) {
      case 0:
        _moduleTitle = 'HOME';
        return ListView.builder(
          itemCount: bannerList.length,
          padding: const EdgeInsets.only(top: 8),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final int count = bannerList.length > 10 ? 10 : bannerList.length;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController!,
                curve: Interval(
                  (1 / count) * index,
                  1.0,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            );
            animationController?.forward();
            return getHomeScreenCard(bannerList[index]);
          },
        );
      case MENU_COMMUNICATION:
        return goToCommunicationScreen(franchiseeId: francinseeId.toString());
      case MENU_INDENT:
        return goToIndentHistoryScreen(
            franchiseeid: int.parse(francinseeId.toString()));
      case MENU_ARTSY:
        return goToKltChewieVideo(
          filePath:
              'https://api.dyntube.com/v1/live/videos/tKPMXjaxpE2xDr22DcFXGA.m3u8',
          Title: 'Nursery - My Lovely Name',
        );
      case 1:
        return goToMyInfoScreen();
      case 10:
        return goToKLTScreen();
      case 11:
        return goToSocialScreen();
      case MENU_HOLIDAYS:
        return onHolidyClick();
      //return goToHolidayScreen();
      case MENU_STUDENT_DIARY:
        return goToStudentDiaryScreen();
      case MENU_EVENT_HAPPENING:
        return goToEventAndHappeningScreen();
      case MENU_ATTENDANCE:
        //debugPrint(userType);
        if (userType == 'P') {
          return goToTableEventsExample(userId: userId.toString());
        } else if (userType == 'TEACH' || userType == 'SRTEA') {
          return goToClasswiseAttendance(userId: userId.toString());
        } else {
          return goToTableEventsExample(userId: userId.toString());
        }
      case MENU_LEARNING_GOAL:
        return pentemindMenu();
      case MENU_LEARNING_GOAL_M:
        return pentemindMenu();
      case LocalConstant.ACTION_PENTEMIND_MODULE:
        //_launchUrl();
        return getPentemind(Uri.encodeFull(_pentemindModuleUrl));
      case PENTEMIND_LEARNING_GOAL:
        return _currentPentemind;
      case MENU_QUICK_CONTACT:
        return goToQuickContactScreen();
      // case MENU_NEWS:
      //   return NewsScreen(type: 'NEWS');
      // case MENU_TIPS:
      //   return TipsScreen(type: 'TIPS');
      // case MENU_HELPDESK:
      //   return goToHelpDeskScreen();
      // case MENU_LEDGER:
      //   return goToMyLedgerScreen();
      case MENU_TRACKER_INDENT:
        _moduleTitle = 'TRACK ORDER';
        return goToTrackOrderScreen(franchiseeId: francinseeId.toString());
      case MENU_CELIBRATION:
        String teacherId = userType == 'P' ? 'null' : userId.toString();
        String studId = userType == 'P' ? studentId.toString() : 'null';

        if (kIsWeb) {
          Utility.launchURL(
            '${LocalConstant.URL_PRINT_PENTEMIND}Celebration/$_currentProgramId&$teacherId&$studId&$_currentClassId&$uid&$userType&$currentAcademicYear&app',
          );
          return getScreen();
        } else {
          return goToMYWebsite(
            title: '',
            url:
                '${LocalConstant.URL_PRINT_PENTEMIND}Celebration/$_currentProgramId&$teacherId&$studId&$_currentClassId&$uid&$userType&$currentAcademicYear&app',
          );
        }
      case MENU_PARENT_SUPPORT_DESK:
        return goToMYWebsite(
          title: 'Parent Support Desk',
          url:
              '${LocalStrings.baseUrl}/parentsupport/$uid&$_currentProgramId&$userType&$currentAcademicYear',
        );

      default:
        return AboutUs(name: '', title: '');
    }
  }

  String getSaathiUserType(String type) {
    String userRole = '';
    switch (type) {
      case 'TEACH':
        userRole = 'Teacher';
        break;
      case 'P':
        userRole = 'Parent';
        break;
      case 'F':
        userRole = 'Franchisee';
        break;
      case 'Principal':
      case 'CM':
        userRole = 'Principal';
        break;
      case 'CC':
        userRole = 'School Admin';
        break;
      case 'SRTEA':
        userRole = "Teacher";
        break;
    }
    return userRole;
  }

  Widget homeMenu() {
    return getScreen();
  }

  Widget getWebView(String url) {
    if (kIsWeb) {
      Utility.launchURL(url);
      return homeMenu();
    } else {
      return goToMYWebsite(
        title: 'Parent Support Desk',
        url:
            '${LocalStrings.baseUrl}/parentsupport/$uid&$_currentProgramId&$userType&$currentAcademicYear',
      );
    }
  }

  Widget pentemindMenu() {
    if (mMaterials.isEmpty) {
      getMaterials();
    }
    return Container(
      child: isLoading
          ? Utility.showLoader()
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // height: 80,
                  // margin: const EdgeInsets.all(8),
                  width: MediaQuery.sizeOf(context).width,
                  child: ValueListenableBuilder(
                    valueListenable: logbookattendanceStatusBox!.listenable(),
                    builder: (context, Box box, widget) {
                      if (box.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        var allStatusData = box.values.toList();

                        List<StatusModel> statusListModel = [];

                        for (int i = allStatusData.length - 1; i > 0; i--) {
                          statusListModel.add(allStatusData[i]);
                        }

                        if (statusListModel.isNotEmpty) {
                          return SizedBox(
                            // margin: const EdgeInsets.only(bottom: 5),
                            height: 100,
                            child: PageView.builder(
                              itemCount: statusListModel.length,
                              pageSnapping: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, pagePosition) {
                                return Card(
                                  // elevation: 5.0,
                                  margin: const EdgeInsets.all(8),
                                  // shadowColor: kPrimaryLightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 0.5,
                                      color: kPrimaryLightColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        !statusListModel[pagePosition]
                                                .logbookStatus
                                            ? onClick(
                                                LocalConstant
                                                    .ACTION_PENTEMIND_MODULE,
                                                PentemindItem(
                                                  3,
                                                  'Facilitator Tools',
                                                  LocalConstant
                                                      .MODULE_FACILATORTOOL,
                                                  'assets/icons/ic_facilitatortools.png',
                                                  logbookDay: statusListModel[
                                                          pagePosition]
                                                      .day
                                                      .toString(),
                                                  logbookProgramId:
                                                      statusListModel[
                                                              pagePosition]
                                                          .programID
                                                          .toString(),
                                                  hiveIndex: pagePosition,
                                                ),
                                              )
                                            : onClick(
                                                LocalConstant
                                                    .ACTION_PENTEMIND_MODULE,
                                                PentemindItem(
                                                  4,
                                                  'Learning Goals',
                                                  'learninggoals',
                                                  'assets/icons/ic_learninggoals.png',
                                                  logbookDay: statusListModel[
                                                          pagePosition]
                                                      .day
                                                      .toString(),
                                                  logbookProgramId:
                                                      statusListModel[
                                                              pagePosition]
                                                          .programID
                                                          .toString(),
                                                  hiveIndex: statusListModel[
                                                          pagePosition]
                                                      .key,
                                                ),
                                              );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 8.0,
                                                    ),
                                                    child: Text(
                                                      !statusListModel[
                                                                  pagePosition]
                                                              .logbookStatus
                                                          ? 'Kindly fill the logbook for ${statusListModel[pagePosition].className}  Day - ${statusListModel[pagePosition].day}'
                                                          : 'Kindly fill the Learning Goal for ${statusListModel[pagePosition].className}  Day - ${statusListModel[pagePosition].day}',
                                                      style: LightColors
                                                          .textHeaderStyle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              !statusListModel[pagePosition]
                                                      .logbookStatus
                                                  ? onClick(
                                                      LocalConstant
                                                          .ACTION_PENTEMIND_MODULE,
                                                      PentemindItem(
                                                        3,
                                                        'Facilitator Tools',
                                                        LocalConstant
                                                            .MODULE_FACILATORTOOL,
                                                        'assets/icons/ic_facilitatortools.png',
                                                        logbookDay:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .day
                                                                .toString(),
                                                        logbookProgramId:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .programID
                                                                .toString(),
                                                        hiveIndex:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .key,
                                                      ),
                                                    )
                                                  : onClick(
                                                      LocalConstant
                                                          .ACTION_PENTEMIND_MODULE,
                                                      PentemindItem(
                                                        4,
                                                        'Learning Goals',
                                                        'learninggoals',
                                                        'assets/icons/ic_learninggoals.png',
                                                        logbookDay:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .day
                                                                .toString(),
                                                        logbookProgramId:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .programID
                                                                .toString(),
                                                        hiveIndex:
                                                            statusListModel[
                                                                    pagePosition]
                                                                .key,
                                                      ),
                                                    );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  kPrimaryLightColor,
                                            ),
                                            child: Text(
                                              'Fill',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: pentemindMenus.length,
                    itemBuilder: (context, index) =>
                        getPentemindMenu(pentemindMenus[index]),
                    gridDelegate: Utility.getGridViewStyle(),
                  ),
                ),
                _className.contains('MDTR')
                    ? Expanded(child: introGrid())
                    : const Text(''),
              ],
            ),
    );
  }

  Widget getPentemindMenu(PentemindItem item) {
    bool isModuleEnabled = isInternet ||
        item.title == 'My Class' ||
        item.title == 'Tracker' ||
        item.title == 'Learning Materials' ||
        item.title == 'Nepal Learning Resource' ||
        item.title == 'Learning Goals' ||
        item.actionKey == 'attendance' ||
        item.actionKey == 'learninggoals' ||
        item.actionKey == LocalConstant.MODULE_PARENT_TRACKER ||
        item.actionKey == LocalConstant.MODULE_LEARNING_MATERIAL ||
        item.actionKey == LocalConstant.MODULE_LEARNING_MATERIAL_NEPAL;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Opacity(
        opacity: isModuleEnabled ? 1.0 : 0.5,
        child: Card(
          color: kPrimaryLightColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            mouseCursor: isModuleEnabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            highlightColor: isModuleEnabled
                ? Colors.yellow.withValues(alpha: 0.3)
                : Colors.transparent,
            splashColor: isModuleEnabled
                ? Colors.red.withValues(alpha: 0.8)
                : Colors.transparent,
            onTap: isModuleEnabled
                ? () {
                    _moduleTitle = item.title;
                    if (item.actionKey ==
                        MODULE_LITERANOVA_OCTAVE(localAcademicYearID)) {
                      openLiteraNova();
                    } else if (_currentProgramName.isNotEmpty ||
                        item.title == LocalConstant.MODULE_CHAT_WITHUS) {
                      onClick(LocalConstant.ACTION_PENTEMIND_MODULE, item);
                    } else {
                      onClick(
                          LocalConstant.ACTION_PENTEMIND_CLASS_SELECTION, item);
                    }
                  }
                : () {
                    Get.snackbar(
                      "Offline Mode",
                      "This module requires an internet connection.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  },
            child: Container(
              child: ListTile(
                title: Text(item.title, style: LightColors.menuStyle),
                trailing: Image.asset(
                  item.assetlocation,
                  width: kIsWeb ? 50 : 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getHomeScreenCard(ActivityPlanerModel model) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            /*leading: Icon(Icons.arrow_drop_down_circle),*/
            title: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(model.title),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
          ),
          Image.network(model.full_image, fit: BoxFit.cover, height: 200),
        ],
      ),
    );
  }

  Widget getPentemind(pentemindUrl) {
    return MyWebsiteView(title: '', url: pentemindUrl);
  }

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(
  //     Uri.parse(
  //       'http://pentemind-app.s3-website.ap-south-1.amazonaws.com?auth=VDE5MjMzNQ==',
  //     ),
  //   )) {
  //     throw 'Could not launch ';
  //   }
  // }

  bool exitEventConfirmation() {
    bool isReturn = false;
    if (mEventModel != null && mEventModel!.data.isNotEmpty) {}
    try {
      for (var event in mEventModel!.data) {
        debugPrint(event.visibleTo);
        if (event.visibleTo == 'P' && userType == 'P') {
          KidzeeBottomSheet().showExitBSPromo(context, event, this);
          isReturn = true;
        }
      }
    } catch (e) {}
    return isReturn;
  }

  bool onBackClickListener() {
//     debugPrint('back click listener');
    FocusScope.of(context).unfocus();
    if (!isLoading) {
      if (isFeedbackEnabled) {
        return false;
      } else if (_currentPentemind == 'HOME') {
        if (!exitEventConfirmation()) {
          showExitConfirmation();
        }
      } else {
        _currentPentemind = 'HOME';
        _moduleTitle = 'HOME';
        setState(() {
          _selectedDestination = MENU_LEARNING_GOAL;
        });
      }
    }
    return false;
  }

  void showExitConfirmation() {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
      onPressed: () {
        Utility.hideDialog(context);
        //Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Exit", style: TextStyle(color: Colors.black)),
      onPressed: () {
        Utility.hideDialog(context);
        //Navigator.of(context, rootNavigator: true).pop('dialog');
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 100), () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Would you like to Exit?"),
      actions: [cancelButton, continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String getDate() {
    //2023-03-02T07:26:28.307Z
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> getDay() async {
    debugPrint('Initial Snapshot - getDay');
    if (_currentProgramId <= 0) {
      showClassDialog();
      return;
    }

    // 1. Check Internet
    if (isInternet) {
      showLoader(context);
      try {
        GetDayRequest request = GetDayRequest(
          ProgramId: _currentProgramId.toString(),
          AttendanceDate: getDate(),
          D: -1,
          CName: '',
        );
        APIService apiService = APIService();
        final value = await apiService.getDay(request, token);
        Utility.hideDialog(context);

        if (value != null && value is GetDayResponse) {
          GetDayResponse response = value;
          KidzeePref.setDay(
            context,
            _currentProgramId,
            jsonEncode(response.toJson()),
          );
          Get.log('Initial Snapshot - ${response.toJson()}');
          if (!isFeedbackApiCalled) {
            checkFeedback();
          }
        } else {
          _setDefaultDay();
        }
      } catch (e) {
        Utility.hideDialog(context);
        debugPrint('Error in getDay: $e');
        _setDefaultDay();
      }
    } else {
      // 2. Offline: Try to get cached day or set default
      GetDayResponse cachedDay = await KidzeePref.getDay(context);
      if (cachedDay.success == 400) {
        _setDefaultDay();
      } else {
        if (!isFeedbackApiCalled) {
          checkFeedback();
        }
      }
    }
  }

  void _setDefaultDay() {
    GetDayResponse defaultResponse = GetDayResponse(
      success: 200,
      data: GetDayResponseModel(D: 1, CName: '', C: '1'),
    );
    KidzeePref.setDay(
      context,
      _currentProgramId,
      jsonEncode(defaultResponse.toJson()),
    );
    if (!isFeedbackApiCalled) {
      checkFeedback();
    }
  }

  void checkFeedback() {
//     debugPrint('response in resources ${isKES()}');
    if (!isKES()) {
//       debugPrint('response in resources not KES');
      feedbackForAll();
    }
  }

  Future<void> signOut() async {
    await BpmsDB.clearAll(LocalConstant.authStorageKey);
    final prefs = await SharedPreferences.getInstance();
    KidzeePref().clearLoginData();
    prefs.clear();
    if (!kIsWeb) {
      var appDir = (await getTemporaryDirectory()).path;
      Directory(appDir).delete(recursive: true);
    }
    await Hive.box(LocalConstant.logbookStatus).clear();
    await OctiveConfig().clearAllData();
    // await Future.delayed(const Duration(seconds: 0));
    if (!kIsWeb && !mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreenV2(),
      ),
      (route) => false,
    );
    // if (Platform.isAndroid) {
    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //   });
    // } else if (Platform.isIOS) {
    //   exit(0);
    // }
  }

  void openLiteraNova() {
    String batchName = NormalizeClassName.normalizeGrade(
      _className,
    ); // classProgram!.className;
    debugPrint('batchNamebatchName $batchName');
    UserInfoModel userInfoModel = UserInfoModel(
        userName: userName,
        userType: userType,
        baseUrl: '',
        isTeacher: userType == 'TEACH' ? true : false,
        isStudent: userType == 'P' ? true : false,
        isInternalUser: false,
        displayname: mTitle,
        sectionId: _currentClassId,
        academicYear: localAcademicYearID);

    debugPrint('Current Academic year is - $ayId');
    Get.to(
      LiteriaNovaSplashScreen(
        branch: batchName,
        config: LiteraNovaConfig(
            flavor: localAcademicYearID >= 26 && isKES()
                ? octave.AppFlavor.congnimind
                : octave.AppFlavor.octave,
            theme: ChristmasTheme.octaveTheme,
            userInfoModel: userInfoModel,
            baseUrl: '',
            batchId: _currentClassId,
            batchName: batchName,
            academicYear: localAcademicYearID),
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == 100 && value == 'exit') {
      if (Platform.isAndroid) {
        Future.delayed(const Duration(milliseconds: 100), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      if (value is CuminationDayModel) {
        setState(() {
          _moduleTitle = 'MY CLASS';
        });
        _selectedDestination = PENTEMIND_LEARNING_GOAL;
        //KidzeeBottomSheet().showBSCulminationList(context,_currentProgramId, this);
        _currentPentemind = MyClassModule(
          listener: this,
          culminationModel: value,
        );
      } else if (value is DayCalenderResponse) {
        setState(() {
          _moduleTitle = 'MY CLASS';
        });
        _selectedDestination = PENTEMIND_LEARNING_GOAL;
        //KidzeeBottomSheet().showBSCulminationList(context,_currentProgramId, this);
        /*_currentPentemind = MyClassModule(
            listener: this, culminationModel: value as DayCalenderResponse,
          );*/
      } else if (value is UploadImageResponse) {
        UploadImageResponse response = value;
        Utility.hideDialog(context);
        if (value.message.contains('Successfully')) {
          updateStudentProfile(value.imageModel![0].location);
          setState(() {
            widget.profileImage = value.imageModel![0].location;
          });
        } else {
          Utility.showMessageCallback(context, 'Alert', value.message, this);
        }
        //Navigator.of(context, rootNavigator: true).pop('dialog');
      }
    } else if (action == LocalConstant.ACTION_PENTEMIND_CLASS_SELECTION) {
      checkClassSelection();
    } else if (action == Utility.ACTION_OK) {
      Navigator.pop(context, [1]);
    } else if (action == LocalConstant.ACTION_OPENCLASSDETAILS) {
      debugPrint(
          'opening Class Details for $francinseeId programId $_currentProgramId');
      Get.to(ClassDetailsPage(
        franchiseeId: francinseeId,
        programId: _currentProgramId,
      ));
      // String url =  '${LocalStrings.baseUrl}/classinfo/${francinseeId == 0 ? null : francinseeId}&${_currentProgramId != 0 ? _currentProgramId : null}&${uid.isEmpty ? uid : null}';
      //
      // setState(() {
      //   if (kIsWeb) {
      //     Utility.launchURL(url);
      //   } else {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             MyWebsiteView(title: 'Class Details', url: url),
      //       ),
      //     );
      //     //_moduleTitle = 'ZllSaarthi';
      //     //_selectedDestination = MENU_ZEESARTHI;
      //   }
      // });
    } else if (action == LocalConstant.ACTION_PENTEMIND_MODULE) {
      PentemindItem item = value as PentemindItem;
      setState(() {
        if (item.actionKey == LocalConstant.MODULE_K12_LG) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          //_currentPentemind = KESLearningGoalPage();
//           debugPrint('_currentClassId $_currentClassId');
          updateTitle('Assessments');
          _currentPentemind = KESLearningGoalPage(
            className: _className,
            sectinId: _currentProgramId,
            classId: _currentClassId,
            userUID: userId.toString(),
            userName: userName,
          );
        } else if (item.actionKey == LocalConstant.MODULE_K12_MYCLASS) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
//           debugPrint('_currentClassId $_currentClassId');
          updateTitle('My Class');
          if (localAcademicYearID >= 26 && isKES()) {
            _currentPentemind = MyCogniClassPage(
              listener: this,
              sectinId: _currentProgramId,
              classId: _currentClassId,
              userUID: userId.toString(),
              userName: userName,
            );
          } else {
            _currentPentemind = MyKesClassPage(
              listener: this,
              sectinId: _currentProgramId,
              classId: _currentClassId,
              userUID: userId.toString(),
              userName: userName,
            );
          }
        } else if (item.actionKey == LocalConstant.MODULE_K12_ALMANAC_TOOL) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
//           debugPrint('_currentClassId $_currentClassId');
          updateTitle('Almanac');
          _currentPentemind = almanac_placeholder.AlmanacMenu(listener: this);
        } else if (item.actionKey == LocalConstant.MODULE_K12_FACILATOR_TOOL) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          //_currentPentemind = KESLearningGoalPage();
          updateTitle('Faciliator Tool');
          _currentPentemind = FacilatorToolPage(
            classid: _className,
            projectId: businessId,
            userName: userName,
          );
          // _currentPentemind =FolderPage(parentFolderName: 'Curicular',classId: 68,projectid: 1, subject: 0,);
        } else if (item.actionKey == LocalConstant.MODULE_K12_LOGBOOK) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          updateTitle('Logbook');
          //_currentPentemind = KESLogbookPage(userName: userName, classId: _currentClassId, date: '2024-09-30', periodId: 789, sectionId: 5083, subjectId: 52,);
          _currentPentemind = LogbookPage(
            userName: userName,
            classId: _className,
          );
        } else if (item.actionKey == LocalConstant.MODULE_K12_HOMEWORK_TOOL) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          updateTitle('Homework');
          //_currentPentemind = KESLogbookPage(userName: userName, classId: _currentClassId, date: '2024-09-30', periodId: 789, sectionId: 5083, subjectId: 52,);
          if (LocalConstant.isCognimind) {
            _currentPentemind = HomeworkHome(userType: userType);
          } else if (isKES()) {
            _currentPentemind = HomeworkHomeKES(userType: userType);
          } else {
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = MyHomeworkScreen(isToolbar: false);
          }
        } else if (item.actionKey == LocalConstant.MODULE_K12_HOMEWORK_TOOL) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          updateTitle('Homework');
          //_currentPentemind = KESLogbookPage(userName: userName, classId: _currentClassId, date: '2024-09-30', periodId: 789, sectionId: 5083, subjectId: 52,);
          _currentPentemind = HomeworkHome(
            userType: userType,
          );
        } else if (item.actionKey == LocalConstant.MODULE_K12_HOMELINK_TOOL) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          updateTitle('HomeLink');
          //_currentPentemind = KESLogbookPage(userName: userName, classId: _currentClassId, date: '2024-09-30', periodId: 789, sectionId: 5083, subjectId: 52,);
          _currentPentemind = FolderPage(
            parentFolderName: 'HomeLink',
            classId: _className,
            projectid: businessId,
            subject: 0,
            userName: userName,
          );
        } else if (item.actionKey == LocalConstant.MODULE_K12_HPCREPORT_TOOL) {
          final hpcReportUrl =
              '${WebViewUrlConstants.URL_HPC_REPORT}${studentId.toString()}&${_currentProgramId.toString()}&$currentAcademicYear';
          if (kIsWeb) {
            launchUrl(
              Uri.parse(hpcReportUrl),
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: '_blank',
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyWebsiteView(
                  title: 'HPC Report',
                  url: hpcReportUrl,
                ),
              ),
            );
          }
        } else if (item.actionKey == LocalConstant.MODULE_K12_REPORTS) {
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          updateTitle('Report');
          //debugPrint('currentProgramId ${_currentProgramId} userName ${userName}  ${_currentClassId} ${userId}');
          _currentPentemind = LearningGoalReportPage(
            sectionId: _currentProgramId,
            userName: userName,
            classId: _currentClassId,
            teacherId: userId.toString(),
          );
        } else if (item.actionKey == 'attendance') {
          setState(() {
            _moduleTitle = 'MY CLASS';
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          //KidzeeBottomSheet().showBSCulminationList(context,_currentProgramId, this);
          _currentPentemind = MyClassModule(
            listener: this,
            culminationModel: CuminationDayModel(
              Cid: 1,
              CName: 'cNAME',
              AttendanceDate: '',
              D: 1,
              W: 1,
              IsDisabled: false,
            ),
          );
        } else if (item.actionKey == 'learninggoals') {
          setState(() {
            _moduleTitle = 'Learning Goals';
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = PentemindLearningGoal(
            term: _curriculamTern,
            listener: this,
            day: item.logbookDay,
            programId: item.logbookProgramId,
          );
        } else if (item.actionKey == LocalConstant.MODULE_PENTEMIND_ACTIVITY) {
          setState(() {
            _moduleTitle = LocalConstant.MODULE_PENTEMIND_ACTIVITY;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = PentemindActivityScreen(contentType: 'PA');
        } else if (item.actionKey ==
            LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY) {
          setState(() {
            _moduleTitle = LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = PentemindFunActivityScreen(contentType: 'FA');
        } else if (item.actionKey == LocalConstant.MODULE_FACILATORTOOL) {
          setState(() {
            _moduleTitle = 'Facilitator Tools';
          });

          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = FacilatorSaysHome(
            listener: this,
            isKes: isKES(),
            term: _curriculamTern,
            culminationDay: item.logbookDay,
            programId: item.logbookProgramId,
            deepLinkingEnabled: item.logbookDay != null ? true : null,
            hiveIndex: item.hiveIndex,
          );
        } else if (item.actionKey == LocalConstant.MODULE_LEARNING_MATERIAL) {
          setState(() {
            _moduleTitle = 'Learning Materials';
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = LearningMaterialScreen(isForNepal: false);
          });
        } else if (item.actionKey ==
            LocalConstant.MODULE_K12_LEARNINGRESOURCE_TOOL) {
          setState(() {
            _moduleTitle = 'Learning Resource';
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = LearningResource(isForNepal: false);
          });
        } else if (item.actionKey ==
            LocalConstant.MODULE_LEARNING_MATERIAL_NEPAL) {
          setState(() {
            _moduleTitle = LocalConstant.MODULE_NEPAL_LEARNING_RESOURCE;
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = LearningMaterialScreen(isForNepal: true);
          });
        } else if (item.actionKey == LocalConstant.MODULE_REPORTS) {
          setState(() {
            _moduleTitle = 'Reports';
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = const ReportsScreen();
          });
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_SUPPORT_DESK) {
          getWebView(url);
          setState(() {
            if (kIsWeb) {
              Utility.launchURL(
                '${LocalStrings.baseUrl}/parentsupport/$uid&$_currentProgramId&$userType&$currentAcademicYear',
              );
            } else {
              _moduleTitle = 'Parent\'s Support Desk';
              _selectedDestination = MENU_PARENT_SUPPORT_DESK;
            }
          });
        } else if (item.actionKey == LocalConstant.MODULE_ZLLSARTHI) {
          //getWebView(url);
          businessId = AppFlavor == 'kidzee' ? 1 : 2;
          String url = userType == 'F' || userType == 'P'
              ? '${LocalStrings.zeeSarthibaseUrl}/dashboard?bu_id=$uid&b_id=$businessId&r=${userType == 'F' ? 'Francisee' : 'Parent'}&u_id=0'
              : '${LocalStrings.zeeSarthibaseUrl}/dashboard?u_name=$userName';
          if (false && kIsWeb) {
            Utility.launchURL(url);
          } else {
            //debugPrint('thr current business is ${businessId}  ${uid} ${userName} ${getSaathiUserType(userType)}');
            ZllSaathiNative(
              context,
              AppFlavor == 'kidzee' ? uid.toString() : userName,
              businessId.toString(),
              getSaathiUserType(userType),
              '0',
              kPrimaryLightColor,
              null,
            );
          }
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_CORNER) {
          setState(() {
            _moduleTitle = 'Parent\'s Corner';
            _selectedDestination = PENTEMIND_LEARNING_GOAL;
            _currentPentemind = ParentCornersHome(listener: this);
          });
        } else if (item.actionKey == LocalConstant.MODULE_CELIBRATION_DAY ||
            item.actionKey == LocalConstant.MODULE_PARENT_SAMYUJ) {
          setState(() {
            _moduleTitle = appFlavor == 'mlzs'
                ? 'ZLL Celebrations'
                : userType == 'P'
                    ? 'PARENT SAMYUJ'
                    : 'ZLL Celebrations';
            if (kIsWeb) {
              _moduleTitle = 'Home';
              String teacherId = userType == 'P' ? 'null' : userId.toString();
              String studId = userType == 'P' ? studentId.toString() : 'null';
              Utility.launchURL(
                '${LocalConstant.URL_PRINT_PENTEMIND}Celebration/$_currentProgramId&$teacherId&$studId&$_currentClassId&$uid&$userType&$currentAcademicYear&app',
              );
            } else {
              _selectedDestination = MENU_CELIBRATION;
              _currentPentemind = CelibrationScreen();
            }
            //_selectedDestination = MENU_CELIBRATION;
            //_currentPentemind = CelibrationScreen();
          });
        } else if (item.actionKey == LocalConstant.MODULE_DAILYACTIVITY) {
          setState(() {
            _moduleTitle = 'Daily Activity';
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = DailyActiviyHome(
            listener: this,
            programName: _currentProgramName,
            userType: userType,
          );
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_TRACKER) {
          setState(() {
            _moduleTitle = 'Tracker';
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = TrackerScreen(listener: this);
        } else if (item.actionKey ==
            LocalConstant.MODULE_PENTEMIND_TRACKER_INDENT) {
          setState(() {
            _moduleTitle = 'TRACK ORDER';
          });
          _selectedDestination = MENU_TRACKER_INDENT;
          _currentPentemind =
              TrackerOrderScreen(franchiseeId: francinseeId.toString());
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_ALMANAC) {
          setState(() {
            _moduleTitle = item.actionKey;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind =
              ParentAlmanac(listener: this, term: _curriculamTern);
        } else if (item.actionKey ==
            LocalConstant.MODULE_PARENT_PARENT_PENTEMIND_PROCESS) {
          setState(() {
            _moduleTitle = item.actionKey;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind =
              PentemindProgress(listener: this, term: _curriculamTern);
        } else if (item.actionKey ==
            LocalConstant.MODULE_PARENT_PARENT_HOMEWORK) {
          setState(() {
            _moduleTitle = item.actionKey;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = MyHomeworkScreen(
            isToolbar: false,
          );
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_PARENT_ELG) {
          setState(() {
            _moduleTitle = item.actionKey;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = ElgScreen();
        } else if (item.actionKey == LocalConstant.MODULE_PARENT_PARENT_ARTSY) {
          setState(() {
            _moduleTitle = item.actionKey;
          });
          _selectedDestination = PENTEMIND_LEARNING_GOAL;
          _currentPentemind = const ParentArtsyScreen();
        } else {
          _selectedDestination = action;
          //_pentemindModuleUrl = LocalConstant.PENTEMIND_URL+"/"+item.actionKey;
          _pentemindModuleUrl =
              'https://www.google.com/search?q=${item.actionKey}';
        }
      });
    } else if (action == LocalConstant.MENU_MYCALSS_ANNOUNANCEMENT) {
      setState(() {
        _selectedDestination = PENTEMIND_LEARNING_GOAL;
        _currentPentemind = AnnoucementListScreen();
      });
    } else if (action == LocalConstant.MENU_MYCLASS_PARENT_NOTE) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParentNoteScreen(isToolbar: true),
        ),
      );
    } else if (action == LocalConstant.MENU_MYCLASS_LEAVE_RECORD) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LeaveRecordScreen(
                  isAppbar: true,
                )),
      );
    } else if (action == LocalConstant.MENU_LG_CHILD_ADVANCEMENT) {
      setState(() {
        _selectedDestination = PENTEMIND_LEARNING_GOAL;
        _currentPentemind = const ChildsAdvancementScreen();
      });
    }
  }

  void updateTitle(String title) {
    setState(() {
      _moduleTitle = title;
    });
  }

  ///menu

  Widget introGrid() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: mMaterials
                      .map(
                        (item) => Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: GestureDetector(
                            onTap: () async {
                              //debugPrint(item.ThumbnailURL);
                              if (item.MediaType == 'mp4') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayer(
                                      path: item.WebUrl,
                                      Title: item.ContentDescription,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(item.ThumbnailURL),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isKES() {
    return _curriculamType.isNotEmpty &&
                _curriculamType.toLowerCase() == 'k12' ||
            _curriculamType.toLowerCase() == 'kes'
        ? true
        : false;
  }

  void generateFilteredMenu() {
    debugPrint(
        '-----generate Filterd menus. $_curriculamType $_curriculamTern - $ayId');
    if (_curriculamType.isNotEmpty && _curriculamType.toLowerCase() == 'k12' ||
        _curriculamType.toLowerCase() == 'kes') {
      AppAssets.APP_BACKGROUND = AppAssets.KES_APP_BACKGROUND;
      generateK12Dashboard();
    } else {
//       debugPrint('Normal Menu');
      AppAssets.APP_BACKGROUND = AppAssets.KIDZEE_APP_BACKGROUND;
      generatePentemindMenu();
    }
  }

  void generatePentemindMenu() {
    pentemindMenus.clear();
    if (userType == 'P') {
      if (_className.contains('MDTR')) {
        addPentemindActivity();

        addFunActivity();
      } else {
        addAlmanac();
        addLearningMaterial();

        addLearningMaterialForNepal();

        addPentemindProgress();
        addHomework();
        addElg();
        addArtsy();
      }

      addParentSamyuj();
    } else if (userType == 'NBM' ||
        userType == 'KAM' ||
        userType == 'RSD' ||
        userType == 'AM' ||
        userType == 'ZM' ||
        userType == 'ZAH' ||
        userType == 'PMACAD' ||
        userType == 'RM' ||
        userType == 'TM') {
      addFacilatorTool();
      addLearningMaterial();

      addLearningMaterialForNepal();
    } else {
      if ((userType == 'TEACH' || userType == 'SRTEA') &&
          _className.contains('MDTR')) {
        addFacilatorTool();
        addPentemindActivity();

        addFunActivity();
      } else {
        addTrackerMenu();
        addMyClass();
        addFacilatorTool();
        addLearningGoal();
        addDailyActivity();
        addReports();
        addLearningMaterial();
        addLearningMaterialForNepal();
        addParentCorner();
      }
    }
    addParentSupportDesk();
    addZllCelibrationDay();
    addParentIndentTracker();
    addZllSaathi();

    //iteraton -1 removeq
    // pentemindMenus.add(PentemindItem(
    //     MENU_OCTAVE,
    //     LocalConstant.MODULE_LITERANOVA_OCTAVE,
    //     LocalConstant.MODULE_LITERANOVA_OCTAVE,
    //     'assets/icons/litera_octave.png'));

    //generateK12Dashboard();
  }

  void addAlmanac() {
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_PARENT_ALMANAC,
        LocalConstant.MODULE_PARENT_ALMANAC,
        LocalConstant.MODULE_PARENT_ALMANAC,
        'assets/icons/ic_announancement.png',
      ),
    );
  }

  void addPentemindProgress() {
    // if(_curriculamTern.isNotEmpty && _curriculamTern==LocalConstant.TERM_EARLY){
    //   return;
    // }
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_PARENT_PENTEMIND_PROCESS,
        LocalConstant.MODULE_PARENT_PARENT_PENTEMIND_PROCESS,
        LocalConstant.MODULE_PARENT_PARENT_PENTEMIND_PROCESS,
        'assets/icons/ic_pentemindprogress.png',
      ),
    );
  }

  void addHomework() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_DAILY_HOMEWORK,
        LocalConstant.MODULE_PARENT_PARENT_HOMEWORK,
        LocalConstant.MODULE_PARENT_PARENT_HOMEWORK,
        'assets/icons/ic_homework.png',
      ),
    );
  }

  void addElg() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_ELG,
        LocalConstant.MODULE_PARENT_PARENT_ELG,
        LocalConstant.MODULE_PARENT_PARENT_ELG,
        'assets/icons/ic_elg.png',
      ),
    );
  }

  void addArtsy() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_ARTSY,
        LocalConstant.MODULE_PARENT_PARENT_ARTSY,
        LocalConstant.MODULE_PARENT_PARENT_ARTSY,
        'assets/icons/ic_artsy.png',
      ),
    );
  }

  void addParentSamyuj() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        10,
        LocalConstant.MODULE_PARENT_SAMYUJ,
        LocalConstant.MODULE_PARENT_SAMYUJ,
        'assets/icons/ic_celibration.png',
      ),
    );
  }

  void addPentemindActivity() {
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_PARENT_PENTEMIND_ACTIVITY,
        LocalConstant.MODULE_PENTEMIND_ACTIVITY,
        LocalConstant.MODULE_PENTEMIND_ACTIVITY,
        'assets/icons/ParentsCorner.png',
      ),
    );
  }

  void addFunActivity() {
    pentemindMenus.add(
      PentemindItem(
        LocalConstant.MENU_PARENT_PENTEMIND_FUN_ACTIVITY,
        LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
        LocalConstant.MODULE_PENTEMIND_FUN_ACTIVITY,
        'assets/icons/ParentsCorner.png',
      ),
    );
  }

  void addTrackerMenu() {
    pentemindMenus.add(
      PentemindItem(
        1,
        LocalConstant.MODULE_PARENT_TRACKER,
        'Tracker',
        'assets/icons/tracker.png',
      ),
    );
  }

  void addMyClass() {
    pentemindMenus.add(
      PentemindItem(
        2,
        'My Class',
        'attendance',
        'assets/icons/ic_attendance.png',
      ),
    );
  }

  void addFacilatorTool() {
    pentemindMenus.add(
      PentemindItem(
        3,
        'Facilitator Tools',
        LocalConstant.MODULE_FACILATORTOOL,
        'assets/icons/ic_facilitatortools.png',
      ),
    );
  }

  void addLearningGoal() {
    pentemindMenus.add(
      PentemindItem(
        4,
        'Learning Goals',
        'learninggoals',
        'assets/icons/ic_learninggoals.png',
      ),
    );
  }

  void addZllSaathi() {
    if (userType == 'SRTEA' ||
            //    userType == 'P' ||
            userType == 'F'
        /* Remomve Teacher and CC no data available to create ticker
            userType == 'TEACH' ||
            userType == 'CM' ||
            userType == 'CC'

        16th May
        As per group discusstion we restrict the Internal Users on kidzee
        and they only use Intranet App
        */
        // userType == 'AM' ||
        // userType == 'TM' ||
        // userType == 'ZAH' ||
        // userType == 'ZM' ||
        // userType == 'RM' ||
        // userType == 'PMACAD' ||
        ) {
      pentemindMenus.add(
        PentemindItem(
          LocalConstant.MENU_ZLLSARTHI,
          LocalConstant.MODULE_ZLLSARTHI,
          LocalConstant.MODULE_ZLLSARTHI,
          'assets/icons/ic_datacollection.png',
        ),
      );
    }
  }

  void addParentIndentTracker() {
    if (userType == 'F') {
      pentemindMenus.add(
        PentemindItem(
          36,
          LocalConstant.MODULE_PENTEMIND_TRACKER_INDENT,
          LocalConstant.MODULE_PENTEMIND_TRACKER_INDENT,
          'assets/icons/ic_trackerIndent.png',
        ),
      );
    }
  }

  void addZllCelibrationDay() {
    debugPrint('_curriculamType $_curriculamTern');
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    if (userType == 'F' ||
        userType == 'TEACH' ||
        userType == 'CC' ||
        userType == 'CM' ||
        userType == 'SRTEA') {
      pentemindMenus.add(
        PentemindItem(
          10,
          LocalConstant.MODULE_CELIBRATION_DAY,
          LocalConstant.MODULE_CELIBRATION_DAY,
          'assets/icons/ic_celibration.png',
        ),
      );
    }
  }

  void addParentSupportDesk() {
    if (AppFlavor == 'kidzee' &&
        (userType == 'P' ||
            userType == 'F' ||
            userType == 'TEACH' ||
            userType == 'CC' ||
            userType == 'CM' ||
            userType == 'SRTEA')) {
      pentemindMenus.add(
        PentemindItem(
          9,
          LocalConstant.MODULE_PARENT_SUPPORT_DESK,
          LocalConstant.MODULE_PARENT_SUPPORT_DESK,
          'assets/icons/ic_chat.png',
        ),
      );
    }
  }

  void addParentCorner() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        8,
        'Parents Corner',
        LocalConstant.MODULE_PARENT_CORNER,
        'assets/icons/ic_parentscorner.png',
      ),
    );
  }

  void addLearningMaterialForNepal() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    if ((userType == 'F' ||
            userType == 'TEACH' ||
            userType == 'CC' ||
            userType == 'CM' ||
            //userType == 'P' || as per dolly mail in May 26 we remove the parent access for learning material in Nepal
            userType == 'SRTEA') &&
        country.isNotEmpty &&
        country.toLowerCase() == 'nepal') {
      pentemindMenus.add(
        PentemindItem(
          LocalConstant.MENU_LEARNING_GOAL_NEPAL,
          LocalConstant.MODULE_NEPAL_LEARNING_RESOURCE,
          LocalConstant.MODULE_LEARNING_MATERIAL_NEPAL,
          'assets/icons/ic_learningmaterials.png',
        ),
      );
    }
    // if (country.isNotEmpty && country.toLowerCase() == 'nepal') {
    //   pentemindMenus.add(
    //     PentemindItem(
    //       LocalConstant.MENU_LEARNING_GOAL_NEPAL,
    //       LocalConstant.MODULE_NEPAL_LEARNING_RESOURCE,
    //       LocalConstant.MODULE_LEARNING_MATERIAL_NEPAL,
    //       'assets/icons/ic_learningmaterials.png',
    //     ),
    //   );
    // }
  }

  void addLearningMaterial() {
    pentemindMenus.add(
      PentemindItem(
        7,
        'Learning Materials',
        LocalConstant.MODULE_LEARNING_MATERIAL,
        'assets/icons/ic_learningmaterials.png',
      ),
    );
  }

  void addReports() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        6,
        'Reports ',
        LocalConstant.MODULE_REPORTS,
        'assets/icons/ic_reports.png',
      ),
    );
  }

  void addDailyActivity() {
    if (_curriculamTern.isNotEmpty &&
        _curriculamTern == LocalConstant.TERM_EARLY) {
      return;
    }
    pentemindMenus.add(
      PentemindItem(
        5,
        'Daily Activity',
        LocalConstant.MODULE_DAILYACTIVITY,
        'assets/icons/ic_dailyactivity.png',
      ),
    );
  }

  void generateK12Dashboard() {
    pentemindMenus.clear();
    if (userType.toLowerCase() == 'p') {
      pentemindMenus.add(
        PentemindItem(
          MENU_K12_ALMANAC,
          'Almanac',
          LocalConstant.MODULE_K12_ALMANAC_TOOL,
          'assets/icons/ic_datacollection.png',
        ),
      );
      // pentemindMenus.add(PentemindItem(
      //     MENU_K12_HOMELINK,
      //     LocalConstant.MODULE_K12_HOMELINK_TOOL,
      //     LocalConstant.MODULE_K12_HOMELINK_TOOL,
      //     'assets/icons/ic_datacollection.png'));

      pentemindMenus.add(
        PentemindItem(
          MENU_K12_HOMEWORK,
          LocalConstant.MODULE_K12_HOMEWORK_TOOL,
          LocalConstant.MODULE_K12_HOMEWORK_TOOL,
          'assets/icons/ic_homework.png',
        ),
      );
    } else {
      pentemindMenus.add(
        PentemindItem(
          MENU_K12_MYCLASS,
          LocalConstant.MODULE_K12_MYCLASS,
          LocalConstant.MODULE_K12_MYCLASS,
          'assets/icons/ic_datacollection.png',
        ),
      );

      pentemindMenus.add(
        PentemindItem(
          MENU_K12_LG,
          LocalConstant.MODULE_K12_LG,
          LocalConstant.MODULE_K12_LG,
          'assets/icons/ic_task_inprogress.png',
        ),
      );
      /**
         * As per discussion with Dolly in KES meeting on 17th June- 25
         * Facilator tool required for a month
         */
      if (!LocalConstant.isCognimind) addFacilatorTool();
      //Congnimind changes
      // pentemindMenus.add(
      //   PentemindItem(
      //     MENU_K12_FACILATOR_TOOL,
      //     LocalConstant.MODULE_K12_FACILATOR_TOOL,
      //     LocalConstant.MODULE_K12_FACILATOR_TOOL,
      //     'assets/icons/ic_facilitatortools.png',
      //   ),
      // );
      pentemindMenus.add(
        PentemindItem(
          MENU_K12_HOMEWORK,
          LocalConstant.MODULE_K12_HOMEWORK_TOOL,
          LocalConstant.MODULE_K12_HOMEWORK_TOOL,
          'assets/icons/ic_homework.png',
        ),
      );

      // pentemindMenus.add(PentemindItem(
      //     MENU_K12_LEARNINGRESOURCE,
      //     LocalConstant.MODULE_K12_LEARNINGRESOURCE_TOOL,
      //     LocalConstant.MODULE_K12_LEARNINGRESOURCE_TOOL,
      //     'assets/icons/ic_learningmaterials.png'));
    }
    // pentemindMenus.add(PentemindItem(
    //     MENU_K12_REPORT_LG,
    //     LocalConstant.MODULE_K12_REPORTS,
    //     LocalConstant.MODULE_K12_REPORTS,
    //     'assets/icons/ic_datacollection.png'));

    /* pentemindMenus.add(PentemindItem(
        MENU_K12_LOGBOOK,
        LocalConstant.MODULE_K12_LOGBOOK,
        LocalConstant.MODULE_K12_LOGBOOK,
        'assets/icons/ic_linechart.png')); */

    pentemindMenus.add(
      PentemindItem(
        MENU_K12_HPCREPORT,
        LocalConstant.MODULE_K12_HPCREPORT_TOOL,
        LocalConstant.MODULE_K12_HPCREPORT_TOOL,
        'assets/icons/ic_linechart.png',
      ),
    );

    pentemindMenus.add(
      PentemindItem(
        MENU_OCTAVE,
        MODULE_LITERANOVA_OCTAVE(localAcademicYearID),
        MODULE_LITERANOVA_OCTAVE(localAcademicYearID),
        'assets/icons/litera_octave.png',
      ),
    );
  }

  String MODULE_LITERANOVA_OCTAVE(int acyid) =>
      localAcademicYearID >= 26 && isKES()
          ? /* 'Cognimind' */ 'Learning Pathways'
          : 'Learning Pathways';

  List<LearningMaterialModel> mMaterials = [];
  Future<void> getMaterials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? "0";
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    if (_className.contains('MDTR')) {
      int programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
      if (mMaterials.isNotEmpty) {
        generateFilteredMenu();
      } else {
        mMaterials.clear();
        LearningMaterialRequest request = LearningMaterialRequest(
          ProgramID: programId.toString(),
          D: '-1',
          ContentCategory: 'Intro',
          UserID: uid.toString(),
        );
        APIService apiService = APIService();
        apiService.getLearningMaterials(request, false, token).then((value) {
          if (value != null) {
            isLoading = false;
            if (value == null) {
              Utility.showMessage(context, 'data not found');
            } else if (value is LearningMaterialResponse) {
              LearningMaterialResponse response = value;
              generateFilteredMenu();
              mMaterials.clear();
              mMaterials.addAll(response.data.mateialList);
              setState(() {});
            } else {
              Utility.showMessage(context, 'data not found');
            }
          }
          setState(() {});
        });
      }
    }
  }

  Future<void> updateToken() async {}

  @override
  void onError(int action, value) {
    // TODO: implement onError
  }

  @override
  void onResponseStart() {
    // TODO: implement onResponseStart
  }
  ZllResourceResponse? mEventModel;
  @override
  void onSuccess(value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getString(LocalConstant.KEY_DEEPLINK_URL) != null) {
      final rawLink = sp.getString(LocalConstant.KEY_DEEPLINK_URL) ?? '';
      final resolvedLink = Utility.resolveDynamicUserPlaceholders(
        rawLink,
        userId: userId,
        uid: uid,
        displayName: displayName,
        userName: userName,
      );
      deepLinkCommonFunction(Uri.tryParse(resolvedLink));
      sp.remove(LocalConstant.KEY_DEEPLINK_URL);
    }
    debugPrint('OnSuccess is - ${widget.type}');

    if (widget.status != null) {
      widget.status == 'false'
          ? onClick(
              LocalConstant.ACTION_PENTEMIND_MODULE,
              PentemindItem(
                3,
                'Facilitator Tools',
                LocalConstant.MODULE_FACILATORTOOL,
                'assets/icons/ic_facilitatortools.png',
                logbookDay: widget.day,
                logbookProgramId: widget.programId,
                hiveIndex: 0,
              ),
            )
          : onClick(
              LocalConstant.ACTION_PENTEMIND_MODULE,
              PentemindItem(
                4,
                'Learning Goals',
                'learninggoals',
                'assets/icons/ic_learninggoals.png',
                logbookDay: widget.day,
                logbookProgramId: widget.programId,
                hiveIndex: 0,
              ),
            );
    }
    // _initURIHandler();
    if (value is ZllResourceResponse) {
      ZllResourceResponse eventModel = value;
      mEventModel = eventModel;
      debugPrint('Event Model is - ${eventModel.data.length}');
      if (eventModel.data.isNotEmpty) {
        if (eventModel.data[0].eventId == 1) {
          if (userType == 'F' ||
              userType == 'TEACH' ||
              userType == 'CC' ||
              userType == 'P' ||
              userType == 'CM' ||
              userType == 'SRTEA') {
            final resolvedContentUrl = Utility.resolveDynamicUserPlaceholders(
              eventModel.data[0].contenturl,
              userId: userId,
              uid: uid,
              displayName: displayName,
              userName: userName,
            );
            PromoNotification.displayCustomPromoNotification(
              'Teachers Day Celebration',
              '',
              '',
              resolvedContentUrl,
              userType == 'TEACH' ||
                      userType == 'SRTEA' ||
                      userType == 'CC' ||
                      userType == 'CM'
                  ? displayName
                  : '',
              userType == 'TEACH' ||
                      userType == 'SRTEA' ||
                      userType == 'CC' ||
                      userType == 'CM'
                  ? 'assets/events/kidzee_teachers_day_greeting.jpg'
                  : userType == 'F'
                      ? 'assets/events/kidzee_franchise.jpg'
                      : 'assets/events/parent_greeting.jpg',
            );
          }
        } else {
          for (var event in eventModel.data) {
            if (event.visibleTo.isEmpty || event.visibleTo == userType) {
              final resolvedUrl = Utility.resolveDynamicUserPlaceholders(
                event.contenturl,
                userId: userId,
                uid: uid,
                displayName: displayName,
                userName: userName,
              );
              final resolvedEvent = CelibrationModel(
                eventId: event.eventId,
                title: event.title,
                validfrom: event.validfrom,
                validto: event.validto,
                contenturl: resolvedUrl,
                viewurl: Utility.resolveDynamicUserPlaceholders(
                  event.viewurl,
                  userId: userId,
                  uid: uid,
                  displayName: displayName,
                  userName: userName,
                ),
                displayIn: event.displayIn,
                visibleTo: event.visibleTo,
              );
              KidzeeBottomSheet().showBSPromo(context, resolvedEvent, this);
            }
          }
          //KidzeeBottomSheet().showBSPromo(context, eventModel.data[0], this);
        }
      }
    } else {
      updateToken();
    }
  }

  void switchUser(String userName, String password) {
    Utility.showAlertDialog(context, "User swirch for $userName $password");
  }

  void deepLinkCommonFunction(Uri? initialURI) async {
    if (initialURI == null) return;

    final resolvedRaw = Utility.resolveDynamicUserPlaceholders(
      initialURI.toString(),
      userId: userId,
      uid: uid,
      displayName: displayName,
      userName: userName,
    );
    final resolvedUri = Uri.tryParse(resolvedRaw) ?? initialURI;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint(
      'udid from deep linkk is - ${resolvedUri.path.split('/').elementAt(1)}',
    );
    if (resolvedUri.path.contains('open')) {
    } else if (resolvedUri.toString().contains('kidzeeapp://login/')) {
      switchUser(
        resolvedUri.queryParameters['username'].toString(),
        resolvedUri.queryParameters['password'].toString(),
      );
    } else if (resolvedUri.toString().contains('kidzeeapp')) {
      ZllTicket(
        context,
        resolvedUri.queryParameters['id']!,
        resolvedUri.queryParameters['b_id']!,
        resolvedUri.queryParameters['bu_id']!,
        resolvedUri.queryParameters['u_id']!.replaceAll('.', ''),
        kPrimaryLightColor,
      );
    } else if (resolvedUri.toString().contains(
          'zllsaathi.zeelearn.com/ticketDetail',
        )) {
      ZllTicket(
        context,
        resolvedUri.queryParameters['id']!,
        resolvedUri.queryParameters['b_id']!,
        resolvedUri.queryParameters['bu_id']!,
        resolvedUri.queryParameters['u_id']!.replaceAll('.', ''),
        kPrimaryLightColor,
      );
    } else if (resolvedUri.path.split('/').elementAt(1) != uid) {
      // if (!mounted) return;
      // showAdaptiveDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text('warning'),
      //       content: Text(
      //         'This Link is not valid for this User. ${initialURI.path}',
      //       ),
      //       actions: [
      //         ElevatedButton(
      //           onPressed: () => Navigator.pop(context),
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else if (resolvedUri.path.contains(DeepLinkingConstants.parentHomeWork)) {
      _moduleTitle = LocalConstant.MODULE_PARENT_PARENT_HOMEWORK;
      _selectedDestination = PENTEMIND_LEARNING_GOAL;
      var finalURl = resolvedUri.path.split('/');

      //debugPrint('Delay after launch from deep link is - $initialURI');
      _currentPentemind = MyHomeworkScreen(
        isToolbar: false,
        homeworkId: finalURl.last,
        programId: int.parse(finalURl.elementAt(4)),
      );

      setState(() {});
    } else if (resolvedUri.path.contains(
          DeepLinkingConstants.learningGoalDaily,
        ) ||
        resolvedUri.path.contains(DeepLinkingConstants.learningGoalTeacher)) {
      if (!mounted) {
        return;
      }

      var finalURl = Uri.decodeFull(resolvedUri.path).split('/');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DevelopmentalFeedback(
            model: LearningGoal(
              D: int.parse(finalURl.elementAt(4)),
              LGDID: int.parse(finalURl.elementAt(6)),
              SessionID: 0,
              SessionName: '',
              DomainID: 0,
              DomainName: '',
              SkillID: 0,
              SkillName: '',
              LearningGoals: finalURl.elementAt(7),
              tlg: [],
              ObservationType: '',
            ),
            day: int.parse(finalURl.elementAt(4)),
            observation: finalURl.elementAt(5),
            deepLinkingEnabled: true,
            listener: this,
          ),
        ),
      );
    } else if (resolvedUri.path.contains(DeepLinkingConstants.notification)) {
      if (!mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => goToUserNotification()),
      );
    } else if (resolvedUri.path.contains(DeepLinkingConstants.homework)) {
      _moduleTitle = LocalConstant.MODULE_PARENT_PARENT_HOMEWORK;
      _selectedDestination = PENTEMIND_LEARNING_GOAL;
      var finalURl = resolvedUri.path.split('/');

//       debugPrint('Delay after launch from deep link is - $initialURI');
      _currentPentemind = MyHomeworkScreen(
        isToolbar: false,
        culminationId: finalURl.last,
        programId: int.parse(finalURl.elementAt(1)),
      );

      setState(() {});
    } else if (resolvedUri.path.contains(DeepLinkingConstants.learningGoals)) {
      _moduleTitle = 'Learning Goals';

      var finalURl = Uri.decodeFull(resolvedUri.path).split('/');

      log('Decoded url string list is - $finalURl');

      _selectedDestination = PENTEMIND_LEARNING_GOAL;
      _currentPentemind = PentemindLearningGoal(
        listener: this,
        term: _curriculamTern,
        deepLinkingEnabled: true,
        page: resolvedUri.path.contains('dev') ? 'dev' : 'add',
        day: finalURl.length >= 4 ? finalURl.elementAt(3) : '1',
        observation: finalURl.length >= 5 ? finalURl.elementAt(4) : null,
        session: finalURl.length >= 6 ? finalURl.elementAt(5) : null,
      );
      setState(() {});
    } else if (resolvedUri.path.contains(DeepLinkingConstants.logBook)) {
      _moduleTitle = 'Facilitator Tools';

      _selectedDestination = PENTEMIND_LEARNING_GOAL;
      _currentPentemind = FacilatorSaysHome(
          term: _curriculamTern, isKes: isKES(), listener: this);
      setState(() {});
    } else if (resolvedUri.path.contains(DeepLinkingConstants.dailyActivity)) {
      var finalURl = resolvedUri.path.split('/');
      _moduleTitle = 'Daily Activity';
      _selectedDestination = PENTEMIND_LEARNING_GOAL;
      _currentPentemind = DailyActiviyHome(
        listener: this,
        programName: _currentProgramName,
        userType: userType,
        deepLinkingEnabled: true,
        pageType: finalURl[3],
        programId: finalURl[4],
        day: finalURl[5],
      );
      setState(() {});
    } else if (resolvedUri.path.contains(DeepLinkingConstants.myClass)) {
      _moduleTitle = 'My Class';
      _selectedDestination = PENTEMIND_LEARNING_GOAL;

      _currentPentemind = MyClassModule(
        listener: this,
        culminationModel: CuminationDayModel(
          Cid: 1,
          CName: 'cNAME',
          AttendanceDate: '',
          D: 1,
          W: 1,
          IsDisabled: false,
        ),
      );
      setState(() {});
    } else {
      log('Else part is getting called of deep link - $resolvedUri');
    }
  }
}
