import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../api/request/pentemind/myclass/getnnnoucement.dart';
import '../../../../../api/response/pentemind/myclass/announancement_response.dart';

import '../../../../helper/LocalConstant.dart';
import '../../../../helper/utils.dart';
import 'base_my_class_controller.dart';

class AnnouncementController extends BaseMyClassController {
  final RxList<AnnouncementModel> announcementList = <AnnouncementModel>[].obs;
  final RxList<AnnouncementModel> announcementOriginalList = <AnnouncementModel>[].obs;
  final RxString currentType = 'all'.obs;
  final RxBool isBaseLoaded = false.obs;

  @override
  Future<void> onReadyToFetch() async {
    isBaseLoaded.value = true;
    // await loadOfflineData();
    await fetchAnnouncements();
  }

  String _getCacheKey() {
    return 'announcement_${userId}_$programId';
  }

  bool get canApprove => userType.toLowerCase() == 'cc';

  String get curriculumType =>
      prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) ?? '';

  Future<void> loadOfflineData() async {
    try {
      String? cachedData = prefs.getString(_getCacheKey());
      if (cachedData != null) {
        AnnouncementListResponse response =
            AnnouncementListResponse.fromJson(json.decode(cachedData));
        announcementOriginalList.assignAll(response.announcementModel.announcementList);
        _applyFilter();
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint('Error loading offline data: $e');
    }
  }

  Future<void> fetchAnnouncements() async {
    if (!await Utility.isInternet()) {
      if (announcementOriginalList.isEmpty) {
        isLoading.value = false;
      }
      return;
    }

    try {
      if (announcementOriginalList.isEmpty) {
        isLoading.value = true;
      }

      GetAnnoucementRequest request = GetAnnoucementRequest(
          TeacherID: userId,
          Program_Id: programId.toString(),
          UserType: userType,
          StudentID: '0',
          PageIndex: 0,
          PageRec: 50,
          RequestType: 'Announcement');

      final response = await apiService.getAnnouncementList(request, token);

      if (response != null && response is AnnouncementListResponse) {
        announcementOriginalList.assignAll(response.announcementModel.announcementList);
        _applyFilter();
        prefs.setString(_getCacheKey(), jsonEncode(response.toJson()));
      }
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterAnnouncements(String type) {
    currentType.value = type;
    _applyFilter();
  }

  void _applyFilter() {
    // In a real application, you'd filter based on a status field in AnnouncementModel.
    // For now, we'll keep it simple as the API seems to return the full list.
    if (currentType.value == 'all') {
      announcementList.assignAll(announcementOriginalList);
    } else if (currentType.value == 'app') {
      // Assuming 'app' stands for Approved. Filtering logic would go here.
      announcementList.assignAll(announcementOriginalList);
    } else if (currentType.value == 'pend') {
      // Assuming 'pend' stands for Pending. Filtering logic would go here.
      announcementList.assignAll(announcementOriginalList);
    }
  }

  Future<void> refreshData() async {
    await fetchAnnouncements();
  }
}
