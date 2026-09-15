import 'package:ekidzee/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAnalyticsUtils {
  FirebaseAnalytics? analytics;

  FirebaseAnalyticsUtils() {
    if (analytics == null) {
      init();
    }
  }
  init() async {
    analytics = FirebaseAnalytics.instanceFor(
        app: await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform));
  }

  Future<void> sendAnalyticsEvent(String currentScreen) async {
    if (analytics == null) {
      await init();
    }
    await analytics!.logScreenView(
      screenName: currentScreen,
      screenClass: currentScreen,
    );
  }

  enableAnytics() async {
    if (analytics == null) {
      await init();
    }
    await analytics!.setAnalyticsCollectionEnabled(true);
  }

  static sendEvent(String userName) async {
    await FirebaseAnalytics.instance
        .setUserProperty(name: 'login_user', value: userName);
  }

  Future<void> setUserType(String userType) async {
    if (analytics == null) {
      await init();
    }
    await analytics!.setUserProperty(
      name:
          'user_type', // The name of your user property (must match the one registered in Firebase Console)
      value:
          userType, // The value you want to assign (e.g., 'premium', 'guest', 'admin')
    );
    // debugPrint(
    //     'Firebase Analytics: User property "user_type" set to $userType');
  }

  /// Set user properties (persistent per user)
  Future<void> setUserProperties({
    required String userType,
    required String zoneCode,
    required String franchiseecode,
  }) async {
    if (analytics == null) {
      await init();
    }
    await analytics!.setUserProperty(
      name: 'user_type',
      value: userType,
    );

    await analytics!.setUserProperty(
      name: 'zone_code',
      value: zoneCode,
    );

    await analytics!.setUserProperty(
      name: 'franchisee_code',
      value: franchiseecode,
    );
  }

  /// Log custom event
  Future<void> logClassSelection({
    required String term,
    required String className,
    required String curriculumType,
  }) async {
    if (analytics == null) {
      await init();
    }
    await analytics!.logEvent(
      name: 'class_selected',
      parameters: {
        'term': term,
        'class_name': className,
        'curriculum_type': curriculumType
      },
    );
  }

  static captureEvent(String event) async {
    await FirebaseAnalytics.instance.logEvent(name: event);
  }
}
