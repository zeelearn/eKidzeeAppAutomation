import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ekidzee/api/ServiceHandler.dart';
import 'package:ekidzee/firebase_options.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/model/user_model.dart';
import 'package:ekidzee/pages/feedback/survery_hive_model/survey_model.dart';
import 'package:ekidzee/pages/home/home_screen.dart';
import 'package:ekidzee/pages/intro/splash.dart';
import 'package:ekidzee/pages/login/ui2/login.dart';
import 'package:ekidzee/pages/notification/NotificationService.dart';
import 'package:ekidzee/pages/notification/UserNotification.dart' /* deferred as userNotification */;
import 'package:ekidzee/pages/pentemind/module/homework/homework_home.dart';
import 'package:ekidzee/pages/tracker_indent/TrackerOrderCubit/tracker_order_cubit.dart';
import 'package:ekidzee/pushNotification/PushNotificationSetup.dart';
import 'package:ekidzee/videoplayer/VideoPlayer.dart' /* deferred as videoPlayer */;
import 'package:ekidzee/widget/MyWebSiteView.dart' /* deferred as mywebsiteview */;
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:literaoctave/core/octave.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:saathi/zllsaathi.dart' /* deferred as zllsaathi */;
import 'package:shared_preferences/shared_preferences.dart';

import 'Environment.dart';
import 'api/APIService.dart';
import 'api/request/bpms/insert_attachment.dart';
import 'api/request/pentemind/facilatortool/insert_logbook.dart';
import 'api/request/pentemind/file_upload.dart';
import 'api/request/pentemind/learninggoal/AcademicRequest/academic_feedback_request.dart';
import 'api/request/pentemind/learninggoal/developmental/DevelopmentalFeedbackRequest.dart';
import 'api/request/pentemind/myclass/attandance_request.dart';
import 'api/request/pentemind/parent_corner/update_artsy_parent.dart';
import 'api/request/pentemind/update_homework.dart';
import 'api/response/bpms/insert_attachment_response.dart';
import 'api/response/pentemind/GenericResponse.dart';
import 'api/response/pentemind/learninggoals/uploadimage.dart';
import 'api/response/pentemind/parent/elg_stud_response.dart';
import 'app_routes.dart';
import 'constants.dart';
import 'globals.dart';
import 'helper/DBConstant.dart';
import 'helper/DatabaseHelper.dart';
import 'helper/KidzeePref.dart';
import 'helper/utils.dart';
import 'model/parent_info.dart';
import 'pages/home/homeProvider/notificationCountProvider.dart';
import 'pages/home/model/StatusModel.dart';
import 'progressNotification/progressNotification.dart';
import 'pushNotification/promoNotificationDialog.dart';
import 'theme/kidzee_light.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('in main 80 _firebaseMessagingBackgroundHandler ');
  try {
    String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());
    String? imsageUrl = '';
    if (Platform.isAndroid) {
      imsageUrl = message.notification?.android?.imageUrl.toString();
    } else if (Platform.isIOS) {
      imsageUrl = message.notification?.apple?.imageUrl.toString();
    }
    DBHelper helper = DBHelper();
    Map<String, String> data = {};
    if (message.notification != null && message.data == null) {
//       debugPrint('its simple Notification main 91');
      data.putIfAbsent('title', () => message.notification?.title as String);
      data.putIfAbsent(
          'description', () => message.notification?.body as String);
      data.putIfAbsent('type', () => 'push');
      data.putIfAbsent('date', () => cdate);
      data.putIfAbsent('imageurl', () => imsageUrl as String);
      data.putIfAbsent('logoUrl', () => message.data['logo'] as String);
      data.putIfAbsent('bigImageUrl', () => message.data['bigimage'] as String);
      data.putIfAbsent('webViewLink', () => message.data['url'] as String);
      helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
      NotificationService notificationService = NotificationService();
      notificationService.showSimpleNotification(
          message.notification?.title as String,
          message.notification?.body as String,
          message);
    } else {
      ///debugPrint('main 109 its data Notification ');
      //debugPrint('its topic Notification ${message.data}');
      if (message.data.containsKey('type') && message.data['type'] == 'chat') {
//         debugPrint('110 main its zllSaathiNotification Notification');
        zllSaathiNotification(message);
      } else if (message.data.containsKey('type') &&
          message.data['type'] == 'td') {
//         debugPrint('110 main its zllSaathiNotification Notification');
        zllSaathiNotification(message);
      } else if (message.data.containsKey('topic') &&
          message.data['topic'] != '') {
        identifyNotification(message);
      } else {
//         debugPrint('main its else topic Notification');
        //showNotification(message);
        NotificationService notificationService = NotificationService();
        notificationService.showSimpleNotification(
            message.data['title'], message.data['body'], message);
      }
    }
  } catch (e) {
    debugPrint('error in main 126 ${e.toString()}');
  }
}

void zllSaathiNotification(RemoteMessage message, [WidgetRef? ref]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (AppFlavor == null) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    if (packageInfo.packageName == 'com.zeelearn.ekidzee') {
      environmentType = EnvironmentType.KIDZEE;
      AppFlavor = 'kidzee';
    } else {
      AppFlavor = 'mlzs';
      environmentType = EnvironmentType.MLZS;
    }
  }
  String userName = AppFlavor == 'kidzee'
      ? prefs.containsKey(LocalConstant.KEY_UID)
          ? prefs.getString(LocalConstant.KEY_UID) as String
          : ''
      : prefs.containsKey(LocalConstant.KEY_USER_NAME)
          ? prefs.getString(LocalConstant.KEY_USER_NAME) as String
          : '';
  debugPrint(
      'Saathi User Name is $userName for $AppFlavor  and Kidzee ${message.data['user_id']}');
  if (userName.isNotEmpty) {
    if (message.data.containsKey('business_user_id') &&
            message.data['business_user_id'] == userName ||
        message.data.containsKey('user_id') &&
            message.data['user_id'] == userName) {
//       debugPrint('Algo matched=====');
      if (kIsWeb) {
        Get.snackbar(
          message.data['title'], // Title
          message.data['body'], // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: kPrimaryLightColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        showNotification(message, ref);
      }
    }
  }
}

void identifyNotification(RemoteMessage message, [WidgetRef? ref]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  LoginData? userProfile = await KidzeePref().getLoginResponse();
  if (userProfile == null) {
    return;
  }
  String userName = userProfile.userName!;
  String userId = userProfile.userId!;
  String userType = userProfile.userType!;
  String franchiseeId = userProfile.franchiseeId!.toString();
  List<String> franchiseeIdList = ['0', franchiseeId.toString()];

//     debugPrint('franchisee ID 169 is $franchiseeId $userId $userType');
  List<String> userIdList = ['0', userId.toString()];
  List<String> userTypeList = ['0', userType];
  List<String> classIdList = ['0'];
  late ParentInfo parentInfo;
  try {
    if (userProfile.program!.isNotEmpty) {
      //debugPrint('Login Reponse $loginReposne');

      for (int index = 0; index < userProfile.program!.length; index++) {
        classIdList.add(userProfile.program![index].classId.toString());
      }
    }
  } catch (e) {}
  if (userType == 'P') {
    try {
      parentInfo = await DBHelper().getParentInfo();
      classIdList.add(parentInfo.classId.toString());
    } catch (e) {
//         debugPrint('EWrror in 198 ${e.toString()}');
    }
  }
//     debugPrint('class Id');
  // debugPrint(classIdList);
  // debugPrint('topic is ');
  String topic = message.data['topic'];
  for (int index = 0; index < franchiseeIdList.length; index++) {
    for (int jIndex = 0; jIndex < userIdList.length; jIndex++) {
      for (int kIndex = 0; kIndex < userTypeList.length; kIndex++) {
        for (int lIndex = 0; lIndex < classIdList.length; lIndex++) {
          String generatedTopic =
              '${franchiseeIdList[index]}_${userIdList[jIndex]}_${userTypeList[kIndex]}_${classIdList[lIndex]}';
          //debugPrint('topic is ${generatedTopic}');
          if (generatedTopic == topic) {
            debugPrint('Algo matched=====');
            if (kIsWeb) {
              Get.snackbar(
                message.data['title'], // Title
                message.data['body'], // Message
                snackPosition: SnackPosition.BOTTOM, // Position
                backgroundColor: kPrimaryLightColor,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
              );
            } else {
              showNotification(message, ref);
            }
            break;
          } else {
            //debugPrint('Algo not matched=====${generatedTopic} vs ${topic}');
          }
        }
      }
    }
  }
}

