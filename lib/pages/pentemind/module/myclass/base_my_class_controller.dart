import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/APIService.dart';
import '../../../../helper/LocalConstant.dart';

abstract class BaseMyClassController extends GetxController {
  final APIService apiService = APIService();
  final RxBool isLoading = true.obs;
  
  late SharedPreferences prefs;
  String uid = '';
  String userId = '';
  String userName = '';
  String token = '';
  String userType = '';
  int programId = 0;
  int classId = 0;
  String className = '';
  String programName = '';
  int studentId = 0;
  String entityId = '';

  @override
  void onInit() {
    super.onInit();
    initBase();
  }

  Future<void> initBase() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    userId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
    userName = prefs.getString(LocalConstant.KEY_USER_NAME) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) ?? 0;
    className = prefs.getString(LocalConstant.KEY_CURRENT_CLASS_NAME) ?? 'No class';
    programName = prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? 'No program';
    entityId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    try {
      studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    } catch (e) {}
    await onReadyToFetch();
  }

  /// Called after user info is loaded from SharedPreferences.
  /// Override this to load offline data and fetch from API.
  Future<void> onReadyToFetch();
}
