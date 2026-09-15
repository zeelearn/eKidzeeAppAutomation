import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

import '../../helper/app_assets.dart';
import 'app_constant.dart';
import 'dashboard.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetLeftEnter;
  late Animation<Offset> _offsetRightEnter;
  late bool isHomePageOpen;

  @override
  void initState() {
    super.initState();
    isHomePageOpen = false;
    _controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _offsetLeftEnter = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(_controller);

    _offsetRightEnter = Tween<Offset>(
      begin: Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Spacer(),
                    InkWell(
                      onTap: () {

                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? AppAssets.ic3dStairsDark
                              : AppAssets.ic3dStairsLight ,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? AppAssets.icDarkMode
                              : AppAssets.icLightMode,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 36),
                        Text(
                          "Math Matrix",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Train Your Brain, Improve Your Math Skill",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        SizedBox(height: 36),
                        DashboardButtonView(
                          dashboard: KeyUtil.dashboardItems[0],
                          position: _offsetLeftEnter,
                          onTab: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              KeyUtil.home,
                              ModalRoute.withName(KeyUtil.dashboard),
                              arguments: Tuple2(KeyUtil.dashboardItems[0],
                                  MediaQuery.of(context).padding.top),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        DashboardButtonView(
                          dashboard: KeyUtil.dashboardItems[1],
                          position: _offsetRightEnter,
                          onTab: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              KeyUtil.home,
                              ModalRoute.withName(KeyUtil.dashboard),
                              arguments: Tuple2(KeyUtil.dashboardItems[1],
                                  MediaQuery.of(context).padding.top),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        DashboardButtonView(
                          dashboard: KeyUtil.dashboardItems[2],
                          position: _offsetLeftEnter,
                          onTab: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              KeyUtil.home,
                              ModalRoute.withName(KeyUtil.dashboard),
                              arguments: Tuple2(KeyUtil.dashboardItems[2],
                                  MediaQuery.of(context).padding.top),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFf7f7f7),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("Math Matrix by Nividata",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(width: 12),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) => Text(
                            "v${snapshot.data?.version}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