Future<String> _resolveNotificationUrl(RemoteMessage message) async {
  final rawUrl = message.data.containsKey('url')
      ? (message.data['url'] ?? '').toString()
      : (message.data.containsKey('webViewLink')
          ? (message.data['webViewLink'] ?? '').toString()
          : '');

  if (rawUrl.isEmpty) {
    return rawUrl;
  }

  return Utility.resolveUserPlaceholdersFromSession(rawUrl);
}

Future<void> showNotification(RemoteMessage message, WidgetRef? ref) async {
  String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());
  final resolvedUrl = await _resolveNotificationUrl(message);
  final resolvedId = await Utility.resolveUserPlaceholdersFromSession(
    (message.data['id'] ?? '').toString(),
  );
  final resolvedActionUrl = await Utility.resolveUserPlaceholdersFromSession(
    (message.data['actionUrl'] ?? '').toString(),
  );
  final resolvedWebViewLink =
      await Utility.resolveUserPlaceholdersFromSession(
    (message.data['webViewLink'] ?? '').toString(),
  );

  if (!kIsWeb) {
    DBHelper helper = DBHelper();
    Map<String, String> data = {};
    data.putIfAbsent(
        'title',
        () => message.data['type'] == 'td'
            ? ' ${message.data['title'] as String}'
            : message.data['title'] as String);
    data.putIfAbsent(
        'description',
        () => message.data.containsKey('body')
            ? message.data['body'] as String
            : '');
    data.putIfAbsent(
        'type',
        () => message.data.containsKey('type')
            ? message.data['type'] as String
            : '');
    data.putIfAbsent('date', () => cdate);
    data.putIfAbsent('imageurl', () => resolvedUrl);
    data.putIfAbsent(
        'logoUrl',
        () => message.data.containsKey('logo')
            ? message.data['logo'] as String
            : '');
    data.putIfAbsent(
        'bigImageUrl',
        () => message.data.containsKey('bigimage')
            ? message.data['bigimage'] as String
            : '');
    data.putIfAbsent(
        'webViewLink',
        () => message.data['type'] == 'td' || message.data['type'] == 'chat'
            ? resolvedId
            : (resolvedWebViewLink.isNotEmpty
                ? resolvedWebViewLink
                : resolvedUrl));
    helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
  }
  var count = (int.parse(
          await KidzeePref().getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
              '0') +
      1);
  KidzeePref()
      .setString(LocalConstant.KEY_NOTIFICATION_COUNT, count.toString());
  KidzeePref().setString(LocalConstant.KEY_SHOWNOTIFICATION_COUNT, 'true');
  if (ref != null) {
    ref.read(countProvider.notifier).update((state) => count);
  }

  if (kIsWeb) {
    Get.snackbar(
      message.data['title'], // Title
      message.data['body'], // Message
      snackPosition: SnackPosition.BOTTOM, // Position
      backgroundColor: kPrimaryLightColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  } else {
    NotificationService notificationService = NotificationService();
    // Pass pre-resolved url/id/actionUrl so notification tap payload has real IDs.
    final resolvedData = Map<String, dynamic>.from(message.data);
    if (resolvedUrl.isNotEmpty) {
      resolvedData['url'] = resolvedUrl;
    }
    if (resolvedId.isNotEmpty) {
      resolvedData['id'] = resolvedId;
    }
    if (resolvedActionUrl.isNotEmpty) {
      resolvedData['actionUrl'] = resolvedActionUrl;
    }
    if (resolvedWebViewLink.isNotEmpty) {
      resolvedData['webViewLink'] = resolvedWebViewLink;
    }
    final resolvedMessage = RemoteMessage(
      senderId: message.senderId,
      category: message.category,
      collapseKey: message.collapseKey,
      contentAvailable: message.contentAvailable,
      data: resolvedData.map((k, v) => MapEntry(k, v?.toString() ?? '')),
      from: message.from,
      messageId: message.messageId,
      messageType: message.messageType,
      mutableContent: message.mutableContent,
      notification: message.notification,
      sentTime: message.sentTime,
      threadId: message.threadId,
      ttl: message.ttl,
    );

    if (message.data.containsKey('bigimage') &&
        (message.data['bigimage'] != null &&
            message.data['bigimage'].toString().isNotEmpty)) {
      notificationService.showBigNotification(
          message.data['title'],
          message.data['body'],
          message.data['logo'] ?? '',
          message.data['bigimage'],
          message.data['showBigText'] == 'true' ? true : false,
          resolvedMessage);
    } else {
      notificationService.showSimpleNotification(
          message.data['title'], message.data['body'], resolvedMessage);
    }
  }
}

late FirebaseMessaging messaging;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool _initialURILinkHandled = false;

