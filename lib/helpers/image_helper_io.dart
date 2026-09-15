import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget buildImageWidgetFromPathOrData({
  required String? path,
  Uint8List? imageData,
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  Widget? placeholder,
}) {
  if (path != null && path.startsWith('http')) {
    return Image.network(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) =>
          placeholder ?? const Icon(Icons.broken_image),
    );
  }
  if (imageData != null) {
    return Image.memory(
      imageData,
      fit: fit,
      width: width,
      height: height,
    );
  }

  if (path == null || path.isEmpty) {
    return placeholder ?? const Icon(Icons.camera_alt);
  }

  // Treat as local file path on IO platforms
  final file = File(path);
  if (file.existsSync()) {
    return Image.file(
      file,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) =>
          placeholder ?? const Icon(Icons.broken_image),
    );
  }

  return placeholder ?? const Icon(Icons.broken_image);
}
