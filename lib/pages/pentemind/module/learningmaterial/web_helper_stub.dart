import 'dart:typed_data';

String createBlobUrl(Uint8List bytes, String mimeType) {
  throw UnsupportedError('Cannot create blob URL without dart:html');
}

void revokeBlobUrl(String url) {
  // No-op on non-web platforms
}