Future<void> setupRemoteConfig() async {
  if (!kIsWeb) {
    try {
//       debugPrint('remote config get -----------------');
      /*final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await remoteConfig.setDefaults(const {
        "pentemind_api": "https://pentemind.com"
      });
      await remoteConfig.fetchAndActivate();

      remoteConfig.onConfigUpdated.listen((event) async {
//         debugPrint('api changes....');
        await remoteConfig.activate();
        String newapi = remoteConfig.getString("pentemind_api");
        LocalStrings.pentemindapi = newapi;
        debugPrint(LocalStrings.pentemindapi);
//         debugPrint('updated api is ${newapi}');
        updateBaseUrl(newapi);
        // Use the new config values here.
      });*/
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

void updateBaseUrl(String url) {
  final box = Hive.box(LocalConstant.base);
  box.put(LocalConstant.KEY_BASE_URL, url);
}

void getBaseUrl() {
  if (!kIsWeb) {
//     debugPrint('getAPI-------------');
    final box = Hive.box(LocalConstant.base);
    var baseUrl = box.get(LocalConstant.KEY_BASE_URL);
    if (baseUrl != null && baseUrl.toString().isNotEmpty) {
      LocalStrings.pentemindapi = baseUrl.toString();
//       debugPrint('=========getBaseUrl ${LocalStrings.pentemindapi}');
    }
  }
}

final localhostServer = InAppLocalhostServer(
  documentRoot: 'assets',
  port: 58080, // Changed from 8080 to avoid common conflicts
);

//final localhostServer = InAppLocalhostServer(documentRoot: 'assets');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* This is for iphone 17 Pro max crashing fix. */
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //configure Oatave

  //await Octave().initFlavor(octave.AppFlavor.congnimind.name);
  await Octave().init();
  // Initialize PDFRx for Flutter (important for WebAssembly support)
  if (kIsWeb)
    pdfrxFlutterInitialize();
  else {
    // Native (Android/iOS/desktop) → must set cache dir
    final dir = await getTemporaryDirectory();
    Pdfrx.cacheDirectoryPath = dir.path;
  }

  // if (kReleaseMode) {
  //   debugPrint = (String? message, {int? wrapWidth}) {};
  // }

  if (!kIsWeb) {
    try {
      await localhostServer.start();
    } catch (e) {
      debugPrint('Localhost server failed to start: $e');
    }
  }
  if (!kIsWeb) {
    setupRemoteConfig();
    await FlutterDownloader.initialize(
        debug:
            false, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            false // option: set to false to disable working with http links (default: false)
        );
    // Set the background messaging handler early on, as a named top-level function
    await NotificationController.initializeLocalNotifications();
    await NotificationController.initializeIsolateReceivePort();
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      if (packageInfo.packageName == 'com.zeelearn.ekidzee') {
        environmentType = EnvironmentType.KIDZEE;
        AppFlavor = 'kidzee';
      } else {
        AppFlavor = 'mlzs';
        environmentType = EnvironmentType.MLZS;
      }
      appVersion = packageInfo.version;
    }
    await initFirebase();
    initBackgroundService();
    DBHelper.initDb();
  } else {
    getFlavors();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await DBHelper.initDb();
    // Utility.initFCM();
  }
  if (!kIsWeb) {
    appVersion = kAppVersion;
    final dbDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(dbDir.path);
  } else {
    await Hive.initFlutter();
  }

  Hive.registerAdapter(StatusModelAdapter());
  Hive.registerAdapter(SurveyModelAdapter());
  await Hive.openBox('feedback');
  await Hive.openBox<SurveyModel>(LocalConstant.surveyBox); // settings
  await Hive.openBox(LocalConstant.logbookStatus); // settings
  await Hive.openBox(LocalConstant.communicationKey); // settings
  await Hive.openBox(LocalConstant.authStorageKey);
  await Hive.openBox(LocalConstant.base);
  await Hive.openBox(LocalConstant.indent);
  await Hive.openBox(LocalConstant.KesKey);
  getBaseUrl();
  handleDeeplink();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  if (kReleaseMode) {
    runZonedGuarded(() {
      runApp(MultiBlocProvider(
          providers: [
            BlocProvider<TrackerOrderCubit>(
              create: (context) => TrackerOrderCubit(),
            ),
          ],
          child: const ProviderScope(
            child: MyApp(),
          )));
    }, (error, stack) {
      FirebaseCrashlytics.instance.log(error.toString());
      runApp(MultiBlocProvider(
          providers: [
            BlocProvider<TrackerOrderCubit>(
              create: (context) => TrackerOrderCubit(),
            ),
          ],
          child: const ProviderScope(
            child: MyApp(),
          )));
    }, zoneSpecification:
        ZoneSpecification(print: (self, parent, zone, message) {
      // Do nothing in release mode
    }));
  } else {
    runApp(MultiBlocProvider(
        providers: [
          BlocProvider<TrackerOrderCubit>(
            create: (context) => TrackerOrderCubit(),
          ),
        ],
        child: const ProviderScope(
          child: MyApp(),
        )));
  }
}

void handleDeeplink() async {
  // await Get.putAsync(() => DeepLinkService().init());
}

Future<void> getPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

//   debugPrint('User granted permission: ${settings.authorizationStatus}');
}

void initBackgroundService() {}

Future<void> initializeService() async {
  /// OPTIONAL, using custom notification channel id
  ///
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(LocalConstant.KEY_USER_ID)) {
    String userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    DBHelper helper = DBHelper();
    List<Map<String, dynamic>> unSyncList = await helper.getUnSyncData(userId);
    if (unSyncList.isNotEmpty) {
      debugPrint(AppFlavor);
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        AppFlavor == 'kidzee'
            ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
            : LocalConstant.NOTIFICATION_CHANNEL_MLZS, // id
        'Kidzee Service', // title
        description:
            'This channel is used to sync Data with Server.', // description
        importance: Importance.low, // importance must be at low or higher level
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            iOS: DarwinInitializationSettings(),
          ),
        );
      }

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
//       debugPrint('FlutterLocalNotificationsPlugin 209 service ================');
      final service = FlutterBackgroundService();
      await service.configure(
        androidConfiguration: AndroidConfiguration(
          autoStartOnBoot: true,
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,

          // auto start service
          autoStart: true,
          isForegroundMode: false,

          notificationChannelId: AppFlavor == 'kidzee'
              ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
              : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
          initialNotificationTitle: '$AppFlavor Application is Running',
          initialNotificationContent: 'Initializing',
          foregroundServiceNotificationId: 0,
        ),
        iosConfiguration: IosConfiguration(
          // auto start service
          autoStart: true,

          // this will be executed when app is in foreground in separated isolate
          onForeground: onStart,

          // you have to enable background fetch capability on xcode project
          onBackground: onIosBackground,
        ),
      );
      if (!await service.isRunning()) {
//         debugPrint('Service is started...');
        service.startService();
      } else {
//         debugPrint('Service is running');
      }
    }
  }
}

Future<String> getFlavors() async {
  String flavor = LocalConstant.NOTIFICATION_CHANNEL_KIDZEE;
  environmentType = EnvironmentType.KIDZEE;
  AppFlavor = 'kidzee';
  return flavor;
//   try {
//     if (kIsWeb) {
//       if (kWebBrand == 'mlzs') {
//         environmentType = EnvironmentType.MLZS;
//         AppFlavor = 'MLZS';
//         flavor = LocalConstant.NOTIFICATION_CHANNEL_MLZS;
// //         debugPrint('App flavor MLZS');
//       } else {
//         environmentType = EnvironmentType.KIDZEE;
//         AppFlavor = 'kidzee';
//         flavor = LocalConstant.NOTIFICATION_CHANNEL_KIDZEE;
// //         debugPrint('App flavor Kidzee');
//       }
//     } else {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       appVersion = packageInfo.version;

//       if (packageInfo.packageName == 'com.zeelearn.ekidzee') {
//         environmentType = EnvironmentType.KIDZEE;
//         AppFlavor = 'kidzee';
//         flavor = LocalConstant.NOTIFICATION_CHANNEL_KIDZEE;
//       } else {
//         AppFlavor = 'mlzs';
//         environmentType = EnvironmentType.MLZS;
//         flavor = LocalConstant.NOTIFICATION_CHANNEL_MLZS;
//       }
//     }

// //     debugPrint('App Flavor is $flavor');
//     return flavor;
//   } catch (e) {
//     debugPrint(e.toString());
//     return '';
//   }
}

Future<void> initNotification(String AppFlavor) async {
  //String AppFlavor = await getFlavors();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );

  // debugPrint('User granted permission: ${settings.authorizationStatus}');
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //debugPrint('User granted permission');
    // TODO: handle the received notifications
  } else {
    // Permission.notification.request();
    // debugPrint('User declined or has not accepted permission');
  }
