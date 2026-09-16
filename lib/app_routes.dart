import 'package:ekidzee/api/response/bpms/getTaskDetailsResponseModel.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/helper/web_origin_url.dart';
import 'package:ekidzee/pages/attendance/TableEventsExample.dart' /* deferred as tableEventsExample */;
import 'package:ekidzee/pages/attendance/Teach/class_attendance.dart' /* deferred as classAttendance */;
import 'package:ekidzee/pages/bpms/auth/ui/ChatPage.dart' /* deferred as chatPage */;
import 'package:ekidzee/pages/bpms/auth/ui/bpms_home.dart' /* deferred as bpmsHome */;
import 'package:ekidzee/pages/centersetup/communications.dart' /* deferred as communications */;
import 'package:ekidzee/pages/centersetup/indent_history.dart' /* deferred as indentHistory */;
import 'package:ekidzee/pages/contact/contact.dart' /* deferred as contact */;
import 'package:ekidzee/pages/diary/diaryinfo.dart' /* deferred as diaryinfo */;
import 'package:ekidzee/pages/ecampus/widget/pdfviewer.dart' /* deferred as pdfviewer */;
import 'package:ekidzee/pages/events/event_hapening.dart' /* deferred as eventHappening */;
import 'package:ekidzee/pages/holiday.dart' /* deferred as holiday */;
import 'package:ekidzee/pages/intro/splash.dart';
import 'package:ekidzee/pages/k12/core/widgets/vimeo_player.dart';
import 'package:ekidzee/pages/klt/klddashboard.dart' /* deferred as klddashboard */;
import 'package:ekidzee/pages/notification/UserNotification.dart' /* deferred as userNotification */;
import 'package:ekidzee/pages/social.dart' /* deferred as social */;
import 'package:ekidzee/pages/tracker_indent/TrackerOrderScreen.dart' /* deferred as trackerOrderScreen */;
import 'package:ekidzee/pages/userinfo/MyInfoScreen.dart' /* deferred as myInfoScreen */;
import 'package:ekidzee/qr/qr_scannerv2.dart';
import 'package:ekidzee/videoplayer/AudioPlayer.dart' /* deferred as audioPlayer */;
import 'package:ekidzee/videoplayer/KltChewieDemo.dart';
import 'package:ekidzee/videoplayer/RhymesPlayer.dart' /* deferred as rhymesPlayer */;
import 'package:ekidzee/videoplayer/VideoPlayer.dart' /* deferred as videoPlayer */;
import 'package:ekidzee/widget/MyWebSiteView.dart'; /* deferred as mywebsiteview; */
import 'package:ekidzee/widget/image_viewer.dart' /* deferred as imageViewer */;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'pages/klt/models/rhymesmodel.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/bpmshome': (context) =>
      BPMSHome() /* getDeferredWidget(
      child: (context) => bpmsHome.BPMSHome(),
      loadLibrary: bpmsHome.loadLibrary()) */
  ,
  SplashScreen.route: (context) => SplashScreen(),
};

Widget getDeferredWidget(
    {required Future<dynamic> loadLibrary, required WidgetBuilder child}) {
  return FutureBuilder(
    future: loadLibrary,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting ||
          snapshot.connectionState == ConnectionState.active) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text('Error loading module: ${snapshot.error}')),
        );
      } else if (snapshot.connectionState == ConnectionState.done) {
        return child(context);
      } else {
        return child(context);
      }
    },
  );
}

Widget goToMYWebsite({required String title, required String url}) =>
    MyWebsiteView(
        title: title,
        url:
            url) /* getDeferredWidget(
        loadLibrary: mywebsiteview.loadLibrary(),
        child: (context) =>
            mywebsiteview.MyWebsiteView(title: title, url: url)) */
    ;

/// Celebration / promo web links: open externally on iOS (Safari),
/// keep in-app WebView on Android/web.
Future<void> openCelebrationWebsite(
  BuildContext context, {
  required String title,
  required String url,
  bool popCurrent = false,
}) async {
  final resolvedUrl = await Utility.resolveUserPlaceholdersFromSession(url);
  if (resolvedUrl.trim().isEmpty) return;

  if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
    final uri = Uri.tryParse(resolvedUrl);
    if (uri == null) return;
    if (popCurrent && context.mounted) {
      Navigator.of(context).pop();
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return;
  }

  if (popCurrent && context.mounted) {
    Navigator.of(context).pop();
  }
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => goToMYWebsite(title: title, url: resolvedUrl),
    ),
  );
}

Widget goToKltChewieVideo({required String filePath, required String Title}) =>
    KltChewieDemo(
        filePath: filePath,
        Title:
            Title) /* getDeferredWidget(
        loadLibrary: kltchewiedemo.loadLibrary(),
        child: (context) =>
            kltchewiedemo.KltChewieDemo(filePath: filePath, Title: Title)) */
    ;

Widget goToRhymesPlayer(
        {required String filePath,
        required KltRhymesModel videoModel,
        required String Title}) =>
    RhymesPlayer(
      videoModel: videoModel,
      filePath: filePath,
      Title: Title,
    ) /* getDeferredWidget(
        loadLibrary: rhymesPlayer.loadLibrary(),
        child: (context) => rhymesPlayer.RhymesPlayer(
              videoModel: videoModel,
              filePath: filePath,
              Title: Title,
            )) */
    ;

