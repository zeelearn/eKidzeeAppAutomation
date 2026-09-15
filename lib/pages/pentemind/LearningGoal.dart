// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// //import 'package:flutter_webview_pro/webview_flutter.dart';

// import '../../helper/utils.dart';

// class LearningGoalScreen extends StatefulWidget {
//   String url;
//   //final InAppBrowser browser = new InAppBrowser();
//   LearningGoalScreen({
//     required this.url, required String title
//   });
//   String title='Pentemind';
//   @override
//   LearningGoalState createState() => LearningGoalState();
// }

// class LearningGoalState extends State<LearningGoalScreen> {

//   bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     //debugPrint('Learning Goal init URL ====== ${widget.url}');
//   }

//   // static JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//   //   return JavascriptChannel(
//   //       name: 'Toaster',
//   //       onMessageReceived: (JavascriptMessage message) {
//   //         // ignore: deprecated_member_use
//   //         /*Scaffold.of(context).showSnackBar(
//   //           SnackBar(content: Text(message.message)),
//   //         );*/
//   //       });
//   // }

// @override
//   Widget build(BuildContext context) {
//   widget.url='https://www.google.com/';
//   //debugPrint('Learning Goal BUILD URL ====== ${widget.url}');
//     return  WebView(
//       initialUrl: widget.url,
//       javascriptMode: JavascriptMode.unrestricted,
//       onWebViewCreated: (WebViewController webViewController) {
//         //widget.controller = webViewController;
//       },
//       onProgress: (int progress) {
//         //debugPrint('FLWEB- WebView is loading (progress : $progress%)');

//       },
//       javascriptChannels: <JavascriptChannel>{
//         _toasterJavascriptChannel(context),
//       },
//       navigationDelegate: (NavigationRequest request) {
//         //debugPrint('FLWEB-allowing navigation to $request');
//         return NavigationDecision.navigate;
//       },
//       onPageStarted: (String url) {
//         //debugPrint('FLWEB-Page started loading: $url');
//         Utility.showLoaderDialog(context);
//       },
//       onPageFinished: (String url) {
//         //debugPrint('FLWEB-Page finished loading: $url');
//         Navigator.of(context, rootNavigator: true).pop('dialog');
//       },
//       allowsInlineMediaPlayback: true,
//       gestureNavigationEnabled: false,
//       geolocationEnabled: true, // set geolocationEnable true or not
//     );
//   }

// }