//   debugPrint('====================$AppFlavor');
  //debugPrint('================${AppFlavor == 'kidzee' ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE : LocalConstant.NOTIFICATION_CHANNEL_MLZS} Channel');
  await AwesomeNotifications().initialize(
      'resource://drawable/app_logo',
      [
        NotificationChannel(
            channelGroupKey: AppFlavor,
            channelKey: AppFlavor,
            channelName: AppFlavor,
            channelDescription:
                'This channel is used for important notifications',
            channelShowBadge: true,
            defaultColor: Colors.white54,
            ledColor: Colors.black),
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            channelShowBadge: true,
            // groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple),
        NotificationChannel(
            channelGroupKey: 'layout_tests',
            icon: 'resource://drawable/app_logo',
            channelKey: 'progress_bar',
            channelName: 'Progress bar notifications',
            channelDescription: 'Notifications with a progress bar layout',
            defaultColor: Colors.white60,
            ledColor: Colors.black,
            // vibrationPattern: lowVibrationPattern,

            onlyAlertOnce: true),
        NotificationChannel(
            channelGroupKey: 'image_tests',
            channelKey: 'big_picture',
            channelName: 'Big pictures',
            channelDescription: 'Notifications with big and beautiful images',
            channelShowBadge: true,
            defaultColor: Colors.white60,
            ledColor: Colors.black,
            vibrationPattern: kIsWeb ? null : lowVibrationPattern,
            importance: NotificationImportance.High),
        NotificationChannel(
          channelGroupKey: 'layout_tests',
          channelKey: 'big_text',
          channelName: 'Big text notifications',
          channelDescription: 'Notifications with a expandable body text',
          channelShowBadge: true,
          defaultColor: Colors.white60,
          ledColor: Colors.black,
          vibrationPattern: kIsWeb ? null : lowVibrationPattern,
        ),
        NotificationChannel(
          channelGroupKey: 'schedule_tests',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          vibrationPattern: kIsWeb ? null : lowVibrationPattern,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          criticalAlerts: true,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: AppFlavor,
          channelGroupName: AppFlavor,
        ),
        NotificationChannelGroup(
            channelGroupKey: 'image_tests', channelGroupName: 'Images tests'),
        NotificationChannelGroup(
            channelGroupKey: 'layout_tests', channelGroupName: 'Layout tests'),
        NotificationChannelGroup(
            channelGroupKey: 'schedule_tests',
            channelGroupName: 'Schedule tests'),
      ],
      debug: false);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      // NotificationController.displayNotificationRationale();
      // AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

AndroidNotificationChannel? channel;

late ServiceInstance mService;

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
//   debugPrint('onStart Service');
  //String appName = await getFlavors();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = 'Kidzee';
  if (packageInfo.packageName == 'com.zeelearn.ekidzee') {
    appName = 'Kidzee';
  } else {
    appName = 'MLZS Preprimary App';
  }
//   debugPrint('Flavor is $appName');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  try {
    flutterLocalNotificationsPlugin.show(
      888,
      appName,
      'Sync Data with Server process started',
      NotificationDetails(
        android: AndroidNotificationDetails(
          appName,
          appName,
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  } catch (e) {
    log('Error while getting package name is - $e');
  }
//   debugPrint('Service is started...478');
  checkPendingData(0);
  mService = service;
  // For flutter prior to version 3.0.0
  service.on('stopService').listen((event) {
//     debugPrint('onStart Service onStop');
    service.stopSelf();
  });

  /*service.on('syncPendingData').listen((event) {
    debugPrint('Sync Pendning Data function is getting called.');
    checkPendingData(0);
  });*/

  service.on('startUploadingVideo').listen((event) async {
    var videoPath = event!['videoPath'];
    var userID = event['userId'];
    debugPrint(
        'start uploading video has baeen called and data is $videoPath $userID');

    var response = await APIService().uploadImage(
      userID,
      videoPath,
      isVideoFile: true,
      progress: (int bytes, int totalBytes) async {
        ProgressNotification.udpateNotificationAfter1Second =
            Timer(const Duration(seconds: 1), () async {
          ProgressNotification.updateCurrentProgressBar(
              id: 12423,
              simulatedStep: bytes,
              maxStep: totalBytes,
              filename: videoPath.toString().split('/').last);
          ProgressNotification.udpateNotificationAfter1Second?.cancel();
          ProgressNotification.udpateNotificationAfter1Second = null;

          service.invoke('update', {
            'progress': {'bytes': bytes, 'totalbytes': totalBytes},
          });
        });

        debugPrint(
            'response from video file upload api is - $bytes and $totalBytes');
      },
    );

    service.invoke(
        'update', {'success': response.toJson(), 'videoUrl': videoPath});
    stopService(mService);

//     response.either((left) {
//       service.invoke('update', {'error': left, 'videoUrl': videoPath});
// //       debugPrint('response.either');
//       stopService(mService);
//     }, (right) {
// //       debugPrint('response.either');
//       service
//           .invoke('update', {'success': right.toJson(), 'videoUrl': videoPath});
//       stopService(mService);
//     });
  });
}

Future<void> checkPendingData(int action) async {
  bool isInternet = await Utility.isInternet();
//   debugPrint('Check Pending Data $isInternet');
  SharedPreferences prefs = await SharedPreferences.getInstance();
//   debugPrint('User ${prefs.containsKey(LocalConstant.KEY_USER_ID)}');
  try {
    if (prefs.containsKey(LocalConstant
            .KEY_USER_ID) /*&&
        prefs.containsKey(LocalConstant.KEY_APP_TOKEN)*/
        &&
        isInternet) {
      String userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
      //debugPrint('UserId ${userId}');
      String token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
      //debugPrint('token ${token}');
      DBHelper helper = DBHelper();
      List<Map<String, dynamic>> unSyncList =
          await helper.getUnSyncData(userId);
      // debugPrint(unSyncList.length);
      if ((unSyncList.isNotEmpty)) {
        Map<String, dynamic> map = unSyncList[0];
//         debugPrint('action ${map[DBConstant.ACTION_TYPE]} ${unSyncList.length}');
        if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_OFFLINE_DEVELOPMENTAL) {
          //Attandance
          apiDevelopmental(
              map[DBConstant.ID], map[DBConstant.JSON_MODEL], token);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_ATTANDANCE) {
          //Attandance
          apiAttandance(map[DBConstant.ID], map[DBConstant.JSON_MODEL]);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_LOGBOOK) {
          //Logbook
          apiLogbook(map[DBConstant.ID], map[DBConstant.JSON_MODEL], token);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_BACKGROUND_FILE_UPLOAD) {
          uploadVideoInBackground(
              map[DBConstant.ID], map[DBConstant.JSON_MODEL]);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY) {
          uploadImage(map[DBConstant.ID], map[DBConstant.JSON_MODEL], token,
              map[DBConstant.ACTION_TYPE]);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_BG_ACADEMIC) {
          insertAcademicFeedback(
              map[DBConstant.ID], map[DBConstant.JSON_MODEL], token);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD) {
          // uploadHomeworkImage(map[DBConstant.ID], map[DBConstant.JSON_MODEL],
          //     token, map[DBConstant.ACTION_TYPE]);
          uploadImage(map[DBConstant.ID], map[DBConstant.JSON_MODEL], token,
              map[DBConstant.ACTION_TYPE]);
        } else if (map[DBConstant.ACTION_TYPE] ==
            LocalConstant.ACTION_IMAGE_UPLOAD_CHILD_ADV) {
          // uploadChildAdv(map[DBConstant.ID], map[DBConstant.JSON_MODEL], token,
          //     map[DBConstant.ACTION_TYPE]);
          uploadImage(map[DBConstant.ID], map[DBConstant.JSON_MODEL], token,
              map[DBConstant.ACTION_TYPE]);
        } else {
//           debugPrint('in Else action ${map[DBConstant.ACTION_TYPE]}');
          DBHelper helper = DBHelper();
          helper.delete(
              LocalConstant.TABLE_DATA_SYNC, map[DBConstant.ID].toString());
          checkPendingData(3);
        }
      } else {
//         debugPrint('515');
        stopService(mService);
      }
    } else {
//       debugPrint('518');
      stopService(mService);
    }
  } catch (e) {
    debugPrint(e.toString());
    stopService(mService);
  }
}

