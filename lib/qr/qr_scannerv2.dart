import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/api/request/pentemind/learningmaterial/learning_material.dart';
import 'package:ekidzee/api/response/pentemind/get_day_response.dart';
import 'package:ekidzee/api/response/pentemind/learningmaterial/learning_material.dart';
import 'package:ekidzee/app_routes.dart';
import 'package:ekidzee/helper/DatabaseHelper.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/model/parent_info.dart';
import 'package:ekidzee/model/user_model.dart';
import 'package:ekidzee/videoplayer/AudioPlayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Parsed QR payload (semicolon-separated key:value pairs).
class QrScannedContent {
  String type = '';
  String root = '';
  String contentId = '';
  String classId = '';
  String contentName = '';

  bool get isRhyme =>
      type.toLowerCase().contains('rhyme') ||
      root.toLowerCase().contains('rhyme');

  String get contentCategory => isRhyme ? 'RHYMS' : 'VIDEO';

  bool get isValid =>
      type.isNotEmpty && classId.isNotEmpty && contentName.isNotEmpty;
}

/// Opens learning material using the same routing as [LearningMaterialScreen].
class QrLearningContentPlayer {
  static Future<void> open(LearningMaterialModel model) async {
    final url = _normalizeUrl(model.WebUrl);
    if (url.isEmpty) {
      throw Exception('Content URL is empty.');
    }

    final mediaType = model.MediaType.toLowerCase();
    final title = model.ContentDescription;

    if (_isVimeo(url) || _isHls(url) || mediaType == 'mp4') {
      await Get.to(
        () => goToVideoPlayer(path: url, Title: title),
      );
      return;
    }

    if (mediaType == 'mp3' || _isAudio(url)) {
      await Get.to(
        () => AudioPlayer(
          path: url,
          background: model.BackgroundURL,
          Title: title,
        ),
      );
      return;
    }

    if (mediaType == 'pdf' || url.toLowerCase().contains('.pdf')) {
      await Get.to(
        () => goToMyPdf(
          worksheetUrl: url,
          title: title,
          filename: title,
          module: 'material',
          isDownload: false,
        ),
      );
      return;
    }

    if (mediaType == 'image' || _isImage(url)) {
      await Get.to(() => goToImageViewer(imageUrl: url));
      return;
    }

    // Fallback: infer from URL extension.
    if (_isAudio(url)) {
      await Get.to(
        () => AudioPlayer(
          path: url,
          background: model.BackgroundURL,
          Title: title,
        ),
      );
    } else if (_isImage(url)) {
      await Get.to(() => goToImageViewer(imageUrl: url));
    } else {
      await Get.to(() => goToVideoPlayer(path: url, Title: title));
    }
  }

  static String _normalizeUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.contains(' ') ? Uri.encodeFull(trimmed) : trimmed;
  }

  static bool _isVimeo(String url) => url.toLowerCase().contains('vimeo.com');

  static bool _isHls(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.m3u8') || lower.contains('dyntube.com');
  }

  static bool _isAudio(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.mp3') ||
        lower.contains('.wav') ||
        lower.contains('.m4a') ||
        lower.contains('.aac');
  }

  static bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.png') ||
        lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.webp') ||
        lower.contains('.gif');
  }
}

class KidzeeQRScreenV2 extends StatefulWidget {
  const KidzeeQRScreenV2({super.key});

  @override
  State<KidzeeQRScreenV2> createState() => _KidzeeQRScreenV2State();
}

