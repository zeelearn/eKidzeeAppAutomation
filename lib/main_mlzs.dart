import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/intro/splash.dart';
import 'package:ekidzee/pages/notification/NotificationService.dart';
import 'package:ekidzee/pages/notification/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Environment.dart';
import 'constants.dart';
import 'globals.dart';
import 'helper/DatabaseHelper.dart';
import 'main.dart';
import 'model/parent_info.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  ////debugPrint("Handling a background message: ${message.messageId}");
//   debugPrint("mlzs Handling a background message 12 : ${message.data}");
  ////debugPrint("Handling a background message 13 : ${message.data['action']}");
  String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());

  String? imsageUrl = '';
  if (Platform.isAndroid) {
    imsageUrl = message.notification?.android?.imageUrl.toString();
  } else if (Platform.isIOS) {
    imsageUrl = message.notification?.apple?.imageUrl.toString();
  }
  DBHelper helper = DBHelper();
  Map<String, String> data = {};
  if (message.notification != null) {
    //debugPrint('its simple Notification');
    data.putIfAbsent('title', () => message.notification?.title as String);
    data.putIfAbsent('description', () => message.notification?.body as String);
    data.putIfAbsent('type', () => 'push');
    data.putIfAbsent('date', () => cdate);
    data.putIfAbsent('imageurl', () => imsageUrl as String);
    helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
    NotificationService notificationService = NotificationService();
    notificationService.showSimpleNotification(
        message.notification?.title as String,
        message.notification?.body as String);
  } else {
    //debugPrint('its data Notification');
    //debugPrint('its topic Notification');
    if (message.data.containsKey('topic') && message.data['topic'] != '') {
      identifyNotification(message);
    } else {
      //debugPrint('its else topic Notification');
      //showNotification(message);
      NotificationService notificationService = NotificationService();
      notificationService.showSimpleNotification(
          message.data['title'], message.data['body']);
    }
  }
}

void identifyNotification(RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(LocalConstant.KEY_USER_NAME)) {
    String userName = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
    //debugPrint('User Name is ${userName}');
    if (userName.isNotEmpty) {
      String userId = prefs.getString(LocalConstant.KEY_UID) as String;
      String userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
      String franchiseeId =
          prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;

      List<String> franchiseeIdList = ['0', franchiseeId];
      List<String> userIdList = ['0', userId];
      List<String> userTypeList = ['0', userType];
      List<String> classIdList = ['0'];
      late ParentInfo parentInfo;
      if (userType == 'P') {
        try {
          parentInfo = await DBHelper().getParentInfo() as ParentInfo;
          classIdList.add(parentInfo.classId.toString());
        } catch (e) {}
      }
      //debugPrint(classIdList);
      String topic = message.data['topic'];
      for (int index = 0; index < franchiseeIdList.length; index++) {
        for (int jIndex = 0; jIndex < userIdList.length; jIndex++) {
          for (int kIndex = 0; kIndex < userTypeList.length; kIndex++) {
            for (int lIndex = 0; lIndex < classIdList.length; lIndex++) {
              String generatedTopic =
                  '${franchiseeIdList[index]}_${userIdList[jIndex]}_${userTypeList[kIndex]}_${classIdList[lIndex]}';
              ////debugPrint('topic is ${generatedTopic}');
              if (generatedTopic == topic) {
                ////debugPrint('Algo matched=====');
                showNotification(message);
                break;
              } else {
                ////debugPrint('Algo not matched=====${generatedTopic} vs ${topic}');
              }
            }
          }
        }
      }
    }
  }
}

showNotification(RemoteMessage message) {
  String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());
  DBHelper helper = DBHelper();
  Map<String, String> data = {};
  data.putIfAbsent('title', () => message.data['title'] as String);
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
  data.putIfAbsent(
      'imageurl',
      () =>
          message.data.containsKey('url') ? message.data['url'] as String : '');
  helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
  NotificationService notificationService = NotificationService();
  if (message.data.containsKey('bigimage') &&
      (message.data['bigimage'] != null &&
          message.data['bigimage'].toString().isNotEmpty)) {
    notificationService.showBigNotification(
        message.data['title'],
        message.data['body'],
        message.data['logo'],
        message.data['bigimage'],
        message.data['showBigText'] == 'true' ? true : false);
  } else {
    notificationService.showSimpleNotification(
        message.data['title'], message.data['body']);
  }
}