Future<void> uploadImage(
    int id, String body, String token, String action) async {
  //UpdateArtsyRequest
  debugPrint(body);
  String filePath = '';
  dynamic request;
  if (action == LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY) {
    request = UpdateArtsyRequest.fromJson(
      json.decode(body),
    );
    filePath = request.InputData.ParentMediaUrl;
  } else if (action == LocalConstant.ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD) {
    request = UpdateHomeWorkRequest.fromJson(
      json.decode(body),
    );
    filePath = request.InputData[0].UploadUrl;
  }

  //dynamic response = await APIService().updateImageUpload(request.UserID, request.InputData.ParentMediaUrl);
  var response = await APIService().uploadImage(
    id.toString(),
    filePath,
    isVideoFile: false,
    progress: (int bytes, int totalBytes) async {
      ProgressNotification.udpateNotificationAfter1Second =
          Timer(const Duration(seconds: 1), () async {
        ProgressNotification.updateCurrentProgressBar(
            id: 12423,
            simulatedStep: bytes,
            maxStep: totalBytes,
            filename: filePath.toString().split('/').last);
        ProgressNotification.udpateNotificationAfter1Second?.cancel();
        ProgressNotification.udpateNotificationAfter1Second = null;

        /*service.invoke('update', {
              'progress': {'bytes': bytes, 'totalbytes': totalBytes},
            });*/
      });

      debugPrint(
          'response from video file upload api is - $bytes and $totalBytes');
    },
  );

  upload(response, id, token, action, request);

//   response.either((left) {
//     //service.invoke('update', {'error': left, 'videoUrl': videoPath});
// //     debugPrint('response.either');
// //     debugPrint('upload image response $response');

//     //stopService(mService);
//   }, (right) {
// //     debugPrint('response.either');
// //     debugPrint('upload image response $response');
//     upload(right, id, token, action, request);
//     //service.invoke('update', {'success': right.toJson(), 'videoUrl': videoPath});
//     //stopService(mService);
//   });
}

void showCompleteNotification(int id, String request) {
//   debugPrint('Show compelete notification $request');
  NotificationService notificationService = NotificationService();
  notificationService.showNotification(
      10 + id, '$request Updated!', '$request Updated!', '$request Updated!');
}

void showCompleteNotificationBody(int id, String request, String body) {
//   debugPrint('Show compelete notification $request');
  NotificationService notificationService = NotificationService();
  notificationService.showNotification(10 + id, request, body, body);
}

void upload(dynamic response, int id, String token, String action,
    dynamic actionRequest) {
//   debugPrint('upload image $actionRequest');
  if (action == LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY) {
    if (response is UploadImageResponse) {
      //sync in data
      UpdateArtsyRequest request = actionRequest;
      request.InputData.ParentMediaUrl = response.imageModel![0].location;
      debugPrint(request.InputData.ParentMediaUrl);
      APIService().updateArtsy(request, token).then((value) {
        if (value != null) {
          if (value is ELGStudResponse) {
            ELGStudResponse response = value;
            if (response.success == 200) {
              DBHelper helper = DBHelper();
              helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
              checkPendingData(0);
              showCompleteNotification(id, 'ARTSY Image Upload ');
            }
          } else {
            DBHelper helper = DBHelper();
            helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
            checkPendingData(0);
            showCompleteNotification(id, 'ARTSY Image Upload ');
          }
        } else {
          showCompleteNotification(id, 'ARTSY Image Upload ');
          DBHelper helper = DBHelper();
          helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
          checkPendingData(0);
        }
      });
    } else {
//       debugPrint('in else 598');
      DBHelper helper = DBHelper();
      helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
      checkPendingData(0);
      showCompleteNotification(id, 'ARTSY Image Upload ');
      //checkPendingData(0);
      //LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY
    }
  } else if (action == LocalConstant.ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD) {
//     debugPrint('in ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD');
    UpdateHomeWorkRequest request = actionRequest;
    if (response is UploadImageResponse) {
//       debugPrint('in ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD UploadImageResponse');
      //sync in data
      request.InputData[0].UploadUrl = response.imageModel![0].location;
      debugPrint(request.InputData[0].UploadUrl);
      APIService().updateHomework(request, token).then((value) {
        debugPrint(value.toString());
        if (value != null) {
//           debugPrint('in ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD $value');
          if (value == null) {
            //Utility.showMessage(context, 'Unable to save...');
          } else if (value is GenericResponse) {
            GenericResponse response = value;
            if (response.success == 200) {
              DBHelper helper = DBHelper();
              helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
              showCompleteNotification(id, 'Homework ');
              checkPendingData(0);
            }
          } else {
            DBHelper helper = DBHelper();
            helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
            checkPendingData(0);
          }
          //checkPendingData(0);
        } else {
          DBHelper helper = DBHelper();
          helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
          checkPendingData(0);
          showCompleteNotification(id, 'Homework ');
        }
      });
    } else {
//       debugPrint('in else 633');
      DBHelper helper = DBHelper();
      helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
      checkPendingData(0);
      //checkPendingData(0);
      //LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY
    }
  } else if (action == LocalConstant.ACTION_IMAGE_UPLOAD_CHILD_ADV) {
    UpdateHomeWorkRequest request = actionRequest;
    if (response is UploadImageResponse) {
      request.InputData[0].UploadUrl = response.imageModel![0].location;
      APIService()
          .saveAnecdotalChildAdvancement(request.toJson(), token)
          .then((value) {
        if (value != null) {
//           debugPrint('upload image response show notification $response');
          showCompleteNotification(id, 'Child Advancement');
          if (value == null) {
          } else if (value is GenericResponse) {
            GenericResponse response = value;
            // debugPrint(response);
            // debugPrint(response.success);
            if (response.success == 200) {
              DBHelper helper = DBHelper();
              helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
              checkPendingData(0);
            }
          } else {
            DBHelper helper = DBHelper();
            helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
            checkPendingData(0);
          }
        } else {
          DBHelper helper = DBHelper();
          helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
          checkPendingData(0);
        }
      });
    }
  }
}

