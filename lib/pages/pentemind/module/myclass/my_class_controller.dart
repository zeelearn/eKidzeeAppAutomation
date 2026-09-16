import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../api/request/pentemind/get_culmination.dart';
import '../../../../api/request/pentemind/myclass/StudentListRequest.dart';
import '../../../../api/request/pentemind/myclass/attandance_request.dart';
import '../../../../api/request/pentemind/myclass/day_calendar.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/culmination_response.dart';
import '../../../../api/response/pentemind/get_day_response.dart';
import '../../../../api/response/pentemind/myclass/day_calender.dart';
import '../../../../api/response/pentemind/myclass/student_list_response.dart';
import '../../../../helper/DatabaseHelper.dart';
import '../../../../helper/KidzeePref.dart';
import '../../../../helper/LocalConstant.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import '../../../../iface/onResponse.dart';
import '../../../home/model/StatusModel.dart';
import '../../../notification/NotificationService.dart';
import 'base_my_class_controller.dart';

class MyClassController extends BaseMyClassController implements onResponse {
  final RxBool isInternet = true.obs;
  final RxBool isFilterApplied = false.obs;
  final RxInt selectedIndex = 0.obs;

  final RxList<StudentInfoModel> studentList = <StudentInfoModel>[].obs;
  final RxList<CuminationDayModel> culDay = <CuminationDayModel>[].obs;
  final RxList<CuminationDayModel> floatingDays = <CuminationDayModel>[].obs;
  final RxList<String> options = ['Culmination'].obs;
  final RxList<String> weekOptions = ['All Week'].obs;

  final RxString chosenValue = 'Culmination'.obs;
  final RxString chosenWeekValue = 'All Week'.obs;
  final RxString floatingDay = 'Select Floating Day'.obs;
  final RxString selectedDate = ''.obs;
  final RxString selectedDay = ''.obs;
  final RxString lastSyncDate = ''.obs;

  final RxInt day = (-1).obs;
  final RxInt isAttendanceAllowed = 0.obs;
  final RxInt totalStudent = 0.obs;
  final RxInt totalPresentStudent = 0.obs;
  final RxInt totalAbsentStudent = 0.obs;

  int ayId = 25;
  String term = '';

  CulminationResponse? mCulminations;
  DayCalenderResponse? dayCalendarResponse;

  final RxList<String> floatingDayOptions = [
    'Select Floating Day',
    'Celebration /Event',
    'PTM',
    'Field Trip',
    'Discretionary Holiday',
    'Health Checkups',
    'Annual Day',
    'Sports Day',
    'Buffer Day',
    'Settling Day'
  ].obs;

  // String get term {
  //   if (programName.toUpperCase().contains('PG') ||
  //       programName.toUpperCase().contains('PLAYGROUP')) return 'PG';
  //   if (programName.toUpperCase().contains('NURSERY')) return 'NURSERY';
  //   if (programName.toUpperCase().contains('K1')) return 'K1';
  //   if (programName.toUpperCase().contains('K2')) return 'K2';
  //   return 'K1'; // Default
  // }

