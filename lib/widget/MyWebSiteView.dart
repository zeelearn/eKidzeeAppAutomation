import 'dart:async';
import 'dart:collection';

import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/download/website_view_download.dart';
import 'package:ekidzee/helper/webview_trusted_hosts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// Cross-platform WebView for loading remote URLs or inline HTML content.
///
/// Supports Android, iOS, and Web via [flutter_inappwebview].
class MyWebsiteView extends StatefulWidget {
  const MyWebsiteView({
    super.key,
    required this.title,
    required this.url,
    this.data,
  });

  final String title;
  final String url;
  final String? data;

  @override
  State<MyWebsiteView> createState() => _MyWebsiteViewState();
}

class _MyWebsiteViewState extends State<MyWebsiteView> {
  static const _titlesWithoutAppBar = {'Parent Support Desk', 'ZLLSaathi'};
  static const _allowedSchemes = {
    'http',
    'https',
    'file',
    'chrome',
    'data',
    'javascript',
    'about',
  };

  final GlobalKey _webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  PullToRefreshController? _pullToRefreshController;
  Timer? _loadingTimeout;

  double _progress = 0;
  bool _isLoading = false;
  bool _settingsReady =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android ? false : true;
  String? _errorTitle;
  String? _errorMessage;

  static const _viewportUserScript = r'''
(function () {
  function setViewport() {
    var head = document.head || document.getElementsByTagName('head')[0];
    if (!head) return;

    var viewport = document.querySelector('meta[name="viewport"]');
    if (!viewport) {
      viewport = document.createElement('meta');
      viewport.name = 'viewport';
      head.appendChild(viewport);
    }
    viewport.setAttribute(
      'content',
      'width=device-width, initial-scale=1.0, viewport-fit=cover'
    );
  }

  setViewport();
  document.addEventListener('DOMContentLoaded', setViewport, { once: true });
})();
''';

  InAppWebViewSettings _buildSettings({String? userAgent}) {
    final settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      javaScriptEnabled: true,
      clearCache: true,
      cacheMode: CacheMode.LOAD_NO_CACHE,
      javaScriptCanOpenWindowsAutomatically: true,
      mediaPlaybackRequiresUserGesture: false,
      allowContentAccess: true,
      allowFileAccess: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      allowsInlineMediaPlayback: true,
      useOnDownloadStart: !kIsWeb,
      iframeAllow: 'camera; microphone; geolocation',
      iframeAllowFullscreen: true,
      transparentBackground: false,
      supportZoom: true,
      verticalScrollBarEnabled: true,
      horizontalScrollBarEnabled: true,
      cacheEnabled: true,
      domStorageEnabled: true,
      databaseEnabled: true,
      thirdPartyCookiesEnabled: true,
      hardwareAcceleration: true,
      useWideViewPort: true,
      loadWithOverviewMode: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      useShouldOverrideUrlLoading: true,
    );

    if (userAgent != null) {
      settings.userAgent = userAgent;
    }