// uploadHomeworkImage(int id, String body, String token, String action) async {
//   //UpdateArtsyRequest
//   UpdateHomeWorkRequest request = UpdateHomeWorkRequest.fromJson(
//     json.decode(body),
//   );
//   debugPrint(request.toJson());
//   dynamic response = await APIService()
//       .updateImageUpload(request.UserID, request.InputData[0].UploadUrl);
//   debugPrint('upload image response $response');
//   if (response is UploadImageResponse) {
//     //sync in data
//     request.InputData[0].UploadUrl = response.imageModel![0].location;
//     debugPrint(request.InputData[0].UploadUrl);
//     APIService().updateHomework(request, token).then((value) {
//       debugPrint(value.toString());
//       if (value != null) {
//         if (value == null) {
//           //Utility.showMessage(context, 'Unable to save...');
//         } else if (value is GenericResponse) {
//           GenericResponse response = value;
//           if (response.success == 200) {
//             DBHelper helper = DBHelper();
//             helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//             checkPendingData(0);
//           }
//         } else {
//           DBHelper helper = DBHelper();
//           helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//           checkPendingData(0);
//         }
//         //checkPendingData(0);
//       } else {
//         DBHelper helper = DBHelper();
//         helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//         checkPendingData(0);
//       }
//     });
//   } else {
//     debugPrint('in else 633');
//     DBHelper helper = DBHelper();
//     helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//     checkPendingData(0);
//     //checkPendingData(0);
//     //LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY
//   }
// }

// uploadChildAdv(int id, String body, String token, String action) async {
//   //UpdateArtsyRequest
//   InsertAnecdotalRequest request = InsertAnecdotalRequest.fromJson(
//     json.decode(body),
//   );
//   debugPrint(request.toJson());
//   dynamic response = await APIService()
//       .updateImageUpload(request.UserId, request.anecdotalModel[0].RefValue);
//   debugPrint('upload image response $response');
//   if (response is UploadImageResponse) {
//     //sync in data
//     request.anecdotalModel[0].RefValue = response.imageModel![0].location;
//     APIService()
//         .saveAnecdotalChildAdvancement(request.toJson(), token)
//         .then((value) {
//       if (value != null) {
//         debugPrint('upload image response show notification $response');
//         showCompleteNotification(id, 'Child Advancement');
//         if (value == null) {
//         } else if (value is GenericResponse) {
//           GenericResponse response = value;
//           debugPrint(response);
//           debugPrint(response.success);
//           if (response.success == 200) {
//             DBHelper helper = DBHelper();
//             helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//             checkPendingData(0);
//           }
//         } else {
//           DBHelper helper = DBHelper();
//           helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//           checkPendingData(0);
//         }
//       } else {
//         DBHelper helper = DBHelper();
//         helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//         checkPendingData(0);
//       }
//     });
//   } else {
//     debugPrint('in else 633');
//     DBHelper helper = DBHelper();
//     helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
//     checkPendingData(0);
//     //checkPendingData(0);
//     //LocalConstant.ACTION_IMAGE_UPLOAD_PARENTARTSY
//   }
// }

void insertBPMSAttachments(int id, String mTaskId, String path, String userId) {
  InsertTaskAttachmentRequest request = InsertTaskAttachmentRequest(
      taskId: mTaskId, filePath: path, userId: userId);
  APIService apiService = APIService();
  apiService.insertTaskAttachment(request).then((value) {
    if (value != null) {
      InsertTaskAttachmentResponse responseModel;
      if (value != null) {
        responseModel = value;
        // debugPrint(responseModel.toJson());
        DBHelper helper = DBHelper();
        helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
        checkPendingData(3);
      } else {}
    } else {}
  });
}

Future<void> uploadBPMS(int id, String body) async {
  FileUploadModel uploadModel = FileUploadModel.fromJson(
    json.decode(body) as Map<String, dynamic>,
  );
  final box = Hive.box(LocalConstant.communicationKey);

  // Update the "counter" value

  // Close the Hive box
  //await box.close();
  var response = await APIService().uploadImage(
    uploadModel.userId,
    uploadModel.path,
    isVideoFile: true,
    progress: (int bytes, int totalBytes) async {
      //box.put('imageUpload', 10);
      ProgressNotification.udpateNotificationAfter1Second =
          Timer(const Duration(seconds: 1), () async {
        ProgressNotification.updateCurrentProgressBar(
            id: 1,
            simulatedStep: bytes,
            maxStep: totalBytes,
            filename: uploadModel.path.toString().split('/').last);
        ProgressNotification.udpateNotificationAfter1Second?.cancel();
        ProgressNotification.udpateNotificationAfter1Second = null;
/*            service.invoke('update', {
              'progress': {'bytes': bytes, 'totalbytes': totalBytes},
            });*/
      });
      debugPrint(
          'response from video file upload api is - $bytes and $totalBytes');
    },
  );

  DBHelper helper = DBHelper();
  helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
  checkPendingData(3);

  // response.either((left) async {
  //   await box.close();
  //   //update database error
  //   DBHelper helper = DBHelper();
  //   helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
  //   checkPendingData(3);
  //   //service.invoke('update', {'error': left, 'videoUrl': videoPath});
  //   //stopService(mService);
  // }, (right) async {
  //   //update database
  //   await box.close();
  //   //service.invoke('update', {'success': right.toJson(), 'videoUrl': videoPath});
  //   //stopService(mService);
  // });
}

Future<void> uploadVideoInBackground(int id, String body) async {
  FileUploadModel uploadModel = FileUploadModel.fromJson(
    json.decode(body) as Map<String, dynamic>,
  );
  var response = await APIService().uploadImage(
    uploadModel.userId,
    uploadModel.path,
    isVideoFile: true,
    progress: (int bytes, int totalBytes) async {
      ProgressNotification.udpateNotificationAfter1Second =
          Timer(const Duration(seconds: 1), () async {
        ProgressNotification.updateCurrentProgressBar(
            id: 1,
            simulatedStep: bytes,
            maxStep: totalBytes,
            filename: uploadModel.path.toString().split('/').last);
        ProgressNotification.udpateNotificationAfter1Second?.cancel();
        ProgressNotification.udpateNotificationAfter1Second = null;
/*            service.invoke('update', {
              'progress': {'bytes': bytes, 'totalbytes': totalBytes},
            });*/
      });
      debugPrint(
          'response from video file upload api is - $bytes and $totalBytes');
    },
  );

  DBHelper helper = DBHelper();
  helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
  checkPendingData(3);
  // response.either((left) {
  //   //update database error
  //   DBHelper helper = DBHelper();
  //   helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
  //   checkPendingData(3);
  //   //service.invoke('update', {'error': left, 'videoUrl': videoPath});
  //   //stopService(mService);
  // }, (right) {
  //   //update database

  //   //service.invoke('update', {'success': right.toJson(), 'videoUrl': videoPath});
  //   //stopService(mService);
  // });
}

String getStatusName(String status) {
  if (status.toLowerCase() == 'c') {
    return 'Completed';
  } else if (status.toLowerCase() == 'pc') {
    return 'Partially Completed';
  } else {
    return 'Not Completed';
  }
}

Future<void> apiLogbook(int id, String body, String token) async {
  APIService apiService = APIService();
  apiService.insertLogbookRemark(body, token).then((value) {
    if (value != null) {
      try {
        InsertLogbookRequest data =
            InsertLogbookRequest.fromJson(jsonDecode(body));
        String destiption =
            '${data.remarkModel.Topic} topic from ${data.remarkModel.SessionName} session marked ${getStatusName(data.remarkModel.StatusCode)}';
        showCompleteNotificationBody(
            id,
            'Logbook Status for ${data.remarkModel.CName} has been updated',
            destiption);
      } catch (e) {
        showCompleteNotification(id, ' Logbook');
      }
      DBHelper helper = DBHelper();
      helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
      checkPendingData(3);
    }
  });
}

