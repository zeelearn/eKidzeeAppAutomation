import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickContactScreen extends StatefulWidget {
  const QuickContactScreen({super.key});

  @override
  _QuickContactScreen createState() => _QuickContactScreen();
}

class _QuickContactScreen extends State<QuickContactScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quick Contact",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Text(
                                'Customer Helpline',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: GestureDetector(
                                  onTap: () => _mailto(),
                                  child: const Icon(Icons.mail)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: GestureDetector(
                                  onTap: () => launchUrl(
                                      Uri.parse("tel:+91 9930469976")),
                                  child: const Icon(Icons.call)),
                            ),
                          ],
                        )),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'Complaints Regarding:-',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            '* Special Need Student',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            '  Complaint',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            '* Minor Injury',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            '* Transport-Safety Issue',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            '* Cleanliness and Hygiene Issue',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _mailto() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    String userName =
        await KidzeePref().getString(LocalConstant.KEY_USER_NAME) ?? '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceOSVersion = '';
    String deviceModel = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceOSVersion = androidInfo.version.sdkInt.toString();
      deviceModel = androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceOSVersion = iosInfo.systemVersion.toString();
      deviceModel = iosInfo.model.toString();
    } else {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceOSVersion = webBrowserInfo.appVersion.toString();
      deviceModel = webBrowserInfo.appName.toString();
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mishelpdesk@zeelearn.com',
      query: encodeQueryParameters(<String, String>{
        'subject':
            'Mobile Application ${Platform.isAndroid ? '(Android)' : '(IOS)'} Support ',
        'body':
            """UserName: $userName,\n\nDevice OS Version: $deviceOSVersion,\n\nModel Name:  $deviceModel\n\nHello""",
      }),
    );

    launchUrl(emailLaunchUri);
  }
}
