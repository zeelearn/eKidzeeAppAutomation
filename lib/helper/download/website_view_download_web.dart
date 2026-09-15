import 'package:url_launcher/url_launcher.dart';

const String kConsoleDownloadPrefix = 'dwd::';

Future<void> launchExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<bool> handleConsoleDownload(String message) async {
  if (!message.contains(kConsoleDownloadPrefix)) {
    return false;
  }

  final parts = message.split('::');
  if (parts.length < 2) {
    return false;
  }

  final url = Uri.decodeFull(parts[1].trim());
  await launchExternalUrl(url);
  return false;
}

Future<bool> handleDownloadRequest(String url) async {
  if (url.contains('blob')) {
    return false;
  }

  await launchExternalUrl(url);
  return false;
}
