import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekidzee/firebase_options.dart';
import 'package:ekidzee/pages/feedback/survery_hive_model/survey_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/LocalConstant.dart';

class SurveyFirestore {
  static String KEY_USERS_LOG = "surveylog";

  static FirebaseFirestore? fireStore;

  static Future<void> getFireStore() async {
    if (fireStore != null) {
    } else {
      FirebaseApp mApp;
      // if (kIsWeb) {
      //   app = await Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform /*  name: "litrahub" */,
      //   );
      // } else {
      //   app = await Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform,
      //     name: 'octaveapp',
      //   );
      // }
      if (kIsWeb) {
        mApp = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
          name: 'octaveapp', // or default if not needed
        );
      } else {
        // 🚫 DO NOT use custom name for mobile
        // mApp = await Firebase.initializeApp(
        //     options: DefaultFirebaseOptions.currentPlatform, name: 'octaveapp');

        List<FirebaseApp> firebaseAppList = Firebase.apps;
        if (firebaseAppList.isEmpty ||
            !firebaseAppList.any((app) => app.name == 'octaveapp')) {
          mApp = await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
              name: 'octaveapp');
        } else {
          mApp = firebaseAppList.where((app) => app.name == 'octaveapp').first;

          debugPrint('Firebase already initialized');
        }
      }

      fireStore = FirebaseFirestore.instanceFor(app: mApp);
    }
  }

  static Future<void> addCompletedSurvey({required String surveyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getFireStore();
    String userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    var userdoc = await fireStore!.collection(KEY_USERS_LOG).doc(userId).get();
    if (userdoc.exists) {
      await fireStore!.collection(KEY_USERS_LOG).doc(userId).update({
        'completed_surveys': FieldValue.arrayUnion([
          {
            'survey_id': surveyId,
            'completed_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          }
        ])
      });
    } else {
      await fireStore!.collection(KEY_USERS_LOG).doc(userId).set({
        'completed_surveys': FieldValue.arrayUnion([
          {
            'survey_id': surveyId,
            'completed_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          }
        ])
      });
    }
  }

  static Future<void> addCompletedSurveyonLogintoOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getFireStore();
    String userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    final userDoc =
        await fireStore!.collection(KEY_USERS_LOG).doc(userId).get();
    if (userDoc.exists) {
      final completedList =
          List<Map<String, dynamic>>.from(userDoc['completed_surveys'] ?? []);

      var box = await Hive.openBox<SurveyModel>(LocalConstant.surveyBox);
      for (var element in completedList) {
        box.add(SurveyModel(
            survey_id: element['survey_id'],
            completed: true,
            completed_date: element['completed_date'],
            userId: userId));
      }
    } else {
      await fireStore!
          .collection(KEY_USERS_LOG)
          .doc(userId)
          .set({'completed_surveys': FieldValue.arrayUnion([])});
    }
  }
}
