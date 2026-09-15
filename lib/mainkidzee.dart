/*
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/intro/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'helper/DatabaseHelper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //debugPrint("Handling a background message: ${message.messageId}");
  String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());

  String? imsageUrl = '';
  if (Platform.isAndroid) {
    imsageUrl = message.notification?.android?.imageUrl.toString();
  }else if(Platform.isIOS){
    imsageUrl = message.notification?.apple?.imageUrl.toString();
  }
  DBHelper _helper = new DBHelper();
  Map<String,String> data = new Map();
  data.putIfAbsent('title', () => message.notification?.title as String);
  data.putIfAbsent('description', () => message.notification?.body as String);
  data.putIfAbsent('type', () => 'push');
  data.putIfAbsent('date', () => cdate);
  data.putIfAbsent('imageurl', () => imsageUrl as String);
  _helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
  //debugPrint('data inserted successfully');
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() => runApp(const MyApp());

void main() async {
  //debugPrint('-- main');

  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  DBHelper.initDb();
  initFirebase();
  runApp(MaterialApp(home: MyApp()));
}

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(true);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
    // Pass all uncaught errors from the framework to Crashlytics.
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic("ekidzee");

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'flutter_notification', // id
        'flutter_notification_title', // title
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        showBadge: true,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //debugPrint('User granted permission');
      // TODO: handle the received notifications
    } else {
      //debugPrint('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //debugPrint('Got a message whilst in the foreground!');
      //debugPrint('Message data mainKidzee: ${message.data}');
      String? imsageUrl = '';
      if (Platform.isAndroid) {
        imsageUrl = message.notification?.android?.imageUrl.toString();
      }else if(Platform.isIOS){
        imsageUrl = message.notification?.apple?.imageUrl.toString();
      }

      if (message.notification != null) {
        //debugPrint('Message also contained a notification: ${message.notification}');
        String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());
        DBHelper _helper = new DBHelper();
        Map<String,String> data = new Map();
        data.putIfAbsent('title', () => message.notification?.title as String);
        data.putIfAbsent('description', () => message.notification?.body as String);
        data.putIfAbsent('type', () => 'push');
        data.putIfAbsent('date', () => cdate);
        data.putIfAbsent('imageurl', () => imsageUrl as String);
        _helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
      }else{
        String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());
        DBHelper _helper = new DBHelper();
        Map<String,String> data = new Map();
        data.putIfAbsent('title', () => message.notification?.title as String);
        data.putIfAbsent('description', () => message.notification?.body as String);
        data.putIfAbsent('type', () => 'push');
        data.putIfAbsent('date', () => cdate);
        _helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
        //debugPrint('data inserted successfully');
      }
    });
  }
  getToken();
  //runApp(MyApp());
}

initFirebaseNotification() async{

}

late String token;
getToken() async {
  token = (await FirebaseMessaging.instance.getToken())!;
  //debugPrint(token);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      */
/*localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],*/ /*

      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      debugShowCheckedModeBanner: false,
      title: 'Kidzee App',
      theme: ThemeData(
          primaryColor: kPrimaryLightColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
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
      home: const SplashScreen(),

    );
  }
}*/
