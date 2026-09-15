import 'dart:developer';

import 'package:ekidzee/pages/notification/NotificationService.dart';
import 'package:ekidzee/pushNotification/promoNotificationDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../helper/DatabaseHelper.dart';
import '../helper/KidzeePref.dart';
import '../helper/LocalConstant.dart';
import '../main.dart';
import '../pages/home/homeProvider/notificationCountProvider.dart';

class PushNotificationSetup {
  Future<void> initialize(BuildContext context, WidgetRef ref) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint('Got a message whilst in the foreground!');
      log("kidzee Handling a background message 13 : ${message.toMap()}");

      String cdate = DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now());

      // String? imsageUrl = '';
      // if (Platform.isAndroid) {
      //   imsageUrl = message.notification?.android?.imageUrl.toString();
      // } else if (Platform.isIOS) {
      //   imsageUrl = message.notification?.apple?.imageUrl.toString();
      // }
      DBHelper helper = DBHelper();
      Map<String, String> data = {};
      //debugPrint('message ${message.notification}');
      /*  if (kIsWeb) {
        Get.snackbar(
          message.data['title'], // Title
          message.data['body'], // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: kPrimaryLightColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else */
      if (message.notification != null) {
//         debugPrint('its simple Notification push 34');

        data.putIfAbsent('title', () => message.notification?.title as String);
        data.putIfAbsent(
            'description', () => message.notification?.body as String);
        data.putIfAbsent('type', () => 'push');
        data.putIfAbsent('date', () => cdate);
        data.putIfAbsent('imageurl', () => message.data['url'] ?? '');
        helper.insert(LocalConstant.TABLE_NOTIFICATION, data);
        var count = (int.parse(await KidzeePref()
                    .getString(LocalConstant.KEY_NOTIFICATION_COUNT) ??
                '0') +
            1);
        KidzeePref()
            .setString(LocalConstant.KEY_NOTIFICATION_COUNT, count.toString());
        KidzeePref()
            .setString(LocalConstant.KEY_SHOWNOTIFICATION_COUNT, 'true');
        ref.read(countProvider.notifier).update((state) => count);
        NotificationService notificationService = NotificationService();
        notificationService.showSimpleNotification(
            message.notification?.title as String,
            message.notification?.body as String,
            message);
      } else {
        if (message.data.containsKey('type') && message.data['type'] == 'td' ||
            message.data['type'] == 'chat') {
//           debugPrint('its zllSaathiNotification Notification Push');

          zllSaathiNotification(message);
        } else if (message.data.containsKey('topic') &&
            message.data['topic'] != '') {
//           debugPrint('receive in data notification ${message.data['topic']}');
          identifyNotification(message, ref);
        } else {
          //showNotification(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('OnMessageOpened is getting called - ${event.data}');
      if (event.data['type'] == 'promo') {
        PromoNotification.displayPromoNotification(event.data['title'],
            event.data['body'], event.data['bigimage'], null);
      }
    });

    // FirebaseMessaging.instance.getInitialMessage().then((value) {
    //   log('GetInitialMessage is getting called - $value');
    //   if (value != null &&
    //       value.data['type'] != null &&
    //       value.data['type'] == 'promo') {
    //     PromoNotification.displayPromoNotification(value.data['title'],
    //         value.data['body'], value.data['bigimage'], null);
    //   }
    // });
  }
}
