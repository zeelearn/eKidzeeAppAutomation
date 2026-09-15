import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Exception thrown when the URL launcher cannot open a URL.
class LauncherException implements Exception {
  final String message;

  const LauncherException(this.message);

  @override
  String toString() => 'LauncherException: $message';
}

/// Handles URL launching across Android, iOS, and web.
class LauncherService {
  const LauncherService();

  /// Opens the provided URL in a browser or platform-specific handler.
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      throw LauncherException('Cannot launch URL: $url');
    }

    final launched = await launchUrl(
      uri,
      mode: _launchMode,
    );

    if (!launched) {
      throw LauncherException('Failed to launch URL: $url');
    }
  }

  LaunchMode get _launchMode {
    return kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;
  }
}
