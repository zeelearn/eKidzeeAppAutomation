import 'dart:async';

import 'package:ekidzee/api/ServiceHandler.dart';
import 'package:ekidzee/api/request/fcmRequest.dart';
import 'package:ekidzee/iface/onResponse.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/anylatics.dart';
import '../helper/LocalConstant.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(name: "Kidzee");

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  static Future<void> init() async {
    /* if (kIsWeb) {
      await Firebase.initializeApp(
          name: 'kidzee', options: DefaultFirebaseOptions.currentPlatform);
    } else {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } */
  }

  static bool _isInitialized = false;

  void setNotifications(
      String userId,
      String userType,
      int appversion,
      String deviceId,
      String userAgent,
      String businessType,
      String source,
      onResponse response) {
    if (_isInitialized) {
      debugPrint('FCM listeners already initialized, skipping...');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        debugPrint(message.toString());
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
      },
    );

    // Setup token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateFCM(newToken, userId, userType, appversion, deviceId, businessType,
          source, userAgent, response);
    });

    _isInitialized = true;
    debugPrint('FCM listeners initialized successfully.');
  }

  static Future<void> updateFCM(
      String token,
      String userId,
      String userType,
      int appversioncode,
      deviceId,
      String businessType,
      source,
      userAgent,
      onResponse response) async {
    var prefs = await SharedPreferences.getInstance();
    // Use a unique key per user to ensure token is updated when switching users
    final String storageKey = "${LocalConstant.KEY_FCM_TOKEN}_$userId";
    var oldToken = prefs.getString(storageKey);

    debugPrint('Checking FCM token update for user $userId');
    if (oldToken == null || oldToken != token) {
      debugPrint('Token changed or new: updating backend...');

      UpdateFcmRequest request = UpdateFcmRequest(
          FCM_Reg_ID: token,
          User_ID: userId,
          App_Version_Code: appversioncode.toString(),
          User_Type: userType,
          login_source: source,
          mobile_imei: deviceId,
          DeviceId: deviceId,
          Ip_Address: '',
          Buinsess_type: businessType);

      // We wrap the response to save the token in shared preferences ONLY on success
      ApiServiceHandler().updateFCM(
          request, _FCMOnResponseWrapper(response, token, storageKey));
    } else {
      debugPrint('FCM token already up to date for this user');
    }
  }

  void dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}

class _FCMOnResponseWrapper extends onResponse {
  final onResponse originalResponse;
  final String token;
  final String storageKey;

  _FCMOnResponseWrapper(this.originalResponse, this.token, this.storageKey);

  @override
  void onError(int action, dynamic value) {
    debugPrint('FCM token update failed: $value');
    originalResponse.onError(action, value);
  }

  @override
  void onResponseStart() {
    originalResponse.onResponseStart();
  }

  @override
  void onSuccess(dynamic value) async {
    debugPrint('FCM token update successful, saving locally...');
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, token);
    String userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    FirebaseAnalyticsUtils().setUserType(userType);
    originalResponse.onSuccess(value);
  }
}
