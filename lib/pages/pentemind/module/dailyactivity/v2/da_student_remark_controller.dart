import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/request/pentemind/dailyactivity/studentlist.dart';
import '../../../../../api/request/pentemind/dailyactivity/update_workbook.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/dailyactivity/activityresponse.dart';
import '../../../../../api/response/pentemind/dailyactivity/student_list.dart';
import '../../../../../helper/LocalConstant.dart';

class DAStudentRemarkController extends GetxController {

  /// -------------------- DEPENDENCIES --------------------
  final APIService _apiService = APIService();

  /// -------------------- REACTIVE STATES --------------------
  final RxBool isLoading = true.obs;
  final RxBool isSelectAll = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxList<DAStudentInfo> studentList = <DAStudentInfo>[].obs;
  final RxMap<int, String> selectedStatus = <int, String>{}.obs;

  /// -------------------- LOCAL DATA --------------------
  late SharedPreferences prefs;

  String uid = '';
  String token = '';
  int programId = 0;

  late DailyActivityModel model;
  late int day;
  late String dwsType;

  /// -------------------- INIT --------------------
  void initialize({
    required DailyActivityModel activityModel,
    required int selectedDay,
    required String type,
  }) {
    model = activityModel;
    day = selectedDay;
    dwsType = type;

    loadUserInfo();
  }

  /// -------------------- LOAD USER --------------------
  Future<void> loadUserInfo() async {
    prefs = await SharedPreferences.getInstance();

    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    await fetchStudents();
  }

  /// -------------------- FETCH STUDENTS --------------------
  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;

      DailyActivityStudListRequest request = DailyActivityStudListRequest(
        UserID: uid,
        ProgramId: programId.toString(),
        LogBookID: model.LogBookID,
        D: day,
        DWSType: dwsType == 'MID' ? 'DAILY' : dwsType,
      );

      final response = dwsType == 'MID'
          ? await _apiService.getDailyMidTermActivityStudentList(request, token)
          : await _apiService.getDailyActivityStudentList(request, token);

      if (response is DailyActivityStudListResponse) {
        studentList.assignAll(response.studentList);

        // Initialize default selection
        for (int i = 0; i < studentList.length; i++) {
          selectedStatus[i] = studentList[i].StatusCode ?? '';
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -------------------- UPDATE STATUS --------------------
  void updateStudentStatus(int index, String status) {
    selectedStatus[index] = status;
    studentList[index].StatusCode = status;
    studentList.refresh();
  }

  /// -------------------- SELECT ALL --------------------
  void toggleSelectAll(bool value) {
    isSelectAll.value = value;

    for (int i = 0; i < studentList.length; i++) {
      if (studentList[i].IsPresent) {
        selectedStatus[i] = value ? 'C' : '';
        studentList[i].StatusCode = value ? 'C' : '';
      }
    }

    studentList.refresh();
  }

  /// -------------------- SUBMIT --------------------
  Future<void> submitFeedback() async {
    try {
      isSubmitting.value = true;

      List<DAStudentInfo> selectedStudents = studentList
          .where((e) => e.IsPresent && e.StatusCode.isNotEmpty)
          .toList();

      if (selectedStudents.isEmpty) {
        Get.snackbar("Validation", "Please select observation");
        return;
      }

      UpdateDailyWorkbookRequest request = UpdateDailyWorkbookRequest(
        LogBookID: model.LogBookID,
        UserId: uid,
        ProgramID: programId.toString(),
        InputDate:
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
        InputData: selectedStudents,
      );

      final response =
      await _apiService.updateDailyWorkbook(request, token);

      if (response is GenericResponse && response.success == 200) {
        Get.back(result: "DONE");
        Get.snackbar("Success", response.response.toString());
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
