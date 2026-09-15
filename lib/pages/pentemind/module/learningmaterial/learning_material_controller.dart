import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../api/request/pentemind/LookUpRequest.dart';
import '../../../../../api/request/pentemind/learningmaterial/learning_material.dart';
import '../../../../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../../../../api/response/pentemind/lookupresponse.dart';
import '../../../../../helper/LocalConstant.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/get_day_response.dart';
import '../../../../helper/KidzeePref.dart';
import '../myclass/base_my_class_controller.dart';
import 'web_helper_stub.dart' if (dart.library.html) 'web_helper_web.dart'
    as web_helper;

class LearningMaterialController extends BaseMyClassController {
  final RxList<LearningMaterialModel> materialList =
      <LearningMaterialModel>[].obs;
  final RxList<String> categoryOptions = <String>['Select Category'].obs;
  final RxString selectedCategory = 'Select Category'.obs;
  final RxString currentDay = ''.obs;
  final RxString culminationName = ''.obs;
  final RxBool isBaseLoaded = false.obs;
  final RxBool isDownloadingAll = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxMap<String, bool> fileStatusMap = <String, bool>{}.obs;
  final RxList<bool> printDownloadStatus = <bool>[].obs;
  final List<String> _objectUrls = [];

  bool get isPrintCategory => selectedCategory.value == 'Print';

  LookUpResponse? menuResponse;
  final bool isForNepal;

  LearningMaterialController({required this.isForNepal});

  @override
  Future<void> onReadyToFetch() async {
    isLoading.value = true;

    // Force refresh programId and other base data from preferences
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    await _initDayData();
    _setupCategories();

    // Clear list and show loader while we determine what to show for this specific class
    materialList.clear();
    fileStatusMap.clear();

    // Reset selection if the category is no longer valid for this class
    if (!categoryOptions.contains(selectedCategory.value)) {
      selectedCategory.value = 'Select Category';
    }

    // Load offline data if available for this specific programId/day/category
    await loadOfflineData();

    isBaseLoaded.value = true;

    // Always fetch menus for the current program
    if (userType != 'P') await fetchMenus();

    // Fetch materials for current selection
    if (selectedCategory.value != 'Select Category' &&
        currentDay.value.isNotEmpty) {
      await fetchMaterials();
    } else {
      isLoading.value = false;
    }
  }

  Future<void> _initDayData() async {
    try {
      GetDayResponse? dayModel = await KidzeePref.getDay(Get.context!);
      currentDay.value = dayModel.data.D.toString();
      culminationName.value = dayModel.data.CName;
    } catch (e) {
      debugPrint('Error initializing day data: $e');
    }
  }

  void _setupCategories() {
    String term = prefs.getString(LocalConstant.KEY_CURRENT_TERM) ?? '';
    if (userType == 'P') {
      categoryOptions.assignAll(['Select Category', 'Rhymes', 'AV\'s']);
    } else if (term == LocalConstant.TERM_EARLY) {
      categoryOptions.assignAll([
        'Select Category',
        'Rhymes',
        'AV\'s',
        'Stories',
        'Print',
        'Flash Cards'
      ]);
    }
  }

  String _getCacheKey() {
    return 'learning_material_${userId}_${programId}_${isForNepal ? 1 : 0}_${currentDay.value}_${selectedCategory.value}';
  }

  String _getMenuCacheKey() {
    return 'learning_material_menu_${userId}_${programId}_${isForNepal ? 1 : 0}';
  }

  Future<void> loadOfflineData() async {
    try {
      String? cachedData = prefs.getString(_getCacheKey());
      if (cachedData != null) {
        LearningMaterialResponse response =
            LearningMaterialResponse.fromJson(json.decode(cachedData));
        materialList.assignAll(response.data.mateialList);
        culminationName.value = response.data.CName;
        await checkFilesStatus();
        isLoading.value = false;
      }

      String? cachedMenu = prefs.getString(_getMenuCacheKey());
      if (cachedMenu != null) {
        menuResponse = LookUpResponse.fromJson(json.decode(cachedMenu));
        _updateCategoryOptionsFromMenu();
      }
    } catch (e) {
      debugPrint('Error loading offline data: $e');
    }
  }

  void _updateCategoryOptionsFromMenu() {
    if (menuResponse != null) {
      List<String> newOptions = ['Select Category'];
      for (var item in menuResponse!.data) {
        newOptions.add(item.LookupName);
      }
      if (userType == 'P') {
        categoryOptions.assignAll(['Select Category', 'Rhymes', 'AV\'s']);
      } else {
        categoryOptions.assignAll(newOptions);
      }
    }
  }

