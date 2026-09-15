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

  // On web we can only render network URLs for external images.
  if (path.startsWith('http')) {
    return Image.network(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) =>
          placeholder ?? const Icon(Icons.broken_image),
    );
  }

  // Non-http paths are not accessible on web — show placeholder.
  return placeholder ?? const Icon(Icons.broken_image);
}
