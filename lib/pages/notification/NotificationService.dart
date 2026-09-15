import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../app_routes.dart';
import '../../helper/KidzeePref.dart';
import '../../helper/LocalConstant.dart';
import '../../main.dart';
import '../home/model/StatusModel.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  String appFlavors = 'kidzee';
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = "1";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    getFlavors() == 'kidzee'
        ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
        : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
    getFlavors() == 'kidzee'
        ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
        : LocalConstant.NOTIFICATION_CHANNEL_MLZS,
    channelDescription:
        "This channel is responsible for all the local notifications",
    playSound: true,
    icon: '@mipmap/ic_launcher',
    priority: Priority.high,
    importance: Importance.high,
    styleInformation: BigTextStyleInformation(''),
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
      DarwinNotificationDetails();

  final NotificationDetails notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // *** Initialize timezone here ***
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // debugPrint(FirebaseMessaging.instance.getToken());
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body,
      DateTime eventDate, TimeOfDay eventTime, String payload,
      [DateTimeComponents? dateTimeComponents]) async {
    final scheduledTime = eventDate.add(Duration(
      hours: eventTime.hour,
      minutes: eventTime.minute,
    ));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //androidAllowWhileIdle: true,
      payload: payload,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  Future<void> showNotificationAtSchedulePreciseDate(int id, String title,
      String body, StatusModel statusModel, DateTime scheduleTime) async {
    // String timeZoneIdentifier = AwesomeNotifications.localTimeZoneIdentifier;
    /*await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'scheduled',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigText,
          payload: {
            'type': 'LogbookStatus',
            'status': statusModel.logbookStatus.toString(),
            'day': statusModel.day.toString(),
            'programId': statusModel.programID.toString()
          },
          autoDismissible: false,
        ),
        schedule: NotificationCalendar.fromDate(
            date: scheduleTime, preciseAlarm: true));*/
  }

  Future<void> showSimpleNotification(String title, String body,
      [RemoteMessage? message]) async {
    String channel = await getFlavors();
//     debugPrint('showSimpleNotification Kidzee $channel');
    debugPrint('Remote message for simple message is - $message');
    String? count =
        await KidzeePref().getString(LocalConstant.KEY_NOTIFICATION_COUNT);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'big_picture',
            title: title,
            bigPicture: message != null && message.data.containsKey('bigimage')
                ? message.data['bigimage']
                : null,
            body: body,
            badge: count != null
                ? int.parse(await KidzeePref()
                        .getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
                    '0')
                : null,
            payload: getPayloadForNotificationClick(message, title, body)));
//     debugPrint('showSimpleNotification');
  }

  Map<String, String?> getPayloadForNotificationClick(
      RemoteMessage? message, String title, String body) {
    return message?.data['type'] == 'cogniHW'
        ? {"title": title, "body": body, 'type': message?.data['type']}
        : message!.data['type'] == 'td'
            ? {
                'promo': "saathi",
                "title": title,
                "body": body,
                "id": message.data['id'],
                "business_user_id": message.data['business_user_id'],
                "type": message.data['type'],
                "bigimage": message.data['bigimage'],
                "actionUrl": message.data['actionUrl'] ?? ''
              }
            : message.data['type'] == 'promo'
                ? {
                    'promo': "true",
                    "title": title,
                    "body": body,
                    "bigimage": message.data['bigimage'],
                    "actionUrl": message.data['actionUrl'] ?? ''
                  }
                : message.data['type'] == 'logout'
                    ? {'type': message.data['type']}
                    : {'url': (message.data['url'] ?? '')};
  }

  Future<void> showBigNotification(String title, String body, String logo,
      String imageUrl, bool showBigTextNotification,
      [RemoteMessage? message]) async {
    String channel = getFlavors() == 'kidzee'
        ? LocalConstant.NOTIFICATION_CHANNEL_KIDZEE
        : LocalConstant.NOTIFICATION_CHANNEL_MLZS;
    log('Data inside remote is - ${message!.data}');
    String? count =
        await KidzeePref().getString(LocalConstant.KEY_NOTIFICATION_COUNT);
    // var notificationDecodedData = jsonDecode(message.data.toString());
//     debugPrint('showBigNotification $channel');
    if (showBigTextNotification) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'big_picture',
            title: title,
            body: body,
            badge: count != null
                ? int.parse(await KidzeePref()
                        .getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
                    '0')
                : null,
            // summary: body,
            autoDismissible: true,
            icon: 'resource://drawable/app_logo',
            backgroundColor: Colors.white54,
            largeIcon: imageUrl,
            // payload: {
            //   'url': message != null ? (message.data['url'] ?? '') : '',
            //   'type': message != null ? (message.data['type'] ?? '') : '',
            //   'topic': message != null ? (message.data['topic'] ?? '') : '',
            //   'bigimage': message != null ? (message.data['bigimage'] ?? '') : ''
            // },
            notificationLayout: NotificationLayout.BigText,
            bigPicture: imageUrl,
            payload: getPayloadForNotificationClick(message, title,
                body) /* message.data['type'] == 'promo'
                ? {
                    'promo': "true",
                    "title": title,
                    "body": body,
                    "bigimage": imageUrl,
                    "actionUrl": message.data['actionUrl'] ?? ''
                  }
                : {'url': message != null ? (message.data['url'] ?? '') : ''} */
            ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'big_picture',
            title: title,
            body: body,
            badge: count != null
                ? int.parse(await KidzeePref()
                        .getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
                    '0')
                : null,
            // summary: body,
            autoDismissible: true,
            icon: 'resource://drawable/app_logo',
            backgroundColor: Colors.white54,
            largeIcon: imageUrl,
            notificationLayout: NotificationLayout.BigPicture,
            payload: getPayloadForNotificationClick(message, title,
                body) /* message.data['type'] == 'promo'
                ? {
                    'promo': "true",
                    "title": title,
                    "body": body,
                    "bigimage": imageUrl,
                    "actionUrl": message.data['actionUrl'] ?? ''
                  }
                : {'url': message != null ? (message.data['url'] ?? '') : ''} */
            ,
            bigPicture: imageUrl),
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future<void> onSelectNotification(String? payload) async {
  await navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => goToUserNotification(/*payload: payload*/)));
}

/*

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';

class NotificationService {

  Future<void> init() async {
    checkPermission();
  }
  showNotification(String title,String body) async {

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id:-1,
            channelKey: LocalConstant.NOTIFICATION_CHANNEL,
            title: title,
            body: body
        )
    );
  }



  showBigNotification(String title,String body,String logo,String imageUrl) async{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
        id: -1,
        channelKey: LocalConstant.NOTIFICATION_CHANNEL,
        title: title,
        body: body,
        autoDismissible: true,
        icon: 'resource://drawable/app_logo',
        backgroundColor: Colors.white54,
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: imageUrl),);
  }
  checkPermission(){
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}*/
