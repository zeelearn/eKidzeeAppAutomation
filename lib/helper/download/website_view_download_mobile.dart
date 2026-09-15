import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const String kConsoleDownloadPrefix = 'dwd::';

Future<void> launchExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<Directory?> _downloadDirectory() {
  return Platform.isIOS
      ? getApplicationDocumentsDirectory()
      : getExternalStorageDirectory();
}

Future<bool> handleConsoleDownload(String message) async {
  if (!message.contains(kConsoleDownloadPrefix)) {
    return false;
  }

  final parts = message.split('::');
  if (parts.length < 3) {
    return false;
  }

  final url = Uri.decodeFull(parts[1].trim());
  final fileName = parts[2].trim();

  if (Platform.isIOS) {
    await launchExternalUrl(url);
    return false;
  }

  final directory = await _downloadDirectory();
  if (directory == null) {
    return false;
  }

  await FlutterDownloader.enqueue(
    url: url,
    fileName: fileName,
    savedDir: directory.path,
    showNotification: true,
    timeout: 90000,
    requiresStorageNotLow: true,
    openFileFromNotification: true,
    saveInPublicStorage: true,
  );
  return true;
}

Future<bool> handleDownloadRequest(String url) async {
  if (url.contains('blob')) {
    return false;
  }

  if (Platform.isIOS) {
    await launchExternalUrl(url);
    return false;
  }

  final directory = await _downloadDirectory();
  if (directory == null) {
    return false;
  }

  final segments = Uri.parse(url).pathSegments;
  final fileName =
      segments.isNotEmpty ? segments.last : 'download_${DateTime.now().millisecondsSinceEpoch}';

  await FlutterDownloader.enqueue(
    url: url,
    fileName: fileName,
    savedDir: directory.path,
    showNotification: true,
    requiresStorageNotLow: false,
    openFileFromNotification: true,
    saveInPublicStorage: true,
  );
  return true;
}
