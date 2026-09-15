import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Host suffixes used by eKidzee / Pentemind web content.
const trustedWebViewHostSuffixes = [
  'kidzee.com',
  'ekidzee.com',
  'kidzeeplus.com',
  'zeelearn.com',
  'zeelearn.in',
  'pentemind.com',
  'elasticbeanstalk.com',
  'amazonaws.com',
  'web.app',
];

bool isTrustedWebViewHost(String? host) {
  if (host == null || host.isEmpty) {
    return false;
  }

  final normalized = host.toLowerCase();
  return trustedWebViewHostSuffixes.any(
    (suffix) => normalized == suffix || normalized.endsWith('.$suffix'),
  );
}

Future<ServerTrustAuthResponse> handleServerTrustAuthRequest(
  URLAuthenticationChallenge challenge,
) async {
  final host = challenge.protectionSpace.host;

  if (isTrustedWebViewHost(host)) {
    return ServerTrustAuthResponse(
      action: ServerTrustAuthResponseAction.PROCEED,
    );
  }

  return ServerTrustAuthResponse(
    action: ServerTrustAuthResponseAction.CANCEL,
  );
}

bool isSslWebResourceError(WebResourceErrorType type) {
  return type == WebResourceErrorType.FAILED_SSL_HANDSHAKE ||
      type == WebResourceErrorType.SECURE_CONNECTION_FAILED ||
      type == WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE ||
      type == WebResourceErrorType.SERVER_CERTIFICATE_HAS_UNKNOWN_ROOT ||
      type == WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID ||
      type == WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED;
}

String formatWebResourceError(WebResourceError error) {
  if (isSslWebResourceError(error.type)) {
    return 'Secure connection failed. The server certificate for this site '
        'is not trusted (${error.description}).';
  }

  if (error.description.isNotEmpty) {
    return error.description;
  }

  return error.type.toString();
}
