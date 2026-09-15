import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/LocalConstant.dart';
import '../home/home_screen.dart';

class PentemindSplashScreen extends StatefulWidget {
  bool isKES;

  PentemindSplashScreen({super.key, required this.isKES});

  @override
  _PentemindSplashScreenState createState() => _PentemindSplashScreenState();
}

class _PentemindSplashScreenState extends State<PentemindSplashScreen> {
  Future<Timer> startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();

    //navigate();
  }

  Future<void> getUserInfo() async {
    startTime();
  }

  void showKESBackground(profileImage) {
    widget.isKES = true;
    setState(() {});
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                      profileImage: profileImage,
                      title:
                          '') /* getDeferredWidget(
                      child: (context) => homeScreen.MyHomePage(
                          profileImage: profileImage, title: ''),
                      loadLibrary: homeScreen.loadLibrary()) */
                  ),
            ));
  }

  Future<void> initData() async {
    //isKESType();
    //getPentemindToken();
    navigate("");
  }

  void navigate(String profileImage) async {
    //if (!kIsWeb) {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                      profileImage: profileImage,
                      title:
                          '') /* getDeferredWidget(
                      child: (context) => homeScreen.MyHomePage(
                          profileImage: profileImage, title: ''),
                      loadLibrary: homeScreen.loadLibrary()) */
                  ),
            ));
    //}
  }

  void navigationPage() {
    navigate("");
    //Navigator.of(context).pushReplacementNamed('/pages/intro/IntroPage');
  }

  Center showCognimindWidgets() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 400, // enough space for both logos after animation
        child: Stack(
          alignment: Alignment.center,
          children: [
            // First logo animates upward
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              alignment: widget.isKES ? Alignment.topCenter : Alignment.center,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 600),
                padding: EdgeInsets.only(
                  top: widget.isKES ? 0 : 0,
                  bottom: widget.isKES ? 180 : 0, // push up smoothly
                ),
                child: Image.asset(
                  'assets/icons/pentemindlogo.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Second logo appears from below
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              alignment:
                  widget.isKES ? Alignment.bottomCenter : Alignment.center,
              child: AnimatedOpacity(
                opacity: widget.isKES ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/icons/congnimind_logo.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold showCognimidWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/pentemindlogo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Second logo (animated visibility)
            AnimatedOpacity(
              opacity: /* widget.isKES ? 1.0 : */ 1.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/icons/congnimind_logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            // Image.asset(
            //   'assets/icons/congnimind_logo.png',
            //   width: 300,
            //   height: 300,
            //   fit: BoxFit.contain,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocalConstant.isCognimind
        ? showCognimidWidget()
        : Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                widget.isKES
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Spacer(),
                          // Image.asset(
                          //   'assets/icons/pentemindlogo.png',
                          //   height: Get.height * 0.2,
                          // ),
                          // Spacer(),
                          Image.asset(
                            'assets/splash/kes_splash.jpg',
                            height: Get.height * 0.7,
                          ),
                          //Spacer(),
                        ],
                      )
                    : Container(
                        child: Center(
                          child: Image.asset(
                            'assets/icons/pentemindlogo.png',
                            height: Get.height * 0.4,
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //     color: Colors.white,
                        //
                        //     image: DecorationImage(
                        //
                        //         image: AssetImage( 'assets/icons/pentemindlogo.png'))
                        //             //image: AssetImage('assets/splash/kes_splash.jpg'))
                        //         ),
                      ),
                // widget.isKES
                //     ? Container()
                //     : ,
              ],
            ),
          );
  }
}
