import 'package:flutter/foundation.dart';

/// Resolves cross-origin URLs for Flutter Web so browsers do not block requests.
///
/// Mobile/desktop apps are unchanged. On web:
/// - eKidzee API paths use the current page origin when hosted on eKidzee domains.
/// - Cross-origin media (Dyntube, ZeeLearn CDN, S3, etc.) routes through CDN proxy.
class WebOriginUrl {
  WebOriginUrl._();

  static const String _ekidzeeAppHost = 'app.ekidzee.com';
  static const String _cdnProxyPrefix =
      'https://cdn-proxy-umber.vercel.app/api/proxy?path=';

  /// Hosts that commonly fail CORS when fetched directly from the browser.
  static const Set<String> _proxyMediaHosts = {
    'api.dyntube.com',
    'cdn.dyntube.net',
    'cdn.zeelearn.com',
    's3.ap-south-1.amazonaws.com',
    'content.pentemind.com',
    'firebasestorage.googleapis.com',
    '103.241.146.154',
  };

  /// Builds a URL for legacy `app.ekidzee.com` API routes.
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

  /// Rewrites media stream / asset URLs for web playback when the source is
  /// cross-origin and known to need a proxy.
  static String mediaStreamUrl(String url) {
    if (!kIsWeb || url.isEmpty) {
      return url;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return url;
    }

    final host = uri.host.toLowerCase();
    if (!_needsMediaProxy(host)) {
      return url;
    }

    // Prefer same-origin media-proxy only for Dyntube when hosted on Kidzee
    // domains (requires nginx: /media-proxy/ -> api.dyntube.com/).
    if (host == 'api.dyntube.com' && _isEkidzeeHosted(Uri.base.origin)) {
      return '${Uri.base.origin}/media-proxy${uri.path}'
          '${uri.hasQuery ? '?${uri.query}' : ''}';
    }

    return cdnProxyUrl(url);
  }

  /// Optional helper for NetworkImage / thumbnail URLs on web.
  static String assetUrl(String url) => mediaStreamUrl(url);

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

  static bool _needsMediaProxy(String host) {
    if (_proxyMediaHosts.contains(host)) return true;
    for (final allowed in _proxyMediaHosts) {
      if (host == allowed || host.endsWith('.$allowed')) return true;
    }
    // Any amazonaws S3 regional host.
    if (host.endsWith('.amazonaws.com')) return true;
    return false;
  }

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
