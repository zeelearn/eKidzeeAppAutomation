import 'package:flutter/material.dart';

import '../widget/mywebview.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreen createState() => _SocialScreen();
}

class _SocialScreen extends State<SocialScreen> {
  int _selectedIndex = 0;

  final pages = [
    // MyWebsiteView(title: 'FaceBook', url: 'http://m.facebook.com/KidzeeIndia'),
    FacebookScreen(webUIrl: 'https://www.facebook.com/KidzeeIndia/'),
    // FacebookScreen(webUIrl: 'http://m.facebook.com/KidzeeIndia'),
    TwitterScreen(webUIrl: 'http://twitter.com/KidzeeIndia'),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    //debugPrint("_selectedIndex ${_selectedIndex}");
  }

  @override
  void initState() {
    super.initState();
    //debugPrint('init state ${this._selectedIndex}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.facebook),
                label: 'Facebook',
                backgroundColor: Colors.blueAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.wb_twilight),
                label: 'Twitter',
                backgroundColor: Colors.blueGrey),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: (int index) {
            setState(() {
              //debugPrint('onTap inner clicked ${index}');
              _selectedIndex = index;
            });
          },
          elevation: 5),
    );
  }
}

class FacebookScreen extends StatefulWidget {
  String webUIrl;
  FacebookScreen({super.key, required this.webUIrl});

  @override
  // ignore: library_private_types_in_public_api
  _FacebookScreen createState() => _FacebookScreen();
}

class _FacebookScreen extends State<FacebookScreen> {
  //late WebViewXController webviewController;
  Size get screenSize => MediaQuery.of(context).size;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // webViewController?.clearCache();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWebViewX(),
    );
  }

/*   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          /*Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );*/
        });
  } */

  /*  Widget getWebView(url) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        // this.webViewController = webViewController;
        //debugPrint('FLWEB webview created....');
      },
      onProgress: (int progress) {},
      javascriptChannels: <JavascriptChannel>{
        _toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
//         debugPrint('FLWEB-allowing navigation to 12 $request');
        // if (request.url.contains('profile')) {
        //   firstTime = false;
        //   return NavigationDecision.prevent;
        // }
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {
        //debugPrint('FLWEB-Page onPageFinished loading 1: $url');
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint(
            'Error from webview is - ${error.failingUrl} \n ${error.description} \n ${error.domain} \n ${error.errorType} \n ${error.errorCode}');
        //debugPrint('======');
      },
      gestureNavigationEnabled: true,
      geolocationEnabled: true, // set geolocationEnable true or not
    );
  } */

  Widget _buildWebViewX() {
    return WebWidget.getWebView(context, widget.webUIrl);
  }
}

class TwitterScreen extends StatefulWidget {
  String webUIrl;
  TwitterScreen({super.key, required this.webUIrl});

  @override
  // ignore: library_private_types_in_public_api
  _TwitterScreen createState() => _TwitterScreen();
}

class _TwitterScreen extends State<TwitterScreen> {
  Size get screenSize => MediaQuery.of(context).size;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWebViewX(),
    );
  }

  Widget _buildWebViewX() {
    return WebWidget.getWebView(context, widget.webUIrl);
  }
}
