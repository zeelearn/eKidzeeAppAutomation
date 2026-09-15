import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/parent_corner/artsy_request.dart';
import '../../../../api/response/pentemind/parent_corner/artst.dart';
import '../../../../helper/LocalConstant.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';

class ArtsyController extends GetxController implements onClickListener {
  final RxList<ArtsyModel> mArtsyList = <ArtsyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString chosenValue = '1'.obs;
  final List<String> options = ['1', '2', '3', '4'];

  late SharedPreferences prefs;
  String uid = '';
  String token = '';
  int programId = 0;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    getOfflineData();
  }

  void getOfflineData() {
    var offlineData = prefs.getString(getId());
    if (offlineData == null) {
      getArtsyList();
    } else {
      getLocalData(offlineData);
    }
  }

  bool getLocalData(String? data) {
    if (data == null) return false;
    try {
      mArtsyList.clear();
      isLoading.value = false;
      ArtsyResponse response = ArtsyResponse.fromJson(json.decode(data));
      mArtsyList.addAll(response.artsyList);
      return true;
    } catch (e) {
      debugPrint('Error loading local data: $e');
      return false;
    }
  }

  String getId() {
    return '${uid}_${chosenValue.value}_${LocalConstant.MENU_ARTSY}';
  }

  void saveOfflineData(String json) {
    prefs.setString(getId(), json);
  }

  Future<void> getArtsyList() async {
    mArtsyList.clear();
    isLoading.value = true;
    
    ArtsyRequest request = ArtsyRequest(
        ProgramID: programId,
        C: chosenValue.value,
        FeeType: '',
        UserID: uid,
        StudentID: 0);
        
    try {
      APIService apiService = APIService();
      final value = await apiService.getArtsy(request, token);
      
      if (value != null && value is ArtsyResponse) {
        String json = jsonEncode(value);
        saveOfflineData(json);
        mArtsyList.assignAll(value.artsyList);
      } else {
        // Utility.showMessages(Get.context!, 'Data not found');
      }
    } catch (e) {
      debugPrint('Error fetching artsy list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateCulmination(String? value) {
    if (value != null) {
      chosenValue.value = value;
      getOfflineData();
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      updateCulmination(value.toString());
    }
  }
}
