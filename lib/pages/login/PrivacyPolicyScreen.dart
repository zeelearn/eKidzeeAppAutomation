import 'package:ekidzee/constants.dart';
import 'package:ekidzee/widget/mywebview.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            WebWidget.getWebView(
                context, 'https://www.kidzee.com/privacy-policy'),
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 48,
                  width: 48,
                  color: kPrimaryLightColor,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )),
          ],
        ),
        // child: Scaffold(
        //   appBar: AppBar(
        //     title: const Text(''), // You can add title here
        //     leading: IconButton(
        //       icon: Icon(Icons.arrow_back_ios, color: kPrimaryLightColor),
        //       onPressed: () => Navigator.of(context).pop(),
        //     ),
        //     // backgroundColor: kPrimaryLightColor, //You can make this transparent
        //     elevation: 0.0, //No shadow
        //   ),
        //   body: WebWidget.getWebView(
        //       context, 'https://www.kidzee.com/privacy-policy'),
        //   /*body: WebView(
        //     initialUrl: 'https://www.kidzee.com/Home/PrivacyPolicy',
        //   ),*/
        // ),
      ),
    );
  }
}