Future<void> insertAcademicFeedback(int id, String body, String token) async {
//   debugPrint('processing insertAcademicFeedback');
  APIService apiService = APIService();
  apiService.insertAcademicFeedbackBg(body, token).then((value) {
//     debugPrint('response $value');
    if (value == null) {
    } else if (value is GenericResponse) {
      GenericResponse response = value;
      if (response.success == 200) {
        try {
          AcademicFeedbackRequest data =
              AcademicFeedbackRequest.fromJson(jsonDecode(body));
          String desc = "Academic Learning Goals  are successfully Updated!";
          showCompleteNotificationBody(id, desc, desc);
        } catch (e) {
          showCompleteNotification(id, 'Academic Feedback');
        }
      }
    }
    DBHelper helper = DBHelper();
    helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
    checkPendingData(3);
  });
}

void apiDevelopmental(int id, String request, String token) {
//   debugPrint('apiDevelopmental --------API Called------------');
  APIService apiService = APIService();
  apiService.insertDevelopmentalFeedback(request, token).then((value) {
    if (value != null) {
//       debugPrint('apiDevelopmental resposne : $value');
      if (value is GenericResponse) {
        GenericResponse response = value;
        if (response.success == 200) {
          try {
            DevelopmentalFeedbackRequest data =
                DevelopmentalFeedbackRequest.fromJson(jsonDecode(request));
            String desc =
                "Developmental Observation for ${data.ObservationType} has been processed successfully";
            showCompleteNotificationBody(id, desc, desc);
          } catch (e) {
            showComplete(id, ' Developmental');
          }
        }
        //getChildInfomrmationList();
      }
    }
    DBHelper helper = DBHelper();
    helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
    checkPendingData(3);
  });
}

void showComplete(int id, String type) {
  NotificationService notificationService = NotificationService();
  notificationService.showNotification(
      10 + id,
      '$type Update!',
      '$type have been updated successfully.',
      '$type have been updated successfully.');
}

Future<void> apiAttandance(int id, String body) async {
  APIService apiService = APIService();
  apiService.insertOfflineAttendance(body).then((value) {
    if (value != null) {
      if (value is GenericResponse) {
        GenericResponse response = value;
        if (response.success == 200) {
          try {
            AttandanceRequest data =
                AttandanceRequest.fromJson(jsonDecode(body));
            showCompleteNotificationBody(id, 'Attendance Updated!',
                'Attendance for Day ${data.d} is updated.');
          } catch (e) {
            showCompleteNotification(id, ' Attendance');
          }
        }
      }
    }
    DBHelper helper = DBHelper();
    helper.delete(LocalConstant.TABLE_DATA_SYNC, id.toString());
    checkPendingData(3);
  });
}

Future<void> cancelNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.cancel(888);
  //flutterLocalNotificationsPlugin.cancel(0);
  NotificationService notificationService = NotificationService();
  notificationService.cancelNotification(14);
}

void stopService(ServiceInstance mService) {
//   debugPrint('stop Service');
  //FlutterLocalNotificationsPlugin().cancelAll();
  Timer.periodic(const Duration(seconds: 2), (timer) async {
    mService.stopSelf();

    cancelNotification();
  });
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

  await FirebaseAppCheck.instance.activate(
      androidProvider:
          kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug);

  await FirebaseAuth.instance.signInAnonymously();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseApp initFirebaseInstance = await Firebase.initializeApp(
  //     name: "kidzee", options: DefaultFirebaseOptions.currentPlatform);
  // messaging = FirebaseMessaging.instance;
  // Set the background messaging handler early on, as a named top-level function
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //FirebaseMessaging.instance.getInitialMessage();
//   debugPrint('User granted permission: ${settings.authorizationStatus}');
  if (!kIsWeb) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

// Declaration of variables

    if (Platform.isIOS) {
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  getPermission();
  // getToken();

  //runApp(MyApp());
}

Future<void> initFirebaseNotification() async {}

late String token;
Future<void> getToken() async {
//   if (!kIsWeb) {
// // //     debugPrint('app token is ');
// //     token = (await FirebaseMessaging.instance.getToken())!;
// // //     debugPrint('Notification Token..$token');
// //     debugPrint(token);
// //   }
}

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class NotificationController {
  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
//     debugPrint('onActionReceivedImplementationMethod 1192');
    Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) =>
                UserNotification() /* getDeferredWidget(
                child: (context) => userNotification.UserNotification(),
                loadLibrary: userNotification.loadLibrary()) */
            ));
  }

  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    String AppFlavor = await getFlavors();
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: AppFlavor == 'kidzee'
                  ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                  : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
              channelName: AppFlavor == 'kidzee'
                  ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                  : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
              channelDescription: AppFlavor == 'kidzee'
                  ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                  : "${LocalConstant.NOTIFICATION_CHANNEL_MLZS} is for important notification",
              playSound: true,
              onlyAlertOnce: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              channelShowBadge: true,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents(
      BuildContext context) async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint(
        'Received action is in main - ${receivedAction.actionType} and payload is - ${receivedAction.payload}');

    // Resolve dynamic IDs like <uid>, <userid>, <displayname>, <username>
    // from the same session source used by _resolveNotificationUrl.
    final payload = await Utility.resolveNotificationPayloadPlaceholders(
      receivedAction.payload,
    );

    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      debugPrint(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      // await executeLongTaskInBackground();
    } else if (payload['type'] == 'cogniHW') {
      print(
          'Received action is in main - ${receivedAction.actionType} and payload is - $payload');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userType = prefs.getString(LocalConstant.KEY_USER_TYPE);
      if (userType != null) {
        Navigator.pushAndRemoveUntil(
          MyApp.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Homework'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        MyApp.navigatorKey.currentContext!,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                            profileImage: '',
                            title: '',
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.arrow_back)),
                automaticallyImplyLeading: true,
              ),
              body: HomeworkHome(
                userType: userType,
              ),
            ),
          ),
          (route) => false,
        );
      }
    } else if (payload['type'] != null && payload['type'] == 'logout') {
      print(
          'Received action is in main - ${receivedAction.actionType} and payload is - $payload');
      await Utility.clearData();
      Navigator.pushAndRemoveUntil(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LoginScreenV2(),
        ),
        (route) => false,
      );
    } else if (payload['promo'] != null && payload['promo'] == 'saathi') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (AppFlavor == null) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        appVersion = packageInfo.version;

        if (packageInfo.packageName == 'com.zeelearn.ekidzee') {
          environmentType = EnvironmentType.KIDZEE;
          AppFlavor = 'kidzee';
        } else {
          AppFlavor = 'mlzs';
          environmentType = EnvironmentType.MLZS;
        }
      }
      debugPrint(
          'Current BusinessId $AppFlavor - ${Navigator.canPop(MyApp.navigatorKey.currentContext!)}');
      String userName = prefs.containsKey(LocalConstant.KEY_USER_ID)
          ? prefs.getString(LocalConstant.KEY_USER_ID) as String
          : '';

      if (Navigator.canPop(MyApp.navigatorKey.currentContext!)) {
        Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => ZllTicketDetails(
              ticketId: payload['id']!,
              bid: AppFlavor == 'kidzee' ? '1' : '2',
              businessUserId: payload['business_user_id']!,
              userId: userName,
              mColor: kPrimaryLightColor,
            ),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => ZllTicketDetails(
                ticketId: payload['id']!,
                bid: AppFlavor == 'kidzee' ? '1' : '2',
                businessUserId: payload['business_user_id']!,
                userId: userName,
                mColor: kPrimaryLightColor,
              ),
            ),
            (route) => false);
      }
    } else if (payload['Video_path'] != null) {
      Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => VideoPlayer(
                    Title: payload['Video_path']!,
                    path: payload['Video_path']!,
                  )));
    } else if (payload['url'] != null && payload['url']!.isNotEmpty) {
      final resolvedUrl = payload['url']!;
      if (resolvedUrl.contains('kidzeeapp')) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString(LocalConstant.KEY_DEEPLINK_URL, resolvedUrl);
      } else if (payload.containsKey('type') && payload['type'] == 'tb') {
        Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => MyWebsiteView(
                    title: 'ZllSaathi',
                    url: resolvedUrl,
                  )),
        );
      } else {
        print(
            'Received action for url is working and data is - $resolvedUrl');
        Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => MyWebsiteView(
                    title: resolvedUrl,
                    url: resolvedUrl,
                  )),
        );
      }
    } else if (payload['type'] != null &&
        payload['type'] == 'LogbookStatus') {
      debugPrint(
          'Received action for logbookstatus is working and data is - ${payload['day']} ${payload['status']}');
      Navigator.pushAndRemoveUntil(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
                profileImage: '',
                title: '',
                day: payload['day'],
                status: payload['status'],
                programId: payload['programId']),
          ),
          (route) => false);
    } else if (payload['promo'] != null) {
      print('found promo');
      print('Promo is getting called - $payload');

      final actionUrl = payload['actionUrl'] ?? '';
      PromoNotification.displayPromoNotification(
          payload['title']!,
          payload['body']!,
          payload['bigimage']!,
          actionUrl);
    } else {
      print('Unable to handle notification action - $payload');
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<void> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;

                    Navigator.of(ctx).pop();
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
//     debugPrint("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("https://google.com");
    final re = await http.get(url);
    debugPrint(re.body);
//     debugPrint("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: "Huston! The eagle has landed!",
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {
              'notificationId': '1234567890'
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(seconds: 10))));
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

