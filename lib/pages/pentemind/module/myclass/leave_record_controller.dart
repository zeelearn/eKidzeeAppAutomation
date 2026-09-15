import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/request/pentemind/myclass/leave_approve.dart';
import '../../../../../api/request/pentemind/myclass/leave_records.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/myclass/leave_records.dart';
import '../../../../helper/utils.dart';
import 'base_my_class_controller.dart';

class LeaveRecordController extends BaseMyClassController {
  final RxList<LeaveInfoModel> mLeaveOriginalInfoList = <LeaveInfoModel>[].obs;
  final RxList<LeaveInfoModel> mLeaveAllInfoList = <LeaveInfoModel>[].obs;
  final RxList<LeaveInfoModel> mLeaveAckInfoList = <LeaveInfoModel>[].obs;
  final RxBool isBaseLoaded = false.obs;
  final RxString currentSearchText = "".obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  @override
  Future<void> onReadyToFetch() async {
    isBaseLoaded.value = true;
    await loadOfflineData();
    await fetchLeaveRecords();
  }

  String _getCacheKey() {
    return 'leave_record_${userId}_$programId';
  }

  bool canAcknowledge() {
    String type = userType.toLowerCase();
    return type == 'cm' || type == 'cc' || type == 'teach';
  }

  Future<void> loadOfflineData() async {
    try {
      String? cachedData = prefs.getString(_getCacheKey());
      if (cachedData != null) {
        LeaveRecordResponse response =
            LeaveRecordResponse.fromJson(json.decode(cachedData));
        if (response.data.isNotEmpty && response.data[0].Leave.isNotEmpty) {
          _updateLists(response.data[0].Leave);
          isLoading.value = false;
        }
      }
    } catch (e) {
      debugPrint('Error loading offline data: $e');
    }
  }

  Future<void> fetchLeaveRecords() async {
    if (!await Utility.isInternet()) {
      if (mLeaveOriginalInfoList.isEmpty) {
        isLoading.value = false;
      }
      return;
    }

    try {
      if (mLeaveOriginalInfoList.isEmpty) {
        isLoading.value = true;
      }

      LeaveRecordRequest request = LeaveRecordRequest(
          UserId: uid,
          ProgramId: programId.toString(),
          TeacherId: userId,
          StudentID: studentId.toString());

      final response = await apiService.getLeaveRecords(request, token);

      if (response != null &&
          response.data.isNotEmpty &&
          response.data[0].Leave.isNotEmpty) {
        _updateLists(response.data[0].Leave);
        prefs.setString(_getCacheKey(), jsonEncode(response.toJson()));
        // } else if (response != null &&
        //     response.data.isNotEmpty &&
        //     response.data[0].Notification.isNotEmpty) {
        //   _updateLists(response.data[0].Notification
        //       .map((e) => LeaveInfoModel(
        //           ID: 1,
        //           Subject: e.Subject,
        //           Body: e.Body,
        //           Date: e.Date,
        //           ApprovalStatus: ''))
        //       .toList());
        //   prefs.setString(_getCacheKey(), jsonEncode(response.toJson()));
      } else {
        mLeaveOriginalInfoList.clear();
        mLeaveAllInfoList.clear();
        mLeaveAckInfoList.clear();
      }
      update();
    } catch (e) {
      debugPrint('Error fetching leave records: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLists(List<LeaveInfoModel> leaves) {
    mLeaveOriginalInfoList.assignAll(leaves);
    _applySearch(currentSearchText.value);
  }

  void performSearch(String text) {
    currentSearchText.value = text;
    _applySearch(text);
  }

  void _applySearch(String text) {
    if (text.isEmpty) {
      mLeaveAllInfoList.assignAll(mLeaveOriginalInfoList);
      mLeaveAckInfoList.assignAll(mLeaveOriginalInfoList
          .where((element) => element.ApprovalStatus.toLowerCase() == 'pending')
          .toList());
      return;
    }

    String query = text.toLowerCase();
    mLeaveAllInfoList.assignAll(mLeaveOriginalInfoList
        .where((element) =>
            element.Body.toLowerCase().contains(query) ||
            element.Subject.toLowerCase().contains(query) ||
            element.ApprovalStatus.toLowerCase().contains(query))
        .toList());

    mLeaveAckInfoList.assignAll(mLeaveOriginalInfoList
        .where((element) =>
            element.ApprovalStatus.toLowerCase() == 'pending' &&
            (element.Body.toLowerCase().contains(query) ||
                element.Subject.toLowerCase().contains(query)))
        .toList());
  }

  Future<void> updateLeaveStatus(LeaveInfoModel model, String status) async {
    if (!await Utility.isInternet()) {
      Get.snackbar("No Internet", "Please check your internet connection");
      return;
    }

    try {
      isLoading.value = true;
      LeaveApproveRequest request = LeaveApproveRequest(
          ID: model.ID.toString(), Status: status, UserId: uid);

      final response = await apiService.updateLeaveRecord(request, token);

      if (response is GenericResponse && response.success == 200) {
        Get.snackbar("Success", response.response[0].response);
        await fetchLeaveRecords();
      }
    } catch (e) {
      debugPrint('Error updating leave status: $e');
      Get.snackbar("Error", "Failed to update leave status");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchLeaveRecords();
  }
}
