import 'dart:io';

import 'package:ekidzee/api/response/pentemind/parent/myhomework.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

class MyPdfApp extends StatefulWidget {
  final String worksheetUrl;
  final String title;
  final String module;
  final String filename;
  final MyHomeworkModel? model;
  final VoidCallback? imageUploadFunction;

  const MyPdfApp({
    super.key,
    required this.title,
    required this.filename,
    required this.module,
    required this.worksheetUrl,
    this.model,
    this.imageUploadFunction,
  });

  @override
  State<MyPdfApp> createState() => _MyPdfAppState();
}

class _MyPdfAppState extends State<MyPdfApp> {
  bool isLoading = true;
  late PdfViewerController _pdfController;
  late String _currentPdfUrl;
  bool _usingProxy = false;
  bool _proxySwitchScheduled = false;
  File? mFile;

  static const String _proxyUrlPrefix =
      'https://cdn-proxy-umber.vercel.app/api/proxy?path=';

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _currentPdfUrl = _resolveInitialUrl(widget.worksheetUrl);
    checkFile();
  }

  /// On web, remote http(s) PDFs often fail CORS in pdfrx workers.
  /// Prefer CDN proxy up-front for those URLs.
  String _resolveInitialUrl(String url) {
    if (!kIsWeb) return url;
    if (_shouldUseProxy(url)) {
      _usingProxy = true;
      return _proxyUrl(url);
    }
    return url;
  }

  bool _shouldUseProxy(String url) {
    final lower = url.toLowerCase();
    if (lower.startsWith('blob:') || lower.startsWith('data:')) {
      return false;
    }
    if (url.contains('cdn-proxy-umber.vercel.app')) {
      return false;
    }
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  String _proxyUrl(String url) =>
      '$_proxyUrlPrefix${Uri.encodeComponent(url)}';

  String getProxyUrl() => _proxyUrl(widget.worksheetUrl);

  Future<void> checkFile() async {
    if (kIsWeb || widget.module.isEmpty) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      final dir = (await getTemporaryDirectory()).path;
      final folderPath = '$dir/${widget.module}';
      final filePath = '$folderPath/${widget.filename}.pdf';

      if (!await Directory(folderPath).exists()) {
        await Directory(folderPath).create(recursive: true);
      }

      if (await File(filePath).exists()) {
        mFile = File(filePath);
      } else {
        await Utility.downloadContent(widget.worksheetUrl, filePath);
        if (await File(filePath).exists()) {
          mFile = File(filePath);
        }
      }
    } catch (e) {
      debugPrint('PDF cache error: $e');
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void _scheduleProxySwitch() {
    if (_usingProxy || _proxySwitchScheduled) return;
    _proxySwitchScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _proxySwitchScheduled = false;
      if (!mounted || _usingProxy) return;
      setState(() {
        _usingProxy = true;
        _currentPdfUrl = getProxyUrl();
      });
    });
  }

  void _retryDirect() {
    setState(() {
      _usingProxy = false;
      _proxySwitchScheduled = false;
      _currentPdfUrl = widget.worksheetUrl;
    });
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 80,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              _usingProxy
                  ? 'Unable to load PDF from proxy.'
                  : 'Unable to load PDF.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _usingProxy ? _retryDirect : _scheduleProxySwitch,
              child: Text(_usingProxy ? 'Retry Direct' : 'Retry via Proxy'),
            ),
            if (kIsWeb) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () =>
                    Utility.downloadFile(widget.worksheetUrl, widget.filename),
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (kIsWeb)
            IconButton(
              tooltip: 'Download',
              icon: const Icon(Icons.download),
              onPressed: () =>
                  Utility.downloadFile(widget.worksheetUrl, '${widget.filename}.pdf'),
            ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => _pdfController.zoomUp(),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => _pdfController.zoomDown(),
          ),
        ],
      ),
      body: isLoading
          ? Utility.showLoader()
          : mFile != null
              ? PdfViewer.file(mFile!.path)
              : PdfViewer.uri(
                  Uri.parse(_currentPdfUrl),
                  controller: _pdfController,
                  params: PdfViewerParams(
                    panEnabled: true,
                    scaleEnabled: true,
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    scrollByMouseWheel: 10,
                    scrollByArrowKey: 10,
                    annotationRenderingMode:
                        PdfAnnotationRenderingMode.annotation,
                    errorBannerBuilder:
                        (context, error, stackTrace, documentRef) {
                      debugPrint('PDF Load Error: $error');
                      // Never call setState during build.
                      if (!_usingProxy) {
                        _scheduleProxySwitch();
                      }
                      return _buildErrorWidget();
                    },
                  ),
                ),
    );
  }
}