bool initialURILinkHandled = false;

class _MyAppState extends ConsumerState<MyApp> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;
  @override
  void initState() {
    super.initState();
    initFlavor();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        _incomingLinkHandler();
      } catch (e) {
        // debugPrint(e);
      }
    });
    //_initURIHandler();
    //_incomingLinkHandler();
    setNotificationCount();
    PushNotificationSetup().initialize(context, ref);
    NotificationController.startListeningNotificationEvents(context);
  }

  Future<void> initFlavor() async {
    await getFlavors();
//     debugPrint('flavor set');
  }

  void _incomingLinkHandler() {
    // if (!kIsWeb) {
    //   // It will handle app links while the app is already started - be it in
    //   // the foreground or in the background.
    //   _streamSubscription = uriLinkStream.listen((Uri? uri) async {
    //     if (!mounted) {
    //       return;
    //     }
    //     debugPrint('Received URI: $uri');

    //     // SharedPreferences prefs = await SharedPreferences.getInstance();
    //     // String uid = prefs.getString(LocalConstant.KEY_UID) as String;
    //     //deepLinkCommonFunction(uri);
    //   }, onError: (Object err) {
    //     if (!mounted) {
    //       return;
    //     }
    //     debugPrint('Error occurred: $err');
    //   });
    // }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  // void _incomingLinkHandler() {
  //   if (!kIsWeb) {
  //     // It will handle app links while the app is already started - be it in
  //     // the foreground or in the background.
  //     _streamSubscription = uriLinkStream.listen((Uri? uri) {
  //       if (!mounted) {
  //         return;
  //       }
  //       handleDeepLink(uri!.path);
  //       debugPrint('Received URI: $uri');
  //       Utility.showMessage(context, uri.path);
  //       setState(() {
  //         _currentURI = uri;
  //         _err = null;
  //       });
  //     }, onError: (Object err) {
  //       if (!mounted) {
  //         return;
  //       }
  //       debugPrint('Error occurred: $err');
  //       setState(() {
  //         _currentURI = null;
  //         if (err is FormatException) {
  //           _err = err;
  //         } else {
  //           _err = null;
  //         }
  //       });
  //     });
  //   }
  // }

  void deepLinkCommonFunction(Uri? initialURI) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(LocalConstant.KEY_UID) as String;
    debugPrint(
        'udid from deep linkk is - ${initialURI!.path.split('/').elementAt(1)}');
    // debugPrint('udid ${initialURI}');
    // debugPrint('udid ${initialURI.queryParameters['id']}');
    if (initialURI.toString().contains(WebViewUrlConstants.URL_SAATHI_LOGIN)) {
//       debugPrint('init handler ${initialURI.queryParameters.toString()}');
      //switchUser(initialURI!.queryParameters['username'].toString(),initialURI!.queryParameters['password'].toString());
      Map<String, String> param = {};
      param.putIfAbsent(
        'username',
        () => initialURI.queryParameters['username'].toString(),
      );
      param.putIfAbsent(
        'password',
        () => initialURI.queryParameters['password'].toString(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenV2()),
      );
    } else if (initialURI.toString().contains('kidzeeapp://login/')) {
//       debugPrint('init handler ${initialURI.queryParameters.toString()}');
      //switchUser(initialURI!.queryParameters['username'].toString(),initialURI!.queryParameters['password'].toString());
      Map<String, String> param = {};
      param.putIfAbsent(
        'username',
        () => initialURI.queryParameters['username'].toString(),
      );
      param.putIfAbsent(
        'password',
        () => initialURI.queryParameters['password'].toString(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenV2()),
      );
    } else {
      log('Else part is getting called of deep link - $initialURI');
    }
  }

  void handleDeepLink(String link) {
    // Parse and handle your deep link here
//     debugPrint('Deep link: $link');
    // Example: Extract parameters from the deep link
    Uri uri = Uri.parse(link);
    String? param1 = uri.queryParameters['username'];
    String? param2 = uri.queryParameters['password'];
    // Use the parameters as needed in your app
//     debugPrint('username: $param1, password: $param2');
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> setNotificationCount() async {
    var count = (int.parse(
        await KidzeePref().getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
            '0'));
    // PushNotificationSetup().initialize(context, ref);
    ref.read(countProvider.notifier).update((state) => count);
  }

  @override
  Widget build(BuildContext context) {
    //final theme = ref.watch(themeProvider);

    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        PagedDataTableLocalization.delegate
      ],
      supportedLocales: const [
        Locale("es"),
        Locale("en"),
        Locale("de"),
        Locale("it"),
      ],
      locale: const Locale("en"),
      debugShowCheckedModeBanner: false,
      // routerConfig: GoRouterSetup.getGoRouter(context),
      // initialRoute: '/splash',
      routes: appRoutes,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 360, name: 'SMALL_MOBILE'),
          const Breakpoint(start: 361, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: /* HomeworkHome() */ const SplashScreen(),
      navigatorKey: MyApp.navigatorKey,
      theme: ChristmasTheme.lightTheme,
      // darkTheme: ChristmasTheme.darkTheme,
    );
  }
}
