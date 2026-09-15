import 'dart:convert';

import '../models/user_payload.dart';

/// Exception thrown when payload encoding fails.
class EncoderException implements Exception {
  final String message;

  const EncoderException(this.message);

  @override
  String toString() => 'EncoderException: $message';
}

/// Provides encoding utilities for holiday payloads.
class EncoderService {
  const EncoderService();

  /// Converts the payload to its JSON string representation.
  String toJsonString(UserPayload payload) {
    try {
      return payload.toJsonString();
    } catch (error) {
      throw EncoderException('Failed to convert payload to JSON: $error');
    }
  }

  /// Converts the payload JSON to UTF-8 bytes.
  List<int> toUtf8Bytes(UserPayload payload) {
    try {
      return utf8.encode(toJsonString(payload));
    } catch (error) {
      throw EncoderException(
          'Failed to convert payload to UTF-8 bytes: $error');
    }
  }

  /// Converts the payload JSON to a Base64 encoded string.
  String toBase64String(UserPayload payload) {
    try {
      return base64.encode(toUtf8Bytes(payload));
    } catch (error) {
      throw EncoderException('Failed to convert payload to Base64: $error');
    }
  }

  /// Builds the final holiday URL with encoded payload data.
  String buildEncodedUrl({
    required UserPayload payload,
    required String baseUrl,
  }) {
    final encodedData = toBase64String(payload);
    return '$baseUrl?data=$encodedData';
  }
}
