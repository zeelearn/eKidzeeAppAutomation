import 'dart:async';
import 'dart:io';

import 'package:ekidzee/helper/image_constant.dart';
import 'package:ekidzee/main.dart';
import 'package:ekidzee/pages/bpms/auth/ui/bpms_home.dart' /* deferred as bpmsHome */;
import 'package:ekidzee/pages/intro/intro.dart' /* deferred as introPage */;
import 'package:ekidzee/pages/intro/pentemind_splash.dart' /* deferred as pentemindSplash */;
import 'package:ekidzee/pages/login/otp.dart' /* deferred as otpPage */;
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'dart:html';

import '../../constants.dart';
import '../../globals.dart';
import '../../helper/KidzeePref.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/protectus.dart';
import '../login/ui2/app_background.dart';
import '../login/ui2/login.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const route = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  KidzeePref pref = KidzeePref();
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  bool isKES = false;
  int ayId = 0;

  Future<Timer> startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  // checkLoginStatus() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   if(pref.getString(key))
  // }

  @override
  void initState() {
    ProtectMyScreen().proectScreen(context);
    super.initState();

    navigate();
  }

  void _protectDataLeakageOn() async {
    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithColor(Colors.white);
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  Future<void> updatePentemindUrl(url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalConstant.KEY_PENTEMIND_URL, url);
  }

  bool isBPCetUp = false;
  void navigate() async {
    await getFlavors();
//     debugPrint("-------init---=-=-=-=-=-=-");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ayId = prefs.getInt(LocalConstant.KEY_ACADEMICYEAR) ?? 0;
    isKES = prefs.containsKey(LocalConstant.KEY_IS_KES)
        ? prefs.getBool(LocalConstant.KEY_IS_KES)!
        : false;

    LocalConstant.isCognimind = ayId >= 26 && isKES;
    String displayName = '';
    String userName = '';
    String mobileNumber = '';
//     debugPrint('navigate');
    pref.init();
    if (prefs.containsKey(LocalConstant.KEY_DISPLAY_NAME)) {
      displayName = prefs.containsKey(LocalConstant.KEY_DISPLAY_NAME)
          ? prefs.getString(LocalConstant.KEY_DISPLAY_NAME) as String
          : '';
      userName = prefs.containsKey(LocalConstant.KEY_DISPLAY_NAME)
          ? prefs.getString(LocalConstant.KEY_DISPLAY_NAME) as String
          : '';
      mobileNumber = prefs.containsKey(LocalConstant.KEY_MOBILENO)
          ? prefs.getString(LocalConstant.KEY_MOBILENO) as String
          : '';
      var isBp = prefs.containsKey(LocalConstant.KEY_IS_CENTER_SETUP)
          ? prefs.getString(LocalConstant.KEY_IS_CENTER_SETUP) as String
          : 'false';
      if (isBp == 'true') {
        isBPCetUp = true;
      }
    }

    Map<String, String> params =
        {}; // Uri.parse(window.location.href).queryParameters;

    var isOtpVerified = prefs.getString(LocalConstant.KEY_IS_OTP_VERIFIED);
    if (displayName != '') {
      if (isOtpVerified == 'true') {
        Timer(const Duration(seconds: 1), () => navigationPage());
      } else {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Otp(
                          mobileNumber: mobileNumber,
                          userName:
                              userName) /* getDeferredWidget(
                          child: (context) => otpPage.Otp(
                              mobileNumber: mobileNumber, userName: userName),
                          loadLibrary: otpPage.loadLibrary()) */
                      ),
                ));
      }
    } else {
//       debugPrint(' in else');
      if (kIsWeb) {
        Timer(
            const Duration(seconds: 0),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreenV2())));
      } else {
        //IntroPage
        //debugPrint('intro');
        Timer(
            const Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    IntroPage() /* getDeferredWidget(
                    child: (context) => introPage.IntroPage(),
                    loadLibrary: introPage.loadLibrary()) */
                )));
      }
    }
  }

  void navigationPage() {
    //initializeService();
    if (isBPCetUp) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BPMSHome() /* getDeferredWidget(
                child: (context) => bpmsHome.BPMSHome(),
                loadLibrary: bpmsHome.loadLibrary()) */
            ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => PentemindSplashScreen(
                isKES:
                    isKES) /* getDeferredWidget(
                child: (context) =>
                    pentemindSplash.PentemindSplashScreen(isKES: isKES),
                loadLibrary: pentemindSplash
                    .loadLibrary()) */ /*CenterSetupProgress(crnNumber: '123', displayName: 'Sudhir Patil',userId:'0',franchiseeid:36492)*/),
        (route) => false,
      );
    }
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Screen Recording...')));
    }
    return null;
  }

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(
      () {
        // Screenshot
        debugPrint('Screenshot:');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Screenshot!')));
      },
      (isCaptured) {
        // Screen Record
        debugPrint('Screen Record:');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Screen Record!')));
      },
    );
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }

  @override
  void dispose() async {
    ProtectMyScreen().removeProtection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryLightColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
//     debugPrint('Splash screen Flavor $AppFlavor');
    return BackgroundScaffold(
      bottomNavigationBar: kIsWeb
          ? null
          : Container(
              color: LightColors.kLightGrayM,
              child: (Text(
                appVersion!,
                style: LightColors.textSmallStyle,
                textAlign: TextAlign.center,
              )),
            ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppFlavor == 'kidzee'
                    ? Image.asset(
                        ImageConstant.imgAppLogo,
                        height: 200,
                      )
                    : Lottie.asset('assets/json/$AppFlavor/splash.json',
                        width: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
