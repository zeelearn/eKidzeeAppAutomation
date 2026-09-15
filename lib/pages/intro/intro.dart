import 'package:ekidzee/helper/ColorsSys.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/login/new/securelogin.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';
import '../login/new/login.dart';
import '../login/ui2/login.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreenV2()),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: Text(
                'Skip',
                style: TextStyle(
                    color: ColorSys.gray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: _pageController,
              children: <Widget>[
                makePage(
                    image: 'assets/splash/splashone.png',
                    title: LocalStrings.stepOneTitle,
                    content: LocalStrings.stepOneContent),
                makePage(
                    reverse: true,
                    image: 'assets/splash/splashtwo.png',
                    title: LocalStrings.stepTwoTitle,
                    content: LocalStrings.stepTwoContent),
                makePage(
                    image: 'assets/splash/splashthree.png',
                    title: LocalStrings.stepThreeTitle,
                    content: LocalStrings.stepThreeContent),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  // primary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreenV2()),
                  );
                },
                child: Text(
                  'Start Now',
                  style: LightColors.textHeaderStyleWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
                color: ColorSys.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorSys.gray,
                fontSize: 20,
                fontWeight: FontWeight.w400),
          ),
          reverse
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.secoundry, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
