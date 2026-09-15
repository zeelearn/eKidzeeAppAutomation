import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../api/request/pentemind/base_request.dart';
import '../../../../api/response/pentemind/myclass/parentnote.dart';
import '../../../../helper/LocalConstant.dart';
import '../../../../helper/utils.dart';
import 'base_my_class_controller.dart';

class ParentNoteController extends BaseMyClassController {
  final RxList<ParentNoteModel> parentNoteList = <ParentNoteModel>[].obs;
  final RxBool isBaseLoaded = false.obs;

  @override
  Future<void> onReadyToFetch() async {
    isBaseLoaded.value = true;
    await loadOfflineData();
    await fetchParentNotes();
  }

  String _getCacheKey() {
    return 'parent_note_${userId}_$programId';
  }

  Future<void> loadOfflineData() async {
    try {
      String? cachedData = prefs.getString(_getCacheKey());
      if (cachedData != null) {
        ParentNoteResponse response = ParentNoteResponse.fromJson(json.decode(cachedData));
        parentNoteList.assignAll(response.parentNoteList);
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint('Error loading offline data: $e');
    }
  }

  Future<void> fetchParentNotes() async {
    if (!await Utility.isInternet()) {
      if (parentNoteList.isEmpty) {
        isLoading.value = false;
      }
      return;
    }

    try {
      if (parentNoteList.isEmpty) {
        isLoading.value = true;
      }
      
      BasePentemindRequest request = BasePentemindRequest(Program_ID: programId, userId: uid);
      final response = await apiService.getParentNote(request, token);
      
      if (response != null) {
        parentNoteList.assignAll(response.parentNoteList);
        prefs.setString(_getCacheKey(), jsonEncode(response.toJson()));
      }
    } catch (e) {
      debugPrint('Error fetching parent notes: $e');
      if (parentNoteList.isEmpty) {
        Get.snackbar("Error", "Failed to load parent notes");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchParentNotes();
  }
}
