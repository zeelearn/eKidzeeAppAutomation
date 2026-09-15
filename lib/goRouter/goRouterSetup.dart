import 'package:ekidzee/pages/intro/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import 'goRouterConstant.dart';

class GoRouterSetup {
  static GoRouter getGoRouter(BuildContext context) {
    return GoRouter(
        initialLocation: GoRouterConstant.splashScreen,
        navigatorKey: MyApp.navigatorKey,
        routes: [
          GoRoute(
            path: GoRouterConstant.splashScreen,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const MaterialPage(child: SplashScreen());
            },
            routes: const <RouteBase>[
              /* GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return const DetailsScreen();
            },
          ), */
            ],
          ),
        ]);
  }
}
