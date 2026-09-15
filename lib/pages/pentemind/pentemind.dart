// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class InAppWebViewPage extends StatefulWidget {
//   @override
//   _InAppWebViewPageState createState() => new _InAppWebViewPageState();
// }
//
// class _InAppWebViewPageState extends State<InAppWebViewPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build12(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text("InAppWebView")
//         ),
//         body: Container(
//             child: Column(children: <Widget>[
//               Expanded(
//                 child: Container(
//                   child: InAppWebView(
//
//                       initialUrlRequest: URLRequest(url: Uri.parse('https://pentemind.com')),
//                       initialOptions: InAppWebViewGroupOptions(
//                         android: AndroidInAppWebViewOptions(
//                           mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//                           saveFormData: true,
//                           supportMultipleWindows: true,
//                           hardwareAcceleration: true,
//                           thirdPartyCookiesEnabled: true,
//                           domStorageEnabled: true,
//                           disableDefaultErrorPage: true,
//                           cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
//                           clearSessionCache: false,
//                           blockNetworkLoads: false,
//                           allowContentAccess: true
//                         ),
//                         crossPlatform: InAppWebViewOptions(
//                           mediaPlaybackRequiresUserGesture: false,
//                           clearCache: false,
//                           javaScriptCanOpenWindowsAutomatically: true,
//                           allowFileAccessFromFileURLs: true,
//                           allowUniversalAccessFromFileURLs: true,
//                           javaScriptEnabled: true,
//                           useShouldInterceptAjaxRequest: true,
//                           useShouldInterceptFetchRequest: true,
//                           useShouldOverrideUrlLoading: true,
//                           useOnDownloadStart: true,
//                           useOnLoadResource: true,
//                           cacheEnabled: true,
//                           incognito: true,
//
//                         ),
//                       ),
//                       onWebViewCreated: (InAppWebViewController controller) {
//                         _webViewController = controller;
//                       },
//                       androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
//                         return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
//                       }
//                   ),
//                 ),
//               ),
//             ])
//         )
//     );
//   }
// }