  Future<void> fetchMenus() async {
    try {
      String countryName =
          prefs.getString(LocalConstant.KEY_COUNTRY_NAME) ?? '';
      GetLookupRequest request = GetLookupRequest(
          LookupType: 'LRNMTRLS', Country: isForNepal ? countryName : '');

      final response = await apiService.getLearningMaterialMenu(request, token);
      if (response != null && response is LookUpResponse) {
        menuResponse = response;
        prefs.setString(_getMenuCacheKey(), jsonEncode(response.toJson()));
        _updateCategoryOptionsFromMenu();
      }
    } catch (e) {
      debugPrint('Error fetching menus: $e');
    }
  }

  String _getCategoryCode(String categoryName) {
    if (menuResponse != null) {
      for (var item in menuResponse!.data) {
        if (categoryName == item.LookupName) return item.LookupCode;
      }
    }

    switch (categoryName) {
      case 'Critcal Thinking':
        return 'CRTHK';
      case 'Rhymes':
        return 'RHYMS';
      case 'AV\'s':
        return 'VIDEO';
      case 'Sound Track':
        return 'SDTRK';
      case 'Tell-a-Tale':
        return 'TEATA';
      case 'Print':
        return 'PRINT';
      case 'Stories':
        return 'STORY';
      case 'Flash Cards':
        return 'FLSCAD';
      default:
        return '';
    }
  }

  Future<void> fetchMaterials() async {
    String categoryCode = _getCategoryCode(selectedCategory.value);
    if (categoryCode.isEmpty || currentDay.value.isEmpty) {
      materialList.clear();
      fileStatusMap.clear();
      return;
    }

    if (materialList.isEmpty) isLoading.value = true;

    if (!await Utility.isInternet()) {
      isLoading.value = false;
      await checkFilesStatus();
      return;
    }

    try {
      LearningMaterialRequest request = LearningMaterialRequest(
          ProgramID: programId.toString(),
          D: currentDay.value,
          ContentCategory: categoryCode,
          UserID: uid);

      final response =
          await apiService.getLearningMaterials(request, isForNepal, token);

      if (response != null && response is LearningMaterialResponse) {
        materialList.assignAll(response.data.mateialList);
        culminationName.value = response.data.CName;
        prefs.setString(_getCacheKey(), jsonEncode(response.toJson()));
        await checkFilesStatus();
      }
    } catch (e) {
      debugPrint('Error fetching materials: $e');
      await checkFilesStatus();
    } finally {
      isLoading.value = false;
    }
  }

  final RxMap<String, double> individualProgress = <String, double>{}.obs;
  final RxMap<String, String> downloadStatus =
      <String, String>{}.obs; // 'none', 'downloading', 'completed', 'failed'

  Future<void> checkFilesStatus() async {
    Map<String, bool> statusMap = {};
    try {
      if (kIsWeb) {
        var box = await Hive.openBox(LocalConstant.offlineMaterials);
        for (var material in materialList) {
          String cacheKey = '${material.RefKey}_${material.ContentDescription}';
          String materialId = material.RefKey.toString().isEmpty
              ? material.ContentDescription
              : material.RefKey.toString();
          bool exists = box.containsKey(cacheKey);
          statusMap[materialId] = exists;
          if (exists) downloadStatus[materialId] = 'completed';
        }
      } else {
        String dir = (await getApplicationDocumentsDirectory()).path;
        for (var material in materialList) {
          String materialId = material.RefKey.toString().isEmpty
              ? material.ContentDescription
              : material.RefKey.toString();

          String extension = _getFileExtension(material.WebUrl);
          String fileName =
              '${material.RefKey}_${material.ContentDescription}$extension';
          String filePath = '$dir/$fileName';
          bool exists = await File(filePath).exists();
          statusMap[materialId] = exists;
          if (exists) downloadStatus[materialId] = 'completed';
        }
      }
      fileStatusMap.assignAll(statusMap);
      if (isPrintCategory) {
        await checkPrintFilesStatus();
      } else {
        printDownloadStatus.clear();
      }
    } catch (e) {
      debugPrint('Error checking files status: $e');
    }
  }

  String _getFileExtension(String url) {
    String lowUrl = url.toLowerCase();
    if (lowUrl.contains('.m3u8')) return '.m3u8';
    if (lowUrl.contains('.mp4')) return '.mp4';
    if (lowUrl.contains('.mp3')) return '.mp3';
    if (lowUrl.contains('.pdf')) return '.pdf';
    if (lowUrl.contains('.png')) return '.png';
    if (lowUrl.contains('.jpg')) return '.jpg';
    if (lowUrl.contains('.jpeg')) return '.jpeg';
    return '.pdf';
  }