class _KidzeeQRScreenV2State extends State<KidzeeQRScreenV2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_V2');
  QRViewController? _controller;
  Barcode? _lastScan;
  bool _isProcessing = false;
  bool _loaderVisible = false;

  @override
  void reassemble() {
    super.reassemble();
    if (kIsWeb || _controller == null) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _controller!.pauseCamera();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Scan QR Code'),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'QR scanning is available on the Android and iOS Kidzee apps.\n\nPlease use the mobile app to scan learning content QR codes.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 8,
                cutOutSize: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isProcessing
                      ? 'Fetching content…'
                      : _lastScan?.code != null
                          ? 'Scanned Successfully'
                          : 'Align the QR code within the frame',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing || scanData.code == null || scanData.code!.isEmpty) {
        return;
      }
      _lastScan = scanData;
      await _handleScan(scanData.code!);
    });
  }

  Future<void> _handleScan(String rawData) async {
    setState(() => _isProcessing = true);
    await _controller?.pauseCamera();

    try {
      final content = parseQrCode(rawData);
      if (!content.isValid) {
        await _showError(
          'Invalid QR',
          'QR code is missing Type, Class_Id, or content name.',
        );
        return;
      }

      if (!await Utility.isInternet()) {
        await _showError(
          'No Internet',
          'Please connect to the internet to load this content.',
        );
        return;
      }

      _showLoader('Resolving program…');
      debugPrint('rawData: $rawData');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
      final userId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
      debugPrint('token: $token');
      debugPrint('userId: $userId');
      if (token.isEmpty || userId.isEmpty) {
        _hideLoader();
        await _showError('Session expired', 'Please log in again.');
        return;
      }

      final programs = await _loadPrograms();
      debugPrint('programs: $programs');
      if (programs.isEmpty) {
        debugPrint('programs is empty');
        _hideLoader();
        await _showError(
          'Alert',
          'This QR code is not enrolled in a Class available for this account.',
        );
        return;
      }

      final classLabel = getClassName(content.classId);
      debugPrint('classLabel: $classLabel');
      final program = _resolveProgram(programs, content.classId, classLabel);
      debugPrint('program: $program');
      if (program == null || program.programId == null) {
        _hideLoader();
        await _showError(
          'Scanned QR not Available for this account',
          'This QR code is not enrolled in a Class available for this account.',
        );
        return;
      }
      debugPrint('program: $program');
      final day = await _resolveDay(prefs, program.programId!);
      debugPrint('day: $day');
      if (day.isEmpty || day == '0') {
        _hideLoader();
        await _showError(
          'Day not set',
          'Current learning day is not available. Open Learning Materials once, then retry.',
        );
        return;
      }

      final isForNepal = (prefs.getString(LocalConstant.KEY_COUNTRY_NAME) ?? '')
          .toLowerCase()
          .contains('nepal');

      debugPrint('isForNepal: $isForNepal');
      final request = LearningMaterialRequest(
        ProgramID: program.programId.toString(),
        D: day,
        ContentCategory: content.contentCategory,
        UserID: userId,
      );
      debugPrint('request: $request');
      final api = APIService();
      final response = await api.getLearningMaterials(
        request,
        isForNepal,
        token,
      );
      debugPrint('response: $response');
      _hideLoader();

      if (response == null || response is! LearningMaterialResponse) {
        await _showError(
          'Fetch failed',
          'Could not load learning materials. Please try again.',
        );
        return;
      }

      final material = _findMaterial(
        response.data.mateialList,
        content.contentName,
      );

      if (material == null) {
        await _showError(
          'Not found',
          'No ${content.isRhyme ? 'rhyme' : 'video'} matched "${content.contentName}".',
        );
        return;
      }

      if (material.WebUrl.trim().isEmpty) {
        await _showError(
            'Unavailable', 'Content URL is missing on the server.');
        return;
      }

      await QrLearningContentPlayer.open(material);
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      debugPrint('QR V2 error: $e\n$st');
      _hideLoader();
      await _showError('Error', e.toString());
    } finally {
      _hideLoader();
      if (!mounted) return;
      setState(() => _isProcessing = false);
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        await _controller?.resumeCamera();
      }
    }
  }

  void _showLoader(String message) {
    if (!mounted || _loaderVisible) return;
    _loaderVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    ).whenComplete(() => _loaderVisible = false);
  }

  void _hideLoader() {
    if (!mounted || !_loaderVisible) return;
    _loaderVisible = false;
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }

  Future<void> _showError(String title, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Parses semicolon-separated QR payload (same format as legacy scanner).
QrScannedContent parseQrCode(String data) {
  final content = QrScannedContent();
  final segments = data.split(';');

  for (final segment in segments) {
    if (!segment.contains(':')) continue;
    final parts = segment.split(':');
    if (parts.length < 2) continue;

    final key = parts.first.trim();
    final value = parts.sublist(1).join(':').trim();

    switch (key) {
      case 'Type':
        content.type = value;
        break;
      case 'Root':
        content.root = value;
        break;
      case 'Video_ID':
      case 'Rhyme_Id':
        content.contentId = value;
        break;
      case 'Class_Id':
        content.classId = value;
        break;
      case 'Video_Name':
      case 'Rhyme_Name':
        content.contentName = value;
        break;
    }
  }

  return content;
}

/// Maps QR class id to display label (legacy scanner reference).
String getClassName(String classId) {
  debugPrint('classId: $classId');
  switch (classId) {
    case '5':
      return 'Nursery';
    case '6':
      return 'PlayGroup';
    case '3':
      return 'JUNIORKG';
    case '4':
      return 'SENIORKG';
    default:
      return 'Nursery';
  }
}

Future<List<ProgramModel>> _loadPrograms() async {
  final login = await KidzeePref().getLoginResponse();
  if (login?.program != null && login!.program!.isNotEmpty) {
    return login.program!;
  }

  final dbList = await DBHelper().getParentInfoList();
  if (dbList.isEmpty) return [];

  return dbList.map(_mapParentInfoToProgram).toList();
}

ProgramModel _mapParentInfoToProgram(ParentInfo info) {
  return ProgramModel(
    programName: '${info.studentName} (${info.programName})',
    programId: info.studentProgramId,
    className: info.className,
    classId: info.classId,
    term: '',
    curriculumType: info.franchiseeType,
  );
}

ProgramModel? _resolveProgram(
  List<ProgramModel> programs,
  String qrClassId,
  String classLabel,
) {
  final parsedClassId = int.tryParse(qrClassId);

  if (parsedClassId != null) {
    for (final program in programs) {
      if (program.classId == parsedClassId) return program;
    }
  }

  final targetKey = _normalizeClassKey(classLabel);
  for (final program in programs) {
    final classKey = _normalizeClassKey(program.className ?? '');
    final programKey = _normalizeClassKey(program.programName ?? '');
    if (classKey == targetKey ||
        programKey.contains(targetKey) ||
        classKey.contains(targetKey)) {
      return program;
    }
  }
  debugPrint('program is null');

  return null;
}

String _normalizeClassKey(String value) {
  return value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

Future<String> _resolveDay(SharedPreferences prefs, int programId) async {
  final cached =
      prefs.getString(LocalConstant.KEY_MODEL_DAY + programId.toString());
  if (cached != null && cached.isNotEmpty) {
    try {
      final dayModel =
          GetDayResponse.fromJson(json.decode(cached) as Map<String, dynamic>);
      final day = dayModel.data.D.toString();
      if (day.isNotEmpty && day != '0') return day;
    } catch (e) {
      debugPrint('QR day parse error: $e');
    }
  }

  if (Get.context != null) {
    try {
      final dayModel = await KidzeePref.getDay(Get.context!);
      return dayModel.data.D.toString();
    } catch (_) {}
  }

  return '';
}

LearningMaterialModel? _findMaterial(
  List<LearningMaterialModel> materials,
  String scannedName,
) {
  if (materials.isEmpty) return null;

  final target = _normalizeContentName(scannedName);

  for (final item in materials) {
    if (_normalizeContentName(item.ContentDescription) == target) {
      return item;
    }
  }

  // Partial match (e.g. "Five Currant Buns" vs full title).
  final partial = materials.where((item) {
    final desc = _normalizeContentName(item.ContentDescription);
    return desc.contains(target) || target.contains(desc);
  }).toList();

  if (partial.length == 1) return partial.first;

  return null;
}

String _normalizeContentName(String value) {
  return value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}