late FirebaseMessaging messaging;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  await Firebase.initializeApp(
      name: AppFlavor == 'kidzee'
          ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
          : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
      options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    initNotification();
    initFirebase();
  }
  DBHelper.initDb();
  environmentType = EnvironmentType.MLZS;
  AppFlavor = 'mlzs';
  appVersion = packageInfo.version;
  //getFlavors();
  initializeService();
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

Future<void> initNotification() async {
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

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //debugPrint('User granted permission');
    // TODO: handle the received notifications
  } else {
    Permission.notification.request();
    //debugPrint('User declined or has not accepted permission');
  }
  debugPrint(
      '================${AppFlavor == 'kidzee' ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE : LocalConstant.NOTIFICATION_CHANNEL_MLZS} Channel');
  AwesomeNotifications().initialize(
      'resource://drawable/app_logo',
      [
        NotificationChannel(
            channelGroupKey: AppFlavor == 'kidzee'
                ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
            channelKey: AppFlavor == 'kidzee'
                ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
            channelName: AppFlavor == 'kidzee'
                ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
            channelDescription:
                'This channel is used for important notifications',
            defaultColor: Colors.white54,
            ledColor: Colors.black)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: AppFlavor == 'kidzee'
                ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
            channelGroupName: AppFlavor == 'kidzee'
                ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
                : LocalConstant.NOTIFICATION_CHANNEL_MLZS)
      ],
      debug: false);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  ////Notification Listener
}

Future<void> initFirebase() async {
  messaging = FirebaseMessaging.instance;
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

  if (!kIsWeb) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );

// Declaration of variables
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

//     debugPrint('User granted permission: ${settings.authorizationStatus}');

    if (Platform.isIOS) {
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ////debugPrint('Got a message whilst in the foreground!');
      ////debugPrint("Handling a background message 13 : ${message.data}");
      ////debugPrint("Handling a background message 13 : ${message.data['action']}");
      String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());

      String? imsageUrl = '';
      if (Platform.isAndroid) {
        imsageUrl = message.notification?.android?.imageUrl.toString();
      } else if (Platform.isIOS) {
        imsageUrl = message.notification?.apple?.imageUrl.toString();
      }
      DBHelper helper = DBHelper();
      Map<String, String> data = {};
      if (message.notification != null) {
        ////debugPrint('its simple Notification');
        data.putIfAbsent('title', () => message.notification?.title as String);
        data.putIfAbsent(
            'description', () => message.notification?.body as String);
        data.putIfAbsent('type', () => 'push');
        data.putIfAbsent('date', () => cdate);
        data.putIfAbsent('imageurl', () => imsageUrl as String);
        helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
        NotificationService notificationService = NotificationService();
        notificationService.showSimpleNotification(
            message.notification?.title as String,
            message.notification?.body as String);
      } else {
        //debugPrint('its data Notification');
        //debugPrint('its topic Notification');
        if (message.data.containsKey('topic') && message.data['topic'] != '') {
          identifyNotification(message);
        } else {
          //debugPrint('its else topic Notification');
          showNotification(message);
        }
      }
    });
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  getToken();

  //runApp(MyApp());
}

initFirebaseNotification() async {}

late String token;
getToken() async {
  token = (await FirebaseMessaging.instance.getToken())!;
//   debugPrint('Notification Token..');
  debugPrint(token);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],*/
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      debugShowCheckedModeBanner: false,
      title: 'MLZS Preprimary App',
      theme: ThemeData(
          primaryColor: kPrimaryLightColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryTEXTBGColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: SplashScreen(),
    );
  }
}