  @override
  void onInit() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    selectedDate.value = formatter.format(now);
    super.onInit();
  }

  @override
  Future<void> onReadyToFetch() async {
    isLoading.value = true;

    // Refresh program and class info from SharedPreferences
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) ?? 0;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_CLASS_NAME) ?? 'No class';
    programName =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? 'No program';
    term = prefs.getString(LocalConstant.KEY_CURRENT_TERM) ?? '';

    debugPrint(
        'onReadyToFetch: programId=$programId, classId=$classId, term=$term');

    ayId = await KidzeePref().getAcademicYear();
    loadDefaultStudentList();
    await getCulminationList();
    await gsCulminationData();
    isLoading.value = false;
  }

  Future<void> loadDefaultStudentList() async {
    String key = '${uid}_${programId}_${LocalConstant.ACTION_ATTANDANCE}';
    var data = prefs.getString(key);
    if (data != null) {
      try {
        StudentListResponse response =
            StudentListResponse.fromJson(json.decode(data));
        studentList.assignAll(response.data);
        for (var student in studentList) {
          student.isPresent = false;
        }
        updateCounts();
      } catch (e) {
        log('Error loading default student list: $e');
      }
    }
  }

  void updateCounts() {
    int total = 0;
    int present = 0;
    int absent = 0;
    for (var student in studentList) {
      total++;
      if (student.isPresent) {
        present++;
      } else {
        absent++;
      }
    }
    totalStudent.value = total;
    totalPresentStudent.value = present;
    totalAbsentStudent.value = absent;
  }

  Future<void> getCulminationList() async {
    String cacheKey = '${uid}_${programId}_CULMINATION_LIST';
    bool internet = await Utility.isInternet();
    isInternet.value = internet;
    print('Fetching culmination list. Internet available: $internet');

    if (internet) {
      GetCulminationRequest request = GetCulminationRequest(termType: term);
      try {
        final value = await apiService.getCulmination(request, token);
        print('API response for culmination list: $value');
        if (value is CulminationResponse) {
          mCulminations = value;
          if (value.data != null && value.data!.isNotEmpty) {
            prefs.setString(cacheKey, jsonEncode(value.toJson()));
            options.assignAll(['Culmination']);
            options.addAll(value.data!.map((e) => e.culminationName!).toList());
            return;
          } else {
            print('No culmination data received from API.');
          }
        } else {
          print(
              'Unexpected response type for culmination list: ${value.runtimeType}');
        }
      } catch (e) {
        log('Error fetching culmination list: $e');
      }
    }

    // Load from cache if internet fails or no data from server
    var data = prefs.getString(cacheKey);
    if (data != null) {
      try {
        CulminationResponse response =
            CulminationResponse.fromJson(json.decode(data));
        mCulminations = response;
        if (response.data != null && response.data!.isNotEmpty) {
          options.assignAll(['Culmination']);
          options
              .addAll(response.data!.map((e) => e.culminationName!).toList());
        } else {
          showNoDataMessage('No Culmination data available offline.');
        }
      } catch (e) {
        log('Error parsing cached culmination list: $e');
        showNoDataMessage('Error loading cached data.');
      }
    } else {
      showNoDataMessage(
          'No Culmination data found. Please connect to internet.');
    }
  }

  void showNoDataMessage(String message) {
    Get.snackbar(
      "No Data",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orangeAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> gsCulminationData() async {
    bool internet = await Utility.isInternet();
    isInternet.value = internet;
    String cacheKey = getCulDayId();
    var culminationSummery = prefs.getString(cacheKey);
    lastSyncDate.value = prefs.getString('sync_$cacheKey') ?? '';

    bool isOfflineEligble = await Utility.isOfflineEligble(
        Get.context!, prefs.getString('sync_$cacheKey') ?? '');

    if (internet && (kIsWeb || !isOfflineEligble)) {
      GetDayCalenderRequest request = GetDayCalenderRequest(
          C: int.parse(getCulminationId(chosenValue.value)),
          ProgramId: programId);

      try {
        final value = await apiService.getDayCalendar(request);
        if (value != null && value.data.CulDay.isNotEmpty) {
          saveCalenderResponse(value);
          refreshCulminations(value);
          await gsOfflineData(); // Load student list
          return;
        }
      } catch (e) {
        log('Error fetching culmination data: $e');
      }
    }

    // Fallback to local data
    if (culminationSummery != null) {
      getCulminationLocalData(culminationSummery);
    } else {
      culDay.clear();
      weekOptions.assignAll(['All Week']);
      floatingDays.clear();
      if (!internet) {
        showNoDataMessage('No Calendar data available offline.');
      }
    }
    await gsOfflineData();
  }

  Future<void> loadStudentList() async {
    bool internet = await Utility.isInternet();
    isInternet.value = internet;

    if (day.value == -10) {
      for (var student in studentList) {
        student.d = 0;
      }
      selectedDay.value = 'Floating Day';
      return;
    }

    isLoading.value = true;
    totalPresentStudent.value = 0;
    totalAbsentStudent.value = 0;
    totalStudent.value = 0;

    if (internet) {
      StudentListRequest request = StudentListRequest(
          User_ID: uid,
          D: day.value,
          Program_Id: programId,
          AttendanceDate: selectedDate.value);

      try {
        final value = await apiService.getMyClassStudentList(request, token);
        if (value is StudentListResponse && value.success == 200) {
          if (value.data.isNotEmpty) {
            studentList.assignAll(value.data);
            saveAttandanceSummery(jsonEncode(value.toJson()), true);
            processStudentList(value.data);
            isLoading.value = false;
            return;
          }
        }
      } catch (e) {
        log('Error loading student list from API: $e');
      }
    }

    // Load from cache if offline or API failed/empty
    String cacheKey = getAttendanceCacheId();
    var attandanceSummery = prefs.getString(cacheKey);
    if (attandanceSummery != null) {
      getLocalData(attandanceSummery);
    } else {
      studentList.clear();
      updateCounts();
      showNoDataMessage('No Student data found for this selection.');
    }
    isLoading.value = false;
  }

  String getCulDayId() {
    return '${uid}_${programId}_${getCulminationId(chosenValue.value)}_${LocalConstant.ACTION_CULMINATION}';
  }

  String getCulminationId(String value) {
    if (value.isEmpty || value == 'Culmination') {
      if (mCulminations != null &&
          mCulminations!.data != null &&
          mCulminations!.data!.isNotEmpty) {
        return mCulminations!.data![0].c.toString();
      }
      return '0';
    }
    if (mCulminations != null && mCulminations!.data != null) {
      for (var item in mCulminations!.data!) {
        if (value == item.culminationName) {
          return item.c.toString();
        }
      }
    }
    return value;
  }

  void getCulminationLocalData(String data) {
    try {
      DayCalenderResponse response =
          DayCalenderResponse.fromJson(json.decode(data));
      refreshCulminations(response);
    } catch (e) {
      log('Error parsing culmination local data: $e');
    }
  }

  void refreshCulminations(DayCalenderResponse value) {
    dayCalendarResponse = value;
    weekOptions.assignAll(['All Week']);
    chosenWeekValue.value = 'All Week';
    floatingDays.clear();
    culDay.clear();

    if (value.data.CulDay.isNotEmpty) {
      culDay.addAll(value.data.CulDay);
      floatingDays.addAll(value.data.FloatingDay);

      Set<int> weeks = {};
      for (var dayVal in value.data.CulDay) {
        weeks.add(dayVal.W);
      }
      var sortedWeeks = weeks.toList()..sort();
      weekOptions.addAll(sortedWeeks.map((e) => e.toString()).toList());
    }
  }

  Future<void> gsOfflineData() async {
    bool internet = await Utility.isInternet();
    isInternet.value = internet;
    String cacheKey = getAttendanceCacheId();
    var attandanceSummery = prefs.getString(cacheKey);
    lastSyncDate.value = prefs.getString('sync_$cacheKey') ?? '';

    bool isOfflineEligble = await Utility.isOfflineEligble(
        Get.context!, prefs.getString('sync_$cacheKey') ?? '');
    if (attandanceSummery == null && !internet) {
      loadDefaultStudentList();
    } else if (attandanceSummery == null) {
      loadStudentList();
    } else if ((isOfflineEligble && !kIsWeb) || !internet) {
      getLocalData(attandanceSummery);
    } else {
      loadStudentList();
    }
  }

  String getAttendanceCacheId() {
    return '${uid}_${programId}_${LocalConstant.ACTION_ATTANDANCE}_${day.value}_${selectedDate.value}';
  }

  void getLocalData(String data) {
    try {
      StudentListResponse response =
          StudentListResponse.fromJson(json.decode(data));
      studentList.assignAll(response.data);
      updateCounts();
    } catch (e) {
      log('Error parsing local student data: $e');
    }
  }

  void processStudentList(List<StudentInfoModel> data) {
    totalStudent.value = data.length;
    if (data.isNotEmpty) {
      if (day.value == 0 && data[0].Remarks.isNotEmpty) {
        floatingDay.value = data[0].Remarks;
      } else if (day.value != 0) {
        floatingDay.value = '';
      }
      isAttendanceAllowed.value = data[0].BackDateAttendance;
    }
    updateCounts();
  }

  void saveAttandanceSummery(String json, bool isSync) {
    if (json.isNotEmpty) {
      String cacheKey = getAttendanceCacheId();
      prefs.setString(cacheKey, json);
      prefs.setString(
          '${uid}_${programId}_${LocalConstant.ACTION_ATTANDANCE}', json);

      if (isSync) {
        String syncTime = Utility.formatDate();
        prefs.setString('sync_$cacheKey', syncTime);
        lastSyncDate.value = syncTime;
      }
    }
  }

  Future<void> enableFloatingDay() async {
    isFilterApplied.value = true;
    day.value = 0;
    selectedDay.value = 'Floating Day';
    await gsOfflineData();
  }

  void onChosenValueChange(String? value) {
    if (value != null) {
      isFilterApplied.value = false;
      chosenValue.value = value;
      if (value != 'Culmination') {
        gsCulminationData();
      }
    }
  }

  void onChosenWeekValueChange(String? value) {
    if (value != null) {
      isFilterApplied.value = false;
      chosenWeekValue.value = value;
      weekSorting(value == 'All Week' ? 0 : int.parse(value));
    }
  }

  void weekSorting(int weekNumber) {
    if (dayCalendarResponse == null) return;

    culDay.clear();
    if (weekNumber == 0) {
      culDay.addAll(dayCalendarResponse!.data.CulDay);
    } else {
      culDay.addAll(
          dayCalendarResponse!.data.CulDay.where((d) => d.W == weekNumber));
    }
  }

  Future<void> saveAttendance(onClickListener listener,
      {dynamic widgetListener}) async {
    if (day.value == 0 &&
        (floatingDay.value == 'Select Floating Day' ||
            floatingDay.value.isEmpty)) {
      Utility.alert(Get.context!, 'Alert', 'Please Select Floating Day', null);
      return;
    }

    isLoading.value = true;

    bool internet = await Utility.isInternet();
    List<AttandanceModel> studentAttendanceList = studentList
        .map((s) =>
            AttandanceModel(studentID: s.studentID, isPresent: s.isPresent))
        .toList();

    AttandanceRequest request = AttandanceRequest(
        teacherId: userId,
        userId: uid,
        programID: programId.toString(),
        d: day.value.toString(),
        inputDate: selectedDate.value,
        attandanceList: studentAttendanceList,
        remarks: floatingDay.value == 'Select Floating Day'
            ? ''
            : floatingDay.value);

    if (!internet) {
      updateDataAfterAttendance();
      StudentListResponse response =
          StudentListResponse(success: 200, data: studentList.toList());
      saveAttandanceSummery(jsonEncode(response.toJson()), false);

      DBHelper dbHelper = DBHelper();
      dbHelper.insertSyncData(
          request.toJson(), LocalConstant.ACTION_ATTANDANCE, int.parse(userId));

      final statusBox = await Hive.openBox(LocalConstant.logbookStatus);
      if (day.value != 0 && term != 'EARLY') {
        await statusBox.add(StatusModel(
            programID: programId,
            classID: classId.toString(),
            day: int.parse(day.value.toString()),
            logbookStatus: false,
            className: programName));
      }

      Utility.getConfirmationMyClassDialog(
        Get.context!,
        day.value == 0
            ? 'Floating Day Attendance Request Received!'
            : 'Attendance Request Received!',
        day.value == 0
            ? 'Attendance request for Floating  Day has been received. You shall be notified once uploaded.'
            : 'Attendance request for Day ${day.value} has been received. You shall be notified once uploaded.',
        InsertClickListener(
          () => isFilterApplied.value = false,
        ),
      );

      NotificationService().showNotification(
          12,
          day.value == 0
              ? 'Floating Day Attendance Request Received!'
              : 'Attendance Request Received',
          day.value == 0
              ? 'Attendance request for Floating  Day has been received. You shall be notified once uploaded.'
              : 'Attendance request for Day ${day.value} has been received. You shall be notified once uploaded.',
          'Attendance request for Day ${day.value} has been received. You shall be notified once uploaded.');

      isLoading.value = false;
    } else {
      await clearLearningGoal();
      try {
        final value = await apiService.insertAttendance(request, token);
        if (value is GenericResponse) {
          updateDataAfterAttendance();
          loadStudentList();
          final statusBox = await Hive.openBox(LocalConstant.logbookStatus);

          if (day.value != 0 && term != 'EARLY') {
            await statusBox.add(StatusModel(
                programID: programId,
                classID: classId.toString(),
                day: int.parse(day.value.toString()),
                logbookStatus: false,
                className: programName));
          }

          String message = '';
          if (value.response is String) {
            message = value.response;
          } else if (value.response is List) {
            message = value.response[0].response;
          } else {
            message = value.response.response.toString();
          }

          Utility.getConfirmationMyClassDialog(
              Get.context!,
              message,
              '',
              InsertClickListener(
                () => isFilterApplied.value = false,
              ),
              term == 'EARLY' ? null : widgetListener,
              term == 'EARLY' ? '' : day.value.toString(),
              term == 'EARLY' ? '' : programId.toString());

          updateAttandanceDay(day.value);

          GetDayCalenderRequest calRequest = GetDayCalenderRequest(
              C: int.parse(getCulminationId(chosenValue.value)),
              ProgramId: programId);

          final calValue = await apiService.getDayCalendar(calRequest);
          if (calValue != null) {
            saveCalenderResponse(calValue);
            refreshCulminations(calValue);
          }
        }
      } catch (e) {
        log('Error saving attendance: $e');
        Utility.alert(Get.context!, 'Alert', "Unable to save Attendance", null);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void updateDataAfterAttendance() {
    for (var d in culDay) {
      if (d.D == day.value) {
        d.IsDisabled = true;
        d.AttendanceDate = selectedDate.value;
      }
    }
  }

  Future<void> clearLearningGoal() async {
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.contains('${LocalConstant.MENU_LG_FACILATOR_SAYS}') ||
          key.contains('${LocalConstant.MENU_TRACKER}')) {
        prefs.remove(key);
      }
    }
  }

  void updateAttandanceDay(int dayVal) async {
    GetDayResponse? dayModel = await KidzeePref.getDay(Get.context!);
    if (dayModel.data.D != dayVal) {
      dayModel.data.D = dayVal;
      dayModel.data.CName = 'NA';
      KidzeePref.setDay(Get.context!, programId, jsonEncode(dayModel.toJson()));
    }
  }

  @override
  void onResponse(value) {}

  @override
  void onSuccess(value) {
    if (value is DayCalenderResponse) {
      saveCalenderResponse(value);
      refreshCulminations(value);
    }
  }

  @override
  void onError(int action, value) {}

  @override
  void onResponseStart() {}

  void saveCalenderResponse(DayCalenderResponse dayModel) {
    String json = jsonEncode(dayModel);
    String cacheKey = getCulDayId();
    prefs.setString(cacheKey, json);
    prefs.setString('sync_$cacheKey', Utility.formatDate());
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year, DateTime.now().month - 12, 1),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
}

class InsertClickListener implements onClickListener {
  final Function() callback;

  InsertClickListener(this.callback);
  @override
  void onClick(int action, dynamic response) {
    if (action == Utility.ACTION_OK) {
      Get.back();
      callback();
    }
  }
}