    return settings;
  }

  late InAppWebViewSettings _settings;

  bool get _hideAppBar =>
      widget.title.isEmpty || _titlesWithoutAppBar.contains(widget.title);

  bool get _hasHtmlData => widget.data != null && widget.data!.isNotEmpty;

  WebUri? get _htmlBaseUrl {
    if (!_hasHtmlData) {
      return null;
    }

    final uri = Uri.tryParse(_normalizedUrl);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }

    return WebUri(_normalizedUrl);
  }

  String get _normalizedUrl {
    final trimmed = widget.url.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) {
      return 'https://$trimmed';
    }
    return trimmed;
  }

  bool get _hasLoadTarget => _hasHtmlData || _normalizedUrl.isNotEmpty;

  String? get _invalidUrlMessage {
    if (_hasHtmlData) {
      return null;
    }

    if (_normalizedUrl.isEmpty) {
      return 'No URL was provided to open this page.';
    }

    final uri = Uri.tryParse(_normalizedUrl);
    if (uri == null || !uri.hasScheme) {
      return 'The page URL is not valid.';
    }

    if (!_allowedSchemes.contains(uri.scheme)) {
      return 'Unsupported URL scheme "${uri.scheme}".';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _settings = _buildSettings();
    _initPullToRefresh();
    _validateBeforeLoad();
    unawaited(_initWebViewSettings());
  }

  Future<void> _initWebViewSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final defaultUserAgent = await InAppWebViewController.getDefaultUserAgent();
    if (defaultUserAgent.contains('; wv)')) {
      _settings = _buildSettings(
        userAgent: defaultUserAgent.replaceAll('; wv)', ')'),
      );
    }

    if (!mounted) {
      return;
    }
    setState(() => _settingsReady = true);
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  void _startLoadingTimeout() {
    _loadingTimeout?.cancel();
    _loadingTimeout = Timer(const Duration(seconds: 25), () {
      if (!mounted || !_isLoading) {
        return;
      }
      setState(() => _isLoading = false);
      print(
        '[WebView timeout] Hiding loading indicator for $_normalizedUrl',
      );
    });
  }

  void _stopLoadingTimeout() {
    _loadingTimeout?.cancel();
    _loadingTimeout = null;
  }

  void _finishLoading() {
    _stopLoadingTimeout();
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      _progress = 1;
    });
  }

  void _validateBeforeLoad() {
    final invalidMessage = _invalidUrlMessage;
    if (invalidMessage != null) {
      _setError(
        title: 'Unable to open page',
        message: invalidMessage,
      );
      return;
    }

    if (_hasLoadTarget) {
      _isLoading = true;
    }
  }

  void _initPullToRefresh() {
    if (kIsWeb) {
      return;
    }

    _pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: kPrimaryLightColor),
      onRefresh: _retryLoad,
    );
  }

  void _setError({required String title, required String message}) {
    print('[WebView error] $title: $message');

    if (!mounted) {
      return;
    }

    setState(() {
      _errorTitle = title;
      _errorMessage = message;
      _isLoading = false;
      _progress = 0;
    });

    _endRefreshing();
    _showErrorSnackBar('$title: $message');
  }

  void _clearError() {
    if (!mounted) {
      return;
    }

    setState(() {
      _errorTitle = null;
      _errorMessage = null;
    });
  }

  void _endRefreshing() {
    _pullToRefreshController?.endRefreshing();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _retryLoad,
          ),
        ),
      );
  }

  Future<void> _showDownloadStartedSnackBar() async {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'File download started. Check your notification drawer.',
        ),
      ),
    );
  }

  Future<void> _retryLoad() async {
    final invalidMessage = _invalidUrlMessage;
    if (invalidMessage != null) {
      _setError(
        title: 'Unable to open page',
        message: invalidMessage,
      );
      return;
    }

    _clearError();
    setState(() {
      _isLoading = true;
      _progress = 0;
    });

    final controller = _webViewController;
    if (controller == null) {
      return;
    }

    try {
      if (_hasHtmlData) {
        await controller.loadData(
          data: widget.data!,
          baseUrl: _htmlBaseUrl,
        );
      } else {
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri(_normalizedUrl)),
        );
      }
    } catch (error, stackTrace) {
      print('MyWebsiteView retry failed: $error\n$stackTrace');
      _setError(
        title: 'Unable to open page',
        message: error.toString(),
      );
    }
  }

  Future<void> _onWebViewCreated(InAppWebViewController controller) async {
    _webViewController = controller;
    print('[WebView created]');
  }

  Future<void> _injectViewportMeta(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: _viewportUserScript);
  }

  Future<PermissionResponse?> _onPermissionRequest(
    InAppWebViewController controller,
    PermissionRequest request,
  ) async {
    print('[WebView permission] resources=${request.resources}');
    return PermissionResponse(
      resources: request.resources,
      action: PermissionResponseAction.GRANT,
    );
  }

  Future<void> _onConsoleMessage(
    InAppWebViewController controller,
    ConsoleMessage consoleMessage,
  ) async {
    print(
      '🌐 WEBVIEW CONSOLE '
      '[${consoleMessage.messageLevel}] '
      '${consoleMessage.message}',
    );
    print(
      '[WebView console][${consoleMessage.messageLevel}] '
      '${consoleMessage.message}',
    );

    final started = await handleConsoleDownload(consoleMessage.message);
    if (started) {
      await _showDownloadStartedSnackBar();
    }
  }

  Future<void> _onDownloadStartRequest(
    InAppWebViewController controller,
    DownloadStartRequest request,
  ) async {
    print('[WebView download] ${request.url}');
    final started = await handleDownloadRequest(request.url.toString());
    if (started) {
      await _showDownloadStartedSnackBar();
    }
  }

  Uri? _resolveIntentUri(Uri uri) {
    if (uri.scheme != 'intent') {
      return null;
    }

    final intentData = uri.fragment;
    final fallbackMatch = RegExp(
      r'(?:S\.browser_fallback_url|browser_fallback_url)=([^;]+)',
    ).firstMatch(intentData);
    if (fallbackMatch != null) {
      return Uri.tryParse(Uri.decodeComponent(fallbackMatch.group(1)!));
    }

    final schemeMatch = RegExp(r'(?:^|;)scheme=([^;]+)').firstMatch(intentData);
    final scheme = schemeMatch?.group(1);
    if (scheme == null || uri.host.isEmpty) {
      return null;
    }

    return Uri(
      scheme: scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: uri.path,
      query: uri.query,
    );
  }

  Future<NavigationActionPolicy> _handleIntentNavigation(
    InAppWebViewController controller,
    Uri uri,
  ) async {
    final resolvedUri = _resolveIntentUri(uri);
    if (resolvedUri == null) {
      _setError(
        title: 'Link blocked',
        message: 'This link does not provide a browser-compatible address.',
      );
      return NavigationActionPolicy.CANCEL;
    }

    if (resolvedUri.scheme == 'http' || resolvedUri.scheme == 'https') {
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri(resolvedUri.toString())),
      );
      return NavigationActionPolicy.CANCEL;
    }

    if (await canLaunchUrl(resolvedUri)) {
      await launchUrl(resolvedUri, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    }

    _setError(
      title: 'Link blocked',
      message: 'Cannot open link with scheme "${resolvedUri.scheme}".',
    );
    return NavigationActionPolicy.CANCEL;
  }

  Future<NavigationActionPolicy> _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final uri = navigationAction.request.url;
    if (uri == null) {
      return NavigationActionPolicy.ALLOW;
    }

    if (uri.scheme == 'intent') {
      return _handleIntentNavigation(controller, uri);
    }

    if (_allowedSchemes.contains(uri.scheme)) {
      return NavigationActionPolicy.ALLOW;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    }

    _setError(
      title: 'Link blocked',
      message: 'Cannot open link with scheme "${uri.scheme}".',
    );
    return NavigationActionPolicy.CANCEL;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      elevation: 0,
      leadingWidth: 30,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.white),
      ),
      bottom: _isLoading && _progress > 0 && _progress < 1
          ? PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.transparent,
                color: Colors.white70,
                minHeight: 2,
              ),
            )
          : null,
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildErrorView() {
    final title = _errorTitle ?? 'Unable to open page';
    final message = _errorMessage ?? 'Something went wrong while loading.';

    return SafeArea(
      child: Column(
        children: [
          if (_hideAppBar) _buildBackButton(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (_normalizedUrl.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        _normalizedUrl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _retryLoad,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isMainFrameRequest(WebResourceRequest? request) {
    return request?.isForMainFrame ?? true;
  }

  Widget _buildTopProgressBar() {
    if (!_isLoading || _progress >= 1) {
      return const SizedBox.shrink();
    }

    return LinearProgressIndicator(
      value: _progress > 0 ? _progress : null,
      backgroundColor: Colors.grey.shade200,
      color: kPrimaryLightColor,
      minHeight: 3,
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      key: _webViewKey,
      initialData: _hasHtmlData
          ? InAppWebViewInitialData(
              data: widget.data!,
              baseUrl: _htmlBaseUrl,
            )
          : null,
      initialUrlRequest: !_hasHtmlData && _normalizedUrl.isNotEmpty
          ? URLRequest(url: WebUri(_normalizedUrl))
          : null,
      initialSettings: _settings,
      initialUserScripts: UnmodifiableListView<UserScript>([
        UserScript(
          source: _viewportUserScript,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: false,
        ),
      ]),
      pullToRefreshController: _pullToRefreshController,
      onWebViewCreated: _onWebViewCreated,
      onPermissionRequest: _onPermissionRequest,
      onConsoleMessage: _onConsoleMessage,
      onDownloadStartRequest: _onDownloadStartRequest,
      shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      onLoadStart: (controller, uri) {
        print('[WebView load start] ${uri?.toString() ?? _normalizedUrl}');
        _clearError();
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = true;
          _progress = 0;
        });
        _startLoadingTimeout();
      },
      onLoadStop: (controller, uri) {
        print('[WebView load stop] ${uri?.toString() ?? _normalizedUrl}');
        unawaited(_injectViewportMeta(controller));
        _endRefreshing();
        _finishLoading();
      },
      onProgressChanged: (controller, progress) {
        print('[WebView progress] $progress');
        if (progress == 100) {
          _endRefreshing();
          _finishLoading();
        } else if (mounted) {
          setState(() {
            _isLoading = true;
            _progress = progress / 100;
          });
        }
      },
      onReceivedError: (controller, request, error) {
        print(
          '[WebView resource error] url=${request.url} '
          'mainFrame=${request.isForMainFrame} type=${error.type} '
          'description=${error.description}',
        );
        if (!_isMainFrameRequest(request)) {
          return;
        }

        _setError(
          title: isSslWebResourceError(error.type)
              ? 'Secure connection failed'
              : 'Page failed to load',
          message: formatWebResourceError(error),
        );
      },
      onReceivedHttpError: (controller, request, response) {
        print(
          '[WebView HTTP error] url=${request.url} '
          'status=${response.statusCode} reason=${response.reasonPhrase}',
        );
        if (!_isMainFrameRequest(request)) {
          return;
        }

        final statusCode = response.statusCode;
        if (statusCode == null || statusCode < 400) {
          return;
        }

        _setError(
          title: 'Server error',
          message:
              'HTTP $statusCode${response.reasonPhrase != null ? ': ${response.reasonPhrase}' : ''}',
        );
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) {
        print('[WebView SSL challenge] $challenge');
        return handleServerTrustAuthRequest(challenge);
      },
      onRenderProcessGone: (controller, detail) {
        print('[WebView renderer gone] didCrash=${detail.didCrash}');
        _setError(
          title: 'WebView crashed',
          message: detail.didCrash
              ? 'The page renderer crashed. Please try again.'
              : 'The page was closed unexpectedly. Please try again.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidUrlMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _hideAppBar ? null : _buildAppBar(context),
        body: _buildErrorView(),
      );
    }

    if (!_settingsReady) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _hideAppBar ? null : _buildAppBar(context),
        body: Center(
          child: CircularProgressIndicator(color: kPrimaryLightColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _hideAppBar ? null : _buildAppBar(context),
      body: Column(
        children: [
          if (_hideAppBar) _buildTopProgressBar(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildWebView(),
                if (_errorMessage != null) _buildErrorView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