  Future<void> downloadAll() async {
    if (materialList.isEmpty) return;

    if (isPrintCategory) {
      isDownloadingAll.value = true;
      downloadProgress.value = 0.0;
      int completedCount = 0;

      for (final material in materialList) {
        if (material.MediaType == 'mp4') {
          completedCount++;
          downloadProgress.value = completedCount / materialList.length;
          continue;
        }
        await downloadPrintFile(material);
        completedCount++;
        downloadProgress.value = completedCount / materialList.length;
      }

      isDownloadingAll.value = false;
      Get.snackbar(
        'Download Task',
        'Processed $completedCount of ${materialList.length} print files.',
      );
      return;
    }

    isDownloadingAll.value = true;
    downloadProgress.value = 0.0;
    int total = materialList.length;
    int completedCount = 0;

    for (var material in materialList) {
      String materialId = material.RefKey.toString().isEmpty
          ? material.ContentDescription
          : material.RefKey.toString();
      if (downloadStatus[materialId] == 'completed') {
        completedCount++;
        continue;
      }
      bool success = await downloadSingleFile(material);
      if (success) completedCount++;
      downloadProgress.value = completedCount / total;
    }

    isDownloadingAll.value = false;
    Get.snackbar("Download Task", "Processed $completedCount of $total items.");
  }

  Future<void> checkPrintFilesStatus() async {
    if (!isPrintCategory) {
      printDownloadStatus.clear();
      return;
    }

    if (kIsWeb) {
      // Web downloads open in browser; keep all items downloadable.
      printDownloadStatus.assignAll(
        List<bool>.filled(materialList.length, false),
      );
      return;
    }

    try {
      final status = <bool>[];
      final dir = (await getTemporaryDirectory()).path;
      for (final material in materialList) {
        final path = '$dir/${material.ContentDescription}.pdf';
        status.add(await File(path).exists());
      }
      printDownloadStatus.assignAll(status);
    } catch (e) {
      debugPrint('Error checking print files status: $e');
    }
  }

