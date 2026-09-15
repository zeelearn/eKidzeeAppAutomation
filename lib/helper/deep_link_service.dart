import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<DeepLinkService> init() async {
    // Handle app opened from terminated state
    final Uri? initialUri = await _appLinks.getInitialLink();
    _handleUri(initialUri);

    // Handle app opened from background/foreground
    _sub = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );

    return this;
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;

    debugPrint('Deep link received: $uri');

    if (uri.path == '/login') {
      // Optional token handling
      final token = uri.queryParameters['token'];

      Get.toNamed('/login', arguments: {
        'token': token,
      });
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
