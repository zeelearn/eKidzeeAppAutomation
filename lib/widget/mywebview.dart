import 'package:ekidzee/widget/MyWebSiteView.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:lottie/lottie.dart';

class WebWidget {
  // late WebViewController _controller;

  // static JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'kidzee',
  //       onMessageReceived: (JavascriptMessage message) {
  //         // ignore: deprecated_member_use
  //         /*Scaffold.of(context).showSnackBar(
  //           SnackBar(content: Text(message.message)),
  //         );*/
  //       });
  // }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Lottie.asset('assets/json/kidzee_loader.json'),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget getCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 32.0, // You can adjust the size as needed
        height: 32.0, // You can adjust the size as needed
        decoration: BoxDecoration(
          color: Colors.red, // Background color
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          border: Border.all(
            color: Colors.black, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: Center(
          child: Icon(
            Icons.close, // Cross icon
            color: Colors.white, // Icon color
            size: 18.0, // Icon size
          ),
        ),
      ),
    );
  }

  static Widget getWebView(BuildContext context, String url) {
    //debugPrint(url);
    return MyWebsiteView(title: '', url: url);
    // return WebView(
    //   initialUrl: url,
    //   javascriptMode: JavascriptMode.unrestricted,
    //   onWebViewCreated: (WebViewController webViewController) {
    //     //_controller.complete(webViewController);
    //   },
    //   onProgress: (int progress) {
    //     //debugPrint('FLWEB- WebView is loading (progress : $progress%)');

    //   },
    //   javascriptChannels: <JavascriptChannel>{
    //     _toasterJavascriptChannel(context),
    //   },
    //   navigationDelegate: (NavigationRequest request) {
    //     if (request.url.startsWith('https://www.youtube.com/')) {
    //       //debugPrint('FLWEB- blocking navigation to $request}');
    //       return NavigationDecision.prevent;
    //     }
    //     //debugPrint('FLWEB-allowing navigation to $request');
    //     return NavigationDecision.navigate;
    //   },
    //   onPageStarted: (String url) {
    //     //debugPrint('FLWEB-Page started loading: $url');
    //     //showLoaderDialog(context);
    //   },
    //   onPageFinished: (String url) {
    //     //debugPrint('FLWEB-Page finished loading: $url');
    //     //Navigator.of(context, rootNavigator: true).pop('dialog');
    //   },
    //   gestureNavigationEnabled: true,
    //   geolocationEnabled: true, // set geolocationEnable true or not
    // );
  }
}
