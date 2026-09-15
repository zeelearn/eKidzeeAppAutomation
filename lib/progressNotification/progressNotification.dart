import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class ProgressNotification {
  static int currentStep = 0;
  static Timer? udpateNotificationAfter1Second;
  static Future<void> showProgressNotification(
      int id, int maxStep, int currentStep, String filePath) async {
    // int maxStep = 10;
    int fragmentation = 4;
    for (var simulatedStep = 1; simulatedStep <= maxStep; simulatedStep++) {
      // currentStep = simulatedStep;
      await Future.delayed(Duration(milliseconds: 1000 ~/ fragmentation));
      if (udpateNotificationAfter1Second != null) continue;
      udpateNotificationAfter1Second = Timer(const Duration(seconds: 1), () {
        updateCurrentProgressBar(
            id: id,
            simulatedStep: currentStep,
            maxStep: maxStep,
            filename: filePath);
        udpateNotificationAfter1Second?.cancel();
        udpateNotificationAfter1Second = null;
      });
    }
  }

  static void updateCurrentProgressBar(
      {required int id,
      required int simulatedStep,
      required int maxStep,
      required String filename}) {
    int progress = min((simulatedStep / maxStep * 100).round(), 100);
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'progress_bar',
            title: 'Uploading $filename in progress ($progress%)',
            body: filename.split('/').last.split('.').first,
            category: NotificationCategory.Progress,
            payload: {
              // 'file': 'filename.txt',
              // 'path': '-rmdir c://ruwindows/system32/huehuehue'
            },
            notificationLayout: NotificationLayout.ProgressBar,
            progress: progress.toDouble(),
            locked: progress == 100 ? false : true));
    if (progress == 100) {
      cancelNotification(12423);
      showCompleteNotification(
          id: 124231,
          simulatedStep: simulatedStep,
          maxStep: maxStep,
          filename: filename);
    }
  }

  static void cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> showCompleteNotification(
      {required int id,
      required int simulatedStep,
      required int maxStep,
      required String filename}) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'alerts',
            title: 'Upload finished',
            body: filename,
            category: NotificationCategory.Progress,
            payload: {
              'Video_path': filename,
              // 'path': '-rmdir c://ruwindows/system32/huehuehue'
            },
            // timeoutAfter: const Duration(minutes: 10),
            locked: false),
        actionButtons: [
          NotificationActionButton(key: 'open_video', label: 'Open Video')
        ]);
  }

  static Future<void> cancelAllNotification() async {
    await AwesomeNotifications().cancelAll();
  }
}
