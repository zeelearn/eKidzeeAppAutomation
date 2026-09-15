import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String createBlobUrl(Uint8List bytes, String mimeType) {
  final blob = html.Blob([bytes], mimeType);
  return html.Url.createObjectUrl(blob);
}

void revokeBlobUrl(String url) {
  try {
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    // Silently fail if URL is already revoked or invalid
  }
}