Widget goToMyPdf(
        {required String worksheetUrl,
        required String title,
        required String filename,
        required String module,
        bool isDownload = false}) =>
    MyPdfApp(
      worksheetUrl: worksheetUrl,
      title: title,
      filename: filename,
      module: module,
      isDownload: isDownload,
    ) /*  getDeferredWidget(
        loadLibrary: pdfviewer.loadLibrary(),
        child: (context) => pdfviewer.MyPdfApp(
              worksheetUrl: worksheetUrl,
              title: title,
              filename: filename,
              module: module,
              isDownload: isDownload,
            )) */
    ;

Widget goToTrackOrderScreen({
  required String franchiseeId,
}) =>
    TrackerOrderScreen(
        franchiseeId:
            franchiseeId) /* getDeferredWidget(
        loadLibrary: trackerOrderScreen.loadLibrary(),
        child: (context) =>
            trackerOrderScreen.TrackerOrderScreen(franchiseeId: franchiseeId)) */
    ;

// Widget goToMyLedgerScreen() =>
//     MyLedgerScreen() /* getDeferredWidget(
//     loadLibrary: ledger.loadLibrary(),
//     child: (context) => ledger.MyLedgerScreen()) */
//     ;

// Widget goToHelpDeskScreen() =>
//     HelpDeskScreen() /* getDeferredWidget(
//     loadLibrary: helpDesk.loadLibrary(),
//     child: (context) => helpDesk.HelpDeskScreen()) */
//     ;

Widget goToQuickContactScreen() => QuickContactScreen();

Widget goToTableEventsExample({required String userId}) => TableEventsExample(
      userId: userId,
    );

Widget goToClasswiseAttendance({required String userId}) => ClasswiseAttendance(
      userId: userId,
      /* getDeferredWidget(
    loadLibrary: classAttendance.loadLibrary(),
    child: (context) => classAttendance.ClasswiseAttendance(
          userId: userId,
        ) */
    );

Widget goToEventAndHappeningScreen() =>
    EventAndHappeningScreen() /* getDeferredWidget(
    loadLibrary: eventHappening.loadLibrary(),
    child: (context) => eventHappening.EventAndHappeningScreen()) */
    ;

Widget goToStudentDiaryScreen() =>
    StudentDiaryScreen() /* getDeferredWidget(
    loadLibrary: diaryinfo.loadLibrary(),
    child: (context) => diaryinfo.StudentDiaryScreen()) */
    ;

Widget goToHolidayScreen() =>
    HolidayScreen() /* getDeferredWidget(
    loadLibrary: holiday.loadLibrary(),
    child: (context) => holiday.HolidayScreen()) */
    ;

Widget goToSocialScreen() =>
    SocialScreen() /* getDeferredWidget(
    loadLibrary: social.loadLibrary(),
    child: (context) => social.SocialScreen()) */
    ;

Widget goToKLTScreen() =>
    KLTScreen() /* getDeferredWidget(
    loadLibrary: klddashboard.loadLibrary(),
    child: (context) => klddashboard.KLTScreen()) */
    ;

Widget goToMyInfoScreen() =>
    MyInfoScreen() /* getDeferredWidget(
    loadLibrary: myInfoScreen.loadLibrary(),
    child: (context) => myInfoScreen.MyInfoScreen()) */
    ;

Widget goToIndentHistoryScreen({required int franchiseeid}) =>
    IndentHistoryScreen(
        franchiseeid:
            franchiseeid) /* getDeferredWidget(
        loadLibrary: indentHistory.loadLibrary(),
        child: (context) =>
            indentHistory.IndentHistoryScreen(franchiseeid: franchiseeid)) */
    ;

Widget goToCommunicationScreen({required String franchiseeId}) =>
    CommunicationScreen(
        franchiseeId:
            franchiseeId) /* getDeferredWidget(
        loadLibrary: communications.loadLibrary(),
        child: (context) =>
            communications.CommunicationScreen(franchiseeId: franchiseeId)) */
    ;

Widget goToImageViewer({required String imageUrl}) => ImageViewer(
        imageUrl:
            imageUrl) /*  getDeferredWidget(
    loadLibrary: imageViewer.loadLibrary(),
    child: (context) => imageViewer.ImageViewer(imageUrl: imageUrl)) */
    ;

Widget goToVideoPlayer({required String path, required String Title}) {
  final resolvedPath = WebOriginUrl.mediaStreamUrl(path);
  if (path.contains('vimeo.com')) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Title, style: const TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryLightColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: VimeoPlayerLocal(
        videoId: path.split('/').last,
        mId: 0,
        isPip: false,
      ),
    );
  }
  return VideoPlayer(path: resolvedPath, Title: Title);
}

Widget goToAudioPlayer(
        {required String path,
        required String background,
        required String Title}) =>
    AudioPlayer(
        path: path,
        background: background,
        Title:
            Title) /* getDeferredWidget(
        loadLibrary: audioPlayer.loadLibrary(),
        child: (context) => audioPlayer.AudioPlayer(
            path: path, background: background, Title: Title)) */
    ;

Widget goToChatPage({
  required TaskDetailModel taskModel,
}) =>
    ChatPage(
        taskModel:
            taskModel) /* getDeferredWidget(
        loadLibrary: chatPage.loadLibrary(),
        child: (context) => chatPage.ChatPage(taskModel: taskModel)) */
    ;

Widget goToKidzeeQRScreen() =>
    KidzeeQRScreenV2() /* getDeferredWidget(
    loadLibrary: qrScanner.loadLibrary(),
    child: (context) => qrScanner.KidzeeQRScreen()) */
    ;

Widget goToUserNotification() =>
    UserNotification() /* getDeferredWidget(
    loadLibrary: userNotification.loadLibrary(),
    child: (context) => userNotification.UserNotification()) */
    ;
