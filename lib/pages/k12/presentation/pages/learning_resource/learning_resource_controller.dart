import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/APIService.dart';
import '../../../../../api/request/pentemind/LookUpRequest.dart';
import '../../../../../api/request/pentemind/learningmaterial/learning_material.dart';
import '../../../../../api/response/pentemind/get_day_response.dart';
import '../../../../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../../../../api/response/pentemind/lookupresponse.dart';
import '../../../../../helper/KidzeePref.dart';
import '../../../../../helper/LocalConstant.dart';
import '../../../../../helper/utils.dart';
import '../../../../../iface/onClick.dart';

class LearningResourceController extends GetxController implements onClickListener {
  final bool isForNepal;
  LearningResourceController({required this.isForNepal});

  final RxBool isLoading = true.obs;
  final RxList<LearningMaterialModel> mMaterials = <LearningMaterialModel>[].obs;
  final RxList<String> options = ['Select Category'].obs;
  final RxString chosenValue = 'Select Category'.obs;
  
  final TextEditingController dayController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController chapterController = TextEditingController();

  final RxString selectedSubject = 'HIndi'.obs;
  final RxString selectedChapter = 'HIndi1'.obs;
  final List<String> subjectoptions = ['HIndi', 'English', 'Maths', 'Geogrphy'];
  final List<String> chapteroptions = ['HIndi1', 'English1', 'Maths1', 'Geogrphy1'];

  late SharedPreferences prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String countryName = '';
  int programId = 0;
  LookUpResponse? menuResponse;
  String cName = '';

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      GetDayResponse? dayModel = await KidzeePref.getDay(Get.context!);
      dayController.text = dayModel.data.D.toString();
      cName = dayModel.data.CName;
      await getUserInfo();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      isLoading.value = false;
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    countryName = prefs.getString(LocalConstant.KEY_COUNTRY_NAME) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    if (userType == 'P') {
      options.assignAll(['Select Category', 'Rhymes', 'AV\'s']);
      getMaterials();
    } else {
      await getMenu();
    }
  }

  Future<void> getMenu() async {
    var menuList = prefs.getString('menu${getId()}${Utility.getDay()}');
    if (menuList != null && menuList.isNotEmpty) {
      try {
        menuResponse = LookUpResponse.fromJson(json.decode(menuList));
        if (menuResponse != null) {
          resetOptions();
          for (var item in menuResponse!.data) {
            options.add(item.LookupName);
          }
          getMaterials();
        }
      } catch (e) {
        await getMenusFromServer();
      }
    } else {
      await getMenusFromServer();
    }
  }

  void resetOptions() {
    options.assignAll(['Select Category']);
    chosenValue.value = 'Select Category';
  }

  Future<void> getMenusFromServer() async {
    isLoading.value = true;
    GetLookupRequest request = GetLookupRequest(
        LookupType: 'LRNMTRLS', Country: isForNepal ? countryName : '');
    try {
      var value = await APIService().getLearningMaterialMenu(request, token);
      if (value != null && value is LookUpResponse) {
        menuResponse = value;
        prefs.setString('menu${getId()}${Utility.getDay()}', jsonEncode(value));
        resetOptions();
        for (var item in menuResponse!.data) {
          options.add(item.LookupName);
        }
      }
    } catch (e) {
      debugPrint('Error fetching menus: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getId() {
    return '${uid}_${isForNepal ? 1 : 0}${dayController.text}_${LocalConstant.MENU_DAILY_ACTIVITY}${chosenValue.value}';
  }

  String getLearningCategory() {
    if (menuResponse != null) {
      for (var item in menuResponse!.data) {
        if (chosenValue.value == item.LookupName) {
          return item.LookupCode;
        }
      }
    }
    switch (chosenValue.value) {
      case 'Critcal Thinking': return 'CRTHK';
      case 'Rhymes': return 'RHYMS';
      case 'AV\'s': return 'VIDEO';
      case 'Sound Track': return 'SDTRK';
      case 'Tell-a-Tale': return 'TEATA';
      case 'Print': return 'PRINT';
      default: return '';
    }
  }

  Future<void> getMaterials() async {
    String categoryType = getLearningCategory();
    if (categoryType.isEmpty || categoryType == 'Select Category') {
      isLoading.value = false;
      mMaterials.clear();
      return;
    }

    isLoading.value = true;
    LearningMaterialRequest request = LearningMaterialRequest(
        ProgramID: programId.toString(),
        D: dayController.text,
        ContentCategory: categoryType,
        UserID: uid);

    try {
      var value = await APIService().getLearningMaterials(request, isForNepal, token);
      if (value != null && value is LearningMaterialResponse) {
        mMaterials.assignAll(value.data.mateialList);
        cName = value.data.CName;
        prefs.setString(getId(), jsonEncode(value));
      } else {
        mMaterials.clear();
      }
    } catch (e) {
      debugPrint('Error fetching materials: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(String? value) {
    if (value != null) {
      chosenValue.value = value;
      getMaterials();
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      updateCategory(value.toString());
    }
  }
}