  Future<void> downloadPrintFile(LearningMaterialModel material) async {
    final fileName = '${material.ContentDescription}.pdf';
    final url = material.WebUrl.trim().isEmpty
        ? material.WebUrl
        : material.WebUrl.contains(' ')
            ? Uri.encodeFull(material.WebUrl.trim())
            : material.WebUrl.trim();

    if (kIsWeb) {
      try {
        await Utility.downloadFile(url, fileName);
        Get.snackbar('Download', 'Opening $fileName for download…');
      } catch (e) {
        debugPrint('Error downloading print file on web: $e');
        Get.snackbar('Download failed', 'Could not download $fileName');
      }
      return;
    }

    isLoading.value = true;
    try {
      await Utility.downloadFile(url, fileName);
      await checkPrintFilesStatus();
      Get.snackbar('Download', '$fileName saved successfully.');
    } catch (e) {
      debugPrint('Error downloading print file: $e');
      Get.snackbar('Download failed', 'Could not download $fileName');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sharePrintFile(LearningMaterialModel material) async {
    if (kIsWeb) {
      // Web has no local share target; re-trigger browser download.
      await downloadPrintFile(material);
      return;
    }

    try {
      final dir = (await getTemporaryDirectory()).path;
      final path = '$dir/${material.ContentDescription}.pdf';
      final file = File(path);

      if (!await file.exists()) {
        Get.snackbar('Share', 'Please download the file first.');
        return;
      }

      await Share.shareXFiles(
        [XFile(path)],
        text: material.ContentDescription,
      );
    } catch (e) {
      debugPrint('Error sharing print file: $e');
      Get.snackbar(
        'Share failed',
        'Could not share ${material.ContentDescription}',
      );
    }
  }

  String getMediaTypeAsset(String type) {
    switch (type) {
      case 'mp3':
        return 'assets/icons/ic_rhymes.png';
      case 'mp4':
        return 'assets/icons/ic_video.png';
      case 'pdf':
      default:
        return 'assets/icons/ic_worksheet.png';
    }
  }

  Future<bool> downloadSingleFile(LearningMaterialModel material) async {
    String materialId = material.RefKey.toString().isEmpty
        ? material.ContentDescription
        : material.RefKey.toString();
    try {
      String cacheKey = '${material.RefKey}_${material.ContentDescription}';
      downloadStatus[materialId] = 'downloading';
      individualProgress[materialId] = 0.0;

      if (kIsWeb) {
        var box = await Hive.openBox(LocalConstant.offlineMaterials);
        if (box.containsKey(cacheKey)) {
          downloadStatus[materialId] = 'completed';
          fileStatusMap[materialId] = true;
          return true;
        }

        Dio dio = Dio();
        String url = material.WebUrl.trim();
        if (url.contains(' ')) url = Uri.encodeFull(url);

        Response response = await dio.get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {'Accept': '*/*'},
          ),
          onReceiveProgress: (count, total) {
            if (total > 0) individualProgress[materialId] = count / total;
          },
        );

        if (response.statusCode == 200) {
          await box.put(cacheKey, response.data);
          downloadStatus[materialId] = 'completed';
          fileStatusMap[materialId] = true;
          return true;
        }
      } else {
        String dir = (await getApplicationDocumentsDirectory()).path;
        String extension = _getFileExtension(material.WebUrl);
        String fileName =
            '${material.RefKey}_${material.ContentDescription}$extension';
        String filePath = '$dir/$fileName';

        if (await File(filePath).exists()) {
          downloadStatus[materialId] = 'completed';
          fileStatusMap[materialId] = true;
          return true;
        }

        Dio dio = Dio();
        String url = material.WebUrl.trim();
        if (url.contains(' ')) url = Uri.encodeFull(url);

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (count, total) {
            if (total > 0) individualProgress[materialId] = count / total;
          },
        );

        downloadStatus[materialId] = 'completed';
        fileStatusMap[materialId] = true;
        return true;
      }
      downloadStatus[materialId] = 'failed';
      return false;
    } catch (e) {
      downloadStatus[materialId] = 'failed';
      debugPrint('Error downloading ${material.ContentDescription}: $e');
      return false;
    }
  }

  String _getMimeType(String mediaType, String url) {
    String lowUrl = url.toLowerCase();
    if (lowUrl.contains('.m3u8')) return 'application/x-mpegURL';

    switch (mediaType.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'mp3':
        return 'audio/mpeg';
      case 'mp4':
        return 'video/mp4';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String?> getLocalPath(LearningMaterialModel material) async {
    try {
      if (kIsWeb) {
        var box = await Hive.openBox(LocalConstant.offlineMaterials);
        String cacheKey = '${material.RefKey}_${material.ContentDescription}';
        if (box.containsKey(cacheKey)) {
          Uint8List bytes = Uint8List.fromList(box.get(cacheKey));

          String mimeType = _getMimeType(material.MediaType, material.WebUrl);
          final url = web_helper.createBlobUrl(bytes, mimeType);
          _objectUrls.add(url);

          return url;
        }
      } else {
        String dir = (await getApplicationDocumentsDirectory()).path;
        String extension = _getFileExtension(material.WebUrl);
        String fileName =
            '${material.RefKey}_${material.ContentDescription}$extension';
        String filePath = '$dir/$fileName';

        if (await File(filePath).exists()) {
          return filePath;
        }
      }
    } catch (e) {
      debugPrint('Error getting local path: $e');
    }
    return null;
  }

  void updateCategory(String value) {
    selectedCategory.value = value;
    fetchMaterials();
  }

  void updateDay(String day) {
    currentDay.value = day;
    fetchMaterials();
  }

  Future<void> refreshData() async {
    await fetchMaterials();
  }

  Future<void> clearOfflineCache() async {
    try {
      if (kIsWeb) {
        var box = await Hive.openBox(LocalConstant.offlineMaterials);
        await box.clear();
      } else {
        String dir = (await getApplicationDocumentsDirectory()).path;
        Directory directory = Directory(dir);
        if (await directory.exists()) {
          List<FileSystemEntity> files = directory.listSync();
          for (var file in files) {
            if (file is File) {
              String fileName = file.path.split('/').last;
              // Only delete files that match our naming convention to avoid deleting other app data
              if (fileName.contains('_')) {
                await file.delete();
              }
            }
          }
        }
      }
      await checkFilesStatus();
      Get.snackbar("Success", "Offline cache cleared successfully.");
    } catch (e) {
      debugPrint('Error clearing offline cache: $e');
      Get.snackbar("Error", "Failed to clear offline cache.");
    }
  }

  @override
  void onClose() {
    if (kIsWeb) {
      for (var url in _objectUrls) {
        web_helper.revokeBlobUrl(url);
      }
      _objectUrls.clear();
    }
    super.onClose();
  }
}
