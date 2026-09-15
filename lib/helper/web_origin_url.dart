import 'package:flutter/foundation.dart';

/// Resolves cross-origin URLs for Flutter Web so browsers do not block requests.
///
/// Mobile/desktop apps are unchanged. On web:
/// - eKidzee API paths use the current page origin when hosted on eKidzee domains.
/// - Dyntube HLS streams can be routed through a CDN proxy (same infra as PDF viewer).
class WebOriginUrl {
  WebOriginUrl._();

  static const String _ekidzeeAppHost = 'app.ekidzee.com';
  static const String _dyntubeHost = 'api.dyntube.com';
  static const String _cdnProxyPrefix =
      'https://cdn-proxy-umber.vercel.app/api/proxy?path=';

  /// Builds a URL for legacy `app.ekidzee.com` API routes.
  ///
  /// On web, prefer [appEkidzeeApiViaPentemind] when the endpoint is also
  /// exposed on the pentemind/kubapi host (same as login and parent info).
  static String appEkidzeeApi(String apiPath) {
    final path = apiPath.startsWith('/') ? apiPath : '/$apiPath';
    if (kIsWeb) {
      final origin = Uri.base.origin;
      if (origin.isNotEmpty && origin != 'null') {
        return '$origin$path';
      }
    }
    return 'https://$_ekidzeeAppHost$path';
  }

  /// Pentemind/kubapi base + GlobalAPI path — used by web for same-origin-free
  /// API access (kubapi already serves login and other GlobalAPIKidzeeV1 routes).
  static String appEkidzeeApiViaPentemind(String pentemindBase, String apiPath) {
    final path = apiPath.startsWith('/') ? apiPath.substring(1) : apiPath;
    final base =
        pentemindBase.endsWith('/') ? pentemindBase : '$pentemindBase/';
    return '$base$path';
  }

  /// Rewrites media stream URLs for web playback when the source is cross-origin.
  static String mediaStreamUrl(String url) {
    if (!kIsWeb || url.isEmpty) {
      return url;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return url;
    }

    if (uri.host.toLowerCase() != _dyntubeHost) {
      return url;
    }

    if (_isEkidzeeHosted(Uri.base.origin)) {
      // Requires server rewrite, e.g. nginx:
      // location /media-proxy/ { proxy_pass https://api.dyntube.com/; }
      return '${Uri.base.origin}/media-proxy${uri.path}'
          '${uri.hasQuery ? '?${uri.query}' : ''}';
    }

    return cdnProxyUrl(url);
  }

  /// CDN proxy used elsewhere in the app (PDF viewer) for cross-origin assets.
  static String cdnProxyUrl(String url) =>
      '$_cdnProxyPrefix${Uri.encodeComponent(url)}';

  static bool isCrossOriginMedia(String url) {
    if (!kIsWeb) {
      return false;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return false;
    }
    return uri.origin != Uri.base.origin;
  }

  static bool isHlsUrl(String url) =>
      url.toLowerCase().contains('.m3u8');

  static bool _isEkidzeeHosted(String origin) {
    final host = Uri.tryParse(origin)?.host.toLowerCase() ?? '';
    if (host.isEmpty) {
      return false;
    }
    return host.contains('ekidzee.com') ||
        host.contains('kidzee.com') ||
        host.contains('zeelearn.com');
  }
}
