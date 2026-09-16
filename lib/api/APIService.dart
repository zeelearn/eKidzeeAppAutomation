import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:either_dart/either.dart';
import 'package:ekidzee/api/request/EventHappeningImagesRequest.dart';
import 'package:ekidzee/api/request/add_remark.dart';
import 'package:ekidzee/api/request/attendance_request.dart';
import 'package:ekidzee/api/request/batch_request.dart';
import 'package:ekidzee/api/request/bpms/franchisee_details_request.dart';
import 'package:ekidzee/api/request/bpms/getTaskDetailsRequest.dart';
import 'package:ekidzee/api/request/bpms/get_communication.dart';
import 'package:ekidzee/api/request/bpms/get_task_comments.dart';
import 'package:ekidzee/api/request/bpms/insert_attachment.dart';
import 'package:ekidzee/api/request/bpms/update_task.dart';
import 'package:ekidzee/api/request/celibration/celibration_request.dart';
import 'package:ekidzee/api/request/change_password.dart';
import 'package:ekidzee/api/request/diary_request.dart';
import 'package:ekidzee/api/request/digital_resouce_request.dart';
import 'package:ekidzee/api/request/eventhappening_request.dart';
import 'package:ekidzee/api/request/fcmRequest.dart';
import 'package:ekidzee/api/request/forgotpassword_request.dart';
import 'package:ekidzee/api/request/holiday_request.dart';
import 'package:ekidzee/api/request/induction/franchisee/induction_approve_request.dart';
import 'package:ekidzee/api/request/induction/teacher/InductionContentLogRequest.dart';
import 'package:ekidzee/api/request/induction/teacher/enroll_request.dart';
import 'package:ekidzee/api/request/induction/teacher/induction_status_request.dart';
import 'package:ekidzee/api/request/interceptor.dart';
import 'package:ekidzee/api/request/login_model.dart';
import 'package:ekidzee/api/request/otp_authrequest.dart';
import 'package:ekidzee/api/request/otp_request.dart';
import 'package:ekidzee/api/request/parent_request.dart';
import 'package:ekidzee/api/request/pentemind/LookUpRequest.dart';
import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/api/request/pentemind/base_termrequest.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/homework_request.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/studentlist.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/studentlist_request.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/update_homework_teacher.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/update_workbook.dart';
import 'package:ekidzee/api/request/pentemind/elg_stud_list.dart';
import 'package:ekidzee/api/request/pentemind/facilatortool/lessonplanrequest.dart';
import 'package:ekidzee/api/request/pentemind/get_culmination.dart';
import 'package:ekidzee/api/request/pentemind/get_day.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/AcademicRequest/GetAcademicRequest.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/AcademicRequest/academic_feedback_request.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/GetAnecdotalGeneralHealthAndHygieneResponse.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/developmental/GetLearningGoalAcademic.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/developmental/developmental_student_list.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/facilatorsays/GetAnecdotalStudentList.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/get_whatwentwell.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/api/request/pentemind/learningmaterial/learning_material.dart';
import 'package:ekidzee/api/request/pentemind/myclass/StudentListRequest.dart';
import 'package:ekidzee/api/request/pentemind/myclass/add_new_annoucement.dart';
import 'package:ekidzee/api/request/pentemind/myclass/approval_request.dart';
import 'package:ekidzee/api/request/pentemind/myclass/attandance_request.dart';
import 'package:ekidzee/api/request/pentemind/myclass/cm_approve.dart';
import 'package:ekidzee/api/request/pentemind/myclass/day_calendar.dart';
import 'package:ekidzee/api/request/pentemind/myclass/getnnnoucement.dart';
import 'package:ekidzee/api/request/pentemind/myclass/leave_approve.dart';
import 'package:ekidzee/api/request/pentemind/myclass/leave_records.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/add_leave_request.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/artsy_request.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/elg_request.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/elgdetail.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/student_list.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/update_artsy_parent.dart';
import 'package:ekidzee/api/request/pentemind/parent_corner/update_elg.dart';
import 'package:ekidzee/api/request/pentemind/reports/get_report.dart';
import 'package:ekidzee/api/request/pentemind/update_homework.dart';
import 'package:ekidzee/api/request/pentemind/update_student_profile.dart';
import 'package:ekidzee/api/request/resetpassword_request.dart';
import 'package:ekidzee/api/request/save_attendance_request.dart';
import 'package:ekidzee/api/request/stud_attendance_request.dart';
import 'package:ekidzee/api/response/AttendanceInfo.dart';
import 'package:ekidzee/api/response/BatchesInfo.dart';
import 'package:ekidzee/api/response/DigitalResourseResponse.dart';
import 'package:ekidzee/api/response/EventHappeningResponse.dart';
import 'package:ekidzee/api/response/Holidaynfo.dart';
import 'package:ekidzee/api/response/academic_year.dart';
import 'package:ekidzee/api/response/bpms/franchisee_details_response.dart';
import 'package:ekidzee/api/response/bpms/getTaskDetailsResponseModel.dart';
import 'package:ekidzee/api/response/bpms/get_comments_response.dart';
import 'package:ekidzee/api/response/bpms/get_communication_response.dart';
import 'package:ekidzee/api/response/bpms/insert_attachment_response.dart';
import 'package:ekidzee/api/response/bpms/update_task_response.dart';
import 'package:ekidzee/api/response/celibration/zll_celibration_response.dart';
import 'package:ekidzee/api/response/change_password_response.dart';
import 'package:ekidzee/api/response/diary_remark_response.dart';
import 'package:ekidzee/api/response/diary_response.dart';
import 'package:ekidzee/api/response/event_happening_images_response.dart';
import 'package:ekidzee/api/response/induction/franchisee/approval_response.dart';
import 'package:ekidzee/api/response/induction/franchisee/enrolled_teacher_response.dart';
import 'package:ekidzee/api/response/induction/teacher/ContentLogResponse.dart';
import 'package:ekidzee/api/response/induction/teacher/EnrollmentResponse.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_content_model.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_details_model.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_module_model.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_status_model.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_status_response.dart';
import 'package:ekidzee/api/response/opt_auth_response.dart';
import 'package:ekidzee/api/response/parent_response.dart';
import 'package:ekidzee/api/response/pentemind/GenericResponse.dart';
import 'package:ekidzee/api/response/pentemind/culmination_response.dart';
import 'package:ekidzee/api/response/pentemind/dailyactivity/activityresponse.dart';
import 'package:ekidzee/api/response/pentemind/dailyactivity/homestudentlist.dart';
import 'package:ekidzee/api/response/pentemind/dailyactivity/homework_response.dart';
import 'package:ekidzee/api/response/pentemind/dailyactivity/student_list.dart';
import 'package:ekidzee/api/response/pentemind/facilatorsays/GetAnecdotalStudentResponse.dart';
import 'package:ekidzee/api/response/pentemind/facilatorsays/get_facilator_says.dart';
import 'package:ekidzee/api/response/pentemind/facilatortool/lessonplan.dart';
import 'package:ekidzee/api/response/pentemind/facilatortool/logbookResponse.dart';
import 'package:ekidzee/api/response/pentemind/get_day_response.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/academic/GetAcademicResponse.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/academic/GetAcademicStudentListResponse.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/child_advancement.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/childinfo/ChildInformationResponse.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/developmental/DevelopmentalStudentListResponse.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/uploadimage.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/whatwentwell.dart';
import 'package:ekidzee/api/response/pentemind/learningmaterial/learning_material.dart';
import 'package:ekidzee/api/response/pentemind/lookupresponse.dart';
import 'package:ekidzee/api/response/pentemind/myclass/announancement_response.dart';
import 'package:ekidzee/api/response/pentemind/myclass/approval_response.dart';
import 'package:ekidzee/api/response/pentemind/myclass/day_calender.dart';
import 'package:ekidzee/api/response/pentemind/myclass/leave_records.dart';
import 'package:ekidzee/api/response/pentemind/myclass/leave_records_kes.dart'
    as leaveRecordKes;
import 'package:ekidzee/api/response/pentemind/myclass/parentnote.dart';
import 'package:ekidzee/api/response/pentemind/myclass/student_list_response.dart';
import 'package:ekidzee/api/response/pentemind/parent/elg_stud_response.dart';
import 'package:ekidzee/api/response/pentemind/parent/myhomework.dart';
import 'package:ekidzee/api/response/pentemind/parent_corner/artst.dart';
import 'package:ekidzee/api/response/pentemind/parent_corner/elg_details.dart';
import 'package:ekidzee/api/response/pentemind/parent_corner/elg_response.dart';
import 'package:ekidzee/api/response/pentemind/parent_corner/student_list.dart';
import 'package:ekidzee/api/response/pentemind/pentemindprogress/student_report.dart';
import 'package:ekidzee/api/response/pentemind/pentemindprogress/tracker_response.dart';
import 'package:ekidzee/api/response/pentemind/reports/get_reports.dart';
import 'package:ekidzee/api/response/pentemind/reports/logbook_response.dart';
import 'package:ekidzee/api/response/pentemind/tracker/tracker_response.dart';
import 'package:ekidzee/api/response/student_list.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as httpfile;
import 'package:http/io_client.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/LocalConstant.dart';
import '../helper/LocalStrings.dart';
import '../helper/utils.dart';
import '../helper/web_origin_url.dart';
import '../model/user_model.dart';
import '../pages/feedback/entity/question_entity.dart';
import '../pages/feedback/entity/submit_survey_entity.dart';
import '../pages/k12/data/models/general.dart';
import '../pages/k12/presentation/pages/leaves/add_leave_request_kes.dart'
    as addLeaveRequestKes;
import '../pages/k12/presentation/pages/leaves/add_leave_response.dart';
import '../pages/tracker_indent/model/TrackerIndent.dart';
import '../pages/tracker_indent/model/TrackerRequest.dart';
import 'request/k12/add_notification.dart';
import 'request/k12/general_request.dart';
import 'response/k12/notification/notification.dart';

class APIService {
  static final http = InterceptedClient();
  String url = LocalStrings.developmentBaseUrl;
  String induction_url = LocalStrings.developmentInductionUrl;
  String kidzee_url = LocalStrings.kidzeeUrl;
  String pentemind_url = LocalStrings.pentemindapi;
  String bpms_url = LocalStrings.bpms;
  String kes_url = LocalStrings.kesBaseUrl;

  static String userAgent = '';
  static String platform = '';

  APIService() {
    debugPrint('in apiService constructor');
    loadHeader();
    debugPrint('in apiService constructor load header');
    init();
    debugPrint('in apiService constructor init');
  }
  void debugPrint(dynamic message) {}
  //void debugPrint(String message) {}

  Map<String, String> getNormalHeader1() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      // Required for CORS support to work
      "Access-Control-Allow-Credentials": "true",
      // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST,GET, OPTIONS",
      'User-Agent': userAgent,
      'platform': platform,
    };
    return headers;
  }

  static Future<void> loadStaticHeader() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      userAgent = "${webBrowserInfo.browserName} ${webBrowserInfo.appVersion}";
      platform = 'web';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userAgent =
          '${androidInfo.brand} ${androidInfo.model} ${androidInfo.version.release}';
      platform = 'Android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      userAgent = '${iosInfo.utsname.machine} ${iosInfo.systemVersion}';
      platform = 'iOS';
    } else {
      userAgent = 'unknown';
      platform = 'Unknown';
    }
  }

  static Future<Map<String, String>> getNormalHeaderStatic() async {
    if (userAgent.isEmpty || platform.isEmpty) await loadStaticHeader();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      // Required for CORS support to work
      "Access-Control-Allow-Credentials": "true",
      // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST,GET, OPTIONS",
      'User-Agent': userAgent,
      'platform': platform,
    };
    return headers;
  }

  Future<void> loadHeader() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      //WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      userAgent =
          "web"; // "${webBrowserInfo.browserName} ${webBrowserInfo.appVersion}";
      platform = 'web';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userAgent =
          '${androidInfo.brand} ${androidInfo.model} ${androidInfo.version.release}';
      platform = 'Android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      userAgent = '${iosInfo.utsname.machine} ${iosInfo.systemVersion}';
      platform = 'iOS';
    } else {
      userAgent = 'unknown';
      platform = 'Unknown';
    }
  }

  Future<void> setAppUrl() async {
    debugPrint('setting api url');
    int academicYear = await KidzeePref().getAcademicYear();
    debugPrint('in API Service Academivc Year $academicYear');
    switch (academicYear) {
      case 24:
        url = LocalStrings.development24;
        pentemind_url = LocalStrings.development24;
        break;
      case 25:
        url = LocalStrings.pentemindapi;
        pentemind_url = LocalStrings.pentemindapi;
        break;
      case 26:
        url = LocalStrings.pentemindapi26;
        pentemind_url = LocalStrings.pentemindapi26;
        break;
      default:
        url = LocalStrings.pentemindapi;
        pentemind_url = LocalStrings.pentemindapi;
        break;
    }
  }

  Future<void> init() async {
    try {
      debugPrint('init Sevice Api');
      await setAppUrl();
      debugPrint('init Sevice Api done');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> secureLogin(LoginRequestModel requestModel) async {
    try {
      await setAppUrl();
      if (!kIsWeb) {
        //final http = InterceptedClient();
        debugPrint(
            'URL Secur Login → $pentemind_url${LocalStrings.SECURE_LOGIN}\nPayload → ${requestModel.toJson()}');
        final ioc = HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final http = IOClient(ioc);
        debugPrint(
            'URL Secur Login → $pentemind_url${LocalStrings.SECURE_LOGIN}\nPayload → ${requestModel.toJson()}');
        final response = await http.post(
          Uri.parse('$pentemind_url${LocalStrings.SECURE_LOGIN}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson(),
        );
        log("RESPONSE: ${response.statusCode} ${response.body}");

        final status = response.statusCode;
        debugPrint('status $status');
        if (status == 200 || status == 400) {
          debugPrint('SecureLoginResponseModel $status');
          return SecureLoginResponseModel.fromJson(json.decode(response.body));
        }

        if (status == 404 || status == 405 || status == 500) {
          debugPrint('API_BYPASS $status');
          return "API_BYPASS";
        }
        if (status == 401 || status == 403) {
          debugPrint('SecureLoginFailuarResponse $status');
          return SecureLoginFailuarResponse.fromJson(
              json.decode(response.body));
        }
        debugPrint('SecureLoginFailuarResponse $status');
        return SecureLoginFailuarResponse.fromJson(json.decode(response.body));
      }

      /// WEB LOGIN ------------------
      //await setAppUrl();
      debugPrint('$url${LocalStrings.SECURE_LOGIN}');
      debugPrint(loginHeader());
      debugPrint('body ${requestModel.toJson()}');
      final response = await http.post(
        Uri.parse('$url${LocalStrings.SECURE_LOGIN}'),
        headers: loginHeader(),
        body: requestModel.toJson(),
      );

      final status = response.statusCode;
//debugPrint('status code ${status}');
      if (status == 200 || status == 400) {
        debugPrint('SecureLoginResponseModel');
        return SecureLoginResponseModel.fromJson(json.decode(response.body));
      }
      if (status == 401) {
        return SecureLoginFailuarResponse.fromJson(json.decode(response.body));
      }
      if (status == 404 || status == 405 || status == 500) {
        debugPrint('API_BYPASS');
        return "API_BYPASS";
      }
      debugPrint('SecureLoginFailuarData');
      debugPrint('body ${response.body}');
      debugPrint(json.decode(response.body));

      return SecureLoginFailuarResponse.fromJson(json.decode(response.body));
    } catch (e) {
      debugPrint("LOGIN ERROR → ${e.toString()}");
      return null;
    }
  }

  Future<AttendanceInfo?> getAttendanceInfo(
      AttendanceRequest requestModel) async {
    try {
      await init();

      final response = await http.post(
          Uri.parse(url + LocalStrings.API_GET_STUDENT_ATTENDANCE),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        String body = "{\"data\": ${response.body} }";
        return AttendanceInfo.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      e.toString();
    }
    return null;
  }

  Future<ParentNoteResponse?> getParentNote(
      BasePentemindRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_PARENTNOTE),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ParentNoteResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      e.toString();
    }
    return null;
  }

  Future<LeaveRecordResponse?> getLeaveRecords(
      LeaveRecordRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_LEAVERECORD),
          headers: getHeader(token),
          body: requestModel.toJson());
      log('Error Leave api - ${response.body.toString()}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        try {
          return LeaveRecordResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        } catch (e) {
          debugPrint('Error Leave api - ${e.toString()}');
          return LeaveRecordResponse.from1Json(
            json.decode(response.body) as Map<String, dynamic>,
          );
        }
      } else {
        return null;
      }
    } catch (e) {
      e.toString();
      log('Error Leave api - ${e.toString()}');
    }
    return null;
  }

  Future<dynamic> updateLeaveRecord(
      LeaveApproveRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_UPDATE_PENTEMIND_LEAVERECORD),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<String?> saveAttendanceInfo(SaveAttendanceRequest requestModel) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com/Android${LocalStrings.API_SAVE_STUDENT_ATTENDANCE}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return response.body;
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      e.toString();
    }
    return null;
  }

  Future<StudentAttendanceList?> getStudentAttendanceList(
      StudentAttendanceListRequest requestModel) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com${LocalStrings.API_GET_STUDENT_ATTENDANCE_LIST}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        String body = "{\"data\": ${response.body} }";
        body = body.replaceAll('null', "\"\"");
        return StudentAttendanceList.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      e.toString();
    }
    return null;
  }

  Future<HolidayInfo?> getHolidayList(HolidayRequest requestModel) async {
    try {
      debugPrint('getHolidayList API ${requestModel.toJson()}');
      debugPrint('https://www.ekidzee.com${LocalStrings.API_GET_HOLIDAYS}');
      //await init();
      final response = await http.post(
          Uri.parse('https://www.ekidzee.com${LocalStrings.API_GET_HOLIDAYS}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        String body = "{\"data\": ${response.body} }";
        body = body.replaceAll('null', "\"\"");
        debugPrint(body);
        return HolidayInfo.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        debugPrint('in response else holiday');
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<EventHappeningResponse?> getEventHappening(
      EventHappeningRequest requestModel) async {
    try {
      await init();
      //debugPrint(requestModel.toJson());
      //debugPrint(Uri.parse('https://www.ekidzee.com' + LocalStrings.API_GET_EVENT_HAPPENING));
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com${LocalStrings.API_GET_EVENT_HAPPENING}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      ////debugPrint(response.body);
      //debugPrint('status code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        ////debugPrint(response.body);
        return EventHappeningResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<EventHappeningImagesResponse?> getEventHappeningImages(
      EventHappeningImagesRequest requestModel) async {
    try {
      await init();
      //debugPrint(Uri.parse('https://www.ekidzee.com' + LocalStrings.API_GET_EVENT_HAPPENING_IMAGES));
      //debugPrint(requestModel.toString());
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com${LocalStrings.API_GET_EVENT_HAPPENING_IMAGES}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());

      if (response.statusCode == 200 || response.statusCode == 400) {
        return EventHappeningImagesResponse.fromJson(
          json.decode(response.body) as List<dynamic>,
        );
        //debugPrint('response -----Decode');
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<DiaryResponse?> getStudentDiary(
      StudentDiaryRequest requestModel) async {
    try {
      await init();
      //debugPrint(Uri.parse('https://www.ekidzee.com' + LocalStrings.API_GET_STUDENT_DIARY_LIST));
      //debugPrint(requestModel.toString());
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com${LocalStrings.API_GET_STUDENT_DIARY_LIST}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());

      String body = "{\"data\": ${response.body} }";
      body = body.replaceAll('null', '""');

      if (response.statusCode == 200 || response.statusCode == 400) {
        return DiaryResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
        //debugPrint('response -----Decode');
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<DiaryRemarkResponse?> addDiaryRemark(
      AddDiaryRemarkRequest requestModel) async {
    try {
      await init();
      //debugPrint(Uri.parse('https://www.ekidzee.com' + LocalStrings.API_GET_SAVE_DIARY_REMARK));
      //debugPrint(requestModel.toString());
      final response = await http.post(
          Uri.parse(
              'https://www.ekidzee.com${LocalStrings.API_GET_SAVE_DIARY_REMARK}'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      String body = response.body;
      body = body.replaceAll('null', '""');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return DiaryRemarkResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<ParentInfoResponse?> getParentInfo(ParentRequest requestModel) async {
    try {
      await init();
      //debugPrint('parent id ${requestModel.parentId}');
      //debugPrint(Uri.parse(url + LocalStrings.API_GET_PARENT_INFO));
      final response = await http.post(
          Uri.parse(url + LocalStrings.API_GET_PARENT_INFO),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      //debugPrint('status code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received ${response.body}');
        String body = "{\"data\": ${response.body} }";
        body = body.replaceAll(".0", "");
        //debugPrint(body);
        return ParentInfoResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<AcademicYearInfo?> getAcademicYear() async {
    try {
      debugPrint('in the getAcademicYear');
      //await init();
      debugPrint(Uri.parse(
          "https://app.ekidzee.com${LocalStrings.API_GET_ACADEMIC_YEAR}"));
      final response = await http.post(
        Uri.parse(url + LocalStrings.API_GET_ACADEMIC_YEAR),
        headers: getNormalHeader1(),
      );
      debugPrint(response.body);
//       debugPrint('status code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');
        String body = "{\"data\": ${response.body} }";
        debugPrint(body);
        return AcademicYearInfo.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<BatchInfo?> getBatches(BatchRequest request) async {
    try {
      await init();
      //debugPrint(Uri.parse(url + LocalStrings.API_GET_BATCHES));
      //debugPrint(request.academicyear_id);
      //debugPrint(request.franchisee_id);
      final response = await http.post(
          Uri.parse(url + LocalStrings.API_GET_BATCHES),
          headers: getNormalHeader1(),
          body: request.toJson());
      //////debugPrint(response.body);
      //debugPrint('status code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');
        String body = "{\"data\": ${response.body} }";
        //debugPrint(body);
        return BatchInfo.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<String?> getOtp(OtpRequest requestModel) async {
    try {
      await init();
      //debugPrint(Uri.parse(url + LocalStrings.GET_OTP));
      //debugPrint(requestModel.MobileNo);
      //debugPrint(requestModel.Mode);
      final response = await http.post(Uri.parse(url + LocalStrings.GET_OTP),
          headers: getNormalHeader1(), body: requestModel.toJson());
      ////debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return response.body;
        /* return LoginResponseModel.fromJson(
          json.decode(response.body),
        );*/
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<OTPAuthResponse?> validateOTP(OtpAuthRequest requestModel) async {
    try {
      await init();
      //debugPrint(Uri.parse(url + LocalStrings.VALIDATE_OTP));
      //debugPrint(requestModel.Otp);
      //debugPrint(requestModel.User_Name);
      final response = await http.post(
          Uri.parse(url + LocalStrings.VALIDATE_OTP),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      ////debugPrint(response.body);
      String body = response.body;
      body = body.replaceAll("]", "");
      body = body.replaceAll("[", "");
      //body = "${body}]}";
      //body = body.replaceAll("[", "");
      //body = body.replaceAll("]", "");
      //debugPrint(body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return OTPAuthResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
        //debugPrint('response -----Decode');
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<DigitalResourceResponseModel?> getDigitalResouce(
      DigitalResouceRequest requestModel) async {
    try {
      await init();
      //debugPrint("UserId ${requestModel.User_id}");
      //debugPrint("KeySupport "+requestModel.KeySupport);
      //debugPrint(requestModel.toJson());
      //debugPrint(Uri.parse(url + LocalStrings.API_DIGITAL_RESOURCE));
      final response = await http.post(
          Uri.parse(url + LocalStrings.API_DIGITAL_RESOURCE),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      ////debugPrint('response -----');
      //////debugPrint(response.body);
      //debugPrint('response -----DONE');
      String body = "{\"data\": ${response.body}";
      body = body.replaceAll("]", "");
      body = "$body]}";
      //body = body.replaceAll("[", "");
      //body = body.replaceAll("]", "");
      ////debugPrint(body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return DigitalResourceResponseModel.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
        //debugPrint('response -----Decode');
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<ChangePasswordResponse?> changePassword(
      ChangePasswordRequest requestModel) async {
    try {
      debugPrint('change password called');
      //requestModel.Username='P1683013';

      debugPrint(Uri.parse(url + LocalStrings.API_CHANGE_PASSWORD));
      final response = await http.post(
          Uri.parse(url + LocalStrings.API_CHANGE_PASSWORD),
          headers: getNormalHeader1(),
          body: requestModel.toJson());

      debugPrint(
          'Response from password change api is- ${response.body} and request model is - ${requestModel.toJson()} - ${Uri.parse(url + LocalStrings.API_CHANGE_PASSWORD)}');
      ////debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        String body = response.body;
        body = body.replaceAll("[", "");
        body = body.replaceAll("]", "");
        //debugPrint(body);
        return ChangePasswordResponse.fromJson(
          json.decode(body),
        );
      } else {
        return ChangePasswordResponse(MSG: 'INVALID');
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return ChangePasswordResponse(MSG: 'INVALID');
    //return null;
  }

  Future<TokenResponseModel> getToken(LoginRequestModel requestModel) async {
    await init();
    final response = await http.post(Uri.parse(url + LocalStrings.GET_TOKEN),
        body: requestModel.toJson());
    if (response.statusCode == 200) {
      return TokenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      return TokenResponseModel(
          token: "", Status: "Invalid/Wrong Login Details");
    }
  }

  /// INDUCTION APIS
  Future<EnrolledTeacherList?> loadInductionRequests12(
      String franchiseeId, String year) async {
    try {
      await init();
      var body = jsonEncode({'Franchisee_Id': franchiseeId, 'Year': '22'});

      //debugPrint(Uri.parse(induction_url + LocalStrings.API_GET_ENROLLED_LIST));
      //debugPrint(body);
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_GET_ENROLLED_LIST),
          headers: getNormalHeader1(),
          body: body);
      //////debugPrint(response.body);
      //debugPrint('status code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');
        String body = "{\"inductionRequestList\": ${response.body} }";
        //debugPrint(body);

        return EnrolledTeacherList.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<dynamic> loadInductionRequests(
      String franchiseeId, String year) async {
    try {
      await init();
      var body = jsonEncode({'Franchisee_Id': franchiseeId, 'Year': year});

      //debugPrint(Uri.parse(induction_url + LocalStrings.API_GET_ENROLLED_LIST));
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_GET_ENROLLED_LIST),
          headers: getNormalHeader1(),
          body: body);
      ////debugPrint(response.body);
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');
        String body = "{\"inductionRequestList\": ${response.body} }";
        //debugPrint(body);

        EnrolledTeacherList list = EnrolledTeacherList.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );

        //debugPrint('decode $list.toJson()} ${list.inductionRequestList.length}');
        return list;
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> approveInduction(ApproveInductionRequestModel request) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_APPROVE_INDUCTION));
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_APPROVE_INDUCTION),
          headers: getNormalHeader1(),
          body: request.getJson());
      ////debugPrint(response.body);
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');

        return InductionApprovalResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> enrollmentStatus(InductionStatusRequest request) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_GET_ENROLLMENT_STATUS));
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_GET_ENROLLMENT_STATUS),
          headers: getNormalHeader1(),
          body: request.getJson());
      ////debugPrint(response.body);
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received');

        return InductionStatusResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> enrollRequest(EnrollRequest request) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_ENROLL));
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_ENROLL),
          headers: getNormalHeader1(),
          body: request.getJson());
      ////debugPrint(response.body);
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');

        return EnrollmentResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getInductionDetail(String userId) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_INDUCTION_DETAILS+"${userId}/1"));
      final response = await http.get(
        Uri.parse(
            "$induction_url${LocalStrings.API_INDUCTION_DETAILS}$userId/1"),
        headers: getNormalHeader1(),
      );
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');
        ////debugPrint(response.body);
        String responseBody = response.body;
        responseBody = responseBody.replaceAll('null', "\"\"");
        String body = "{\"data\": $responseBody }";
        //debugPrint(body);
        return InductionDetalsResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getInductionStatus(String userId) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_INDUCTION_STATUS+"${userId}/D"));
      final response = await http.post(
        Uri.parse(
            "$induction_url${LocalStrings.API_INDUCTION_STATUS}$userId/D"),
        headers: getNormalHeader1(),
      );
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');
        ////debugPrint(response.body);
        String responseBody = response.body;
        responseBody = responseBody.replaceAll('null', "0");
        String body = "{\"data\": $responseBody }";
        //debugPrint(body);
        return InductionDayStatusResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getInductionDayModule(String userId, int day) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_INDUCTION_DAY_MODULE+"${day}/${userId}"));
      final response = await http.get(
        Uri.parse(
            "$induction_url${LocalStrings.API_INDUCTION_DAY_MODULE}$day/$userId"),
        headers: getNormalHeader1(),
      );
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');
        ////debugPrint(response.body);
        String responseBody = response.body;
        responseBody = responseBody.replaceAll('null', "\"\"");
        String body = "{\"data\": $responseBody }";
        //debugPrint(body);
        return InductionDayModuleResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getInductionContnet(
      String userId, int day, int module) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_INDUCTION_CONTENT+"${module}/${userId}"));
      final response = await http.get(
        Uri.parse(
            "$induction_url${LocalStrings.API_INDUCTION_CONTENT}$module/$userId"),
        headers: getNormalHeader1(),
      );
      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');
        ////debugPrint(response.body);
        String responseBody = response.body;
        responseBody = responseBody.replaceAll('null', "\"\"");
        String body = "{\"data\": $responseBody }";
        //debugPrint(body);
        return InductionContentResponse.fromJson(
          json.decode(body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getInductionContnetView(
      String userId, String contentId, String contentType) async {
    try {
      //debugPrint(Uri.parse(induction_url + LocalStrings.API_INDUCTION_CONTENT_LOG));
      ContentLogRequest request = ContentLogRequest(
          userID: userId, contentID: contentId, contentType: contentType);
      final response = await http.post(
          Uri.parse(induction_url + LocalStrings.API_INDUCTION_CONTENT_LOG),
          headers: getNormalHeader1(),
          body: request.toJson());

      //debugPrint('status as code ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        //debugPrint('response received EnrollRequest');
        ////debugPrint(response.body);
        return ContentLogResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  /// END

  /*NEWS*/
  /// *
  /// DISCARDED
  // Future<dynamic> getNews(GetNewsRequest request) async {
  //   try {
  //     //debugPrint(request.toJson());
  //     await init();
  //     var body = jsonEncode({
  //       'User_ID': request.User_ID,
  //       'User_Type': request.User_Type,
  //       'PageIndex': request.PageIndex,
  //       'PageSize': request.PageSize,
  //       'Content_Type': request.Content_Type
  //     });
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_NEWS));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_NEWS),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received News');
  //       ////debugPrint(response.body);
  //       String body = "{\"data\": ${response.body} }";
  //       return NewsResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }

  /*END NEWS*/

/*HELPDESK*/
  // Future<dynamic> getHelpdeskList(HelpdeskRequest request) async {
  //   try {
  //     //debugPrint(request.toJson());
  //     await init();
  //     var body = jsonEncode({
  //       'FeatureQuestionAnswer_Id': request.FeatureQuestionAnswer_Id,
  //       'user_id': request.user_id,
  //       'Answer': request.Answer,
  //       'PageNo': request.PageNo,
  //       'search_Text': request.search_Text,
  //       'PageSize': request.PageSize,
  //     });
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_LIST));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_LIST),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received News');
  //       ////debugPrint(response.body);
  //       String body = "{\"data\": ${response.body} }";
  //       return HelpDeskListResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }

  // Future<dynamic> getHelpdeskLOG(HelpdeskLogRequest request) async {
  //   try {
  //     //debugPrint(request.toJson());
  //     await init();
  //     var body = jsonEncode(
  //         {'HelpdeskID': request.HelpdeskID, 'UserID': request.UserID});
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_LOG));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_LOG),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received News');
  //       ////debugPrint(response.body);
  //       String body = "{\"data\": ${response.body} }";
  //       return HelpDeskLogResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }

  // Future<dynamic> getHelpdeskRemark(HelpdeskLogRequest request) async {
  //   try {
  //     await init();
  //     var body = jsonEncode(
  //         {'HelpdeskID': request.HelpdeskID, 'UserID': request.UserID});
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_REMARK));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_REMARK),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received News');
  //       ////debugPrint(response.body);
  //       String body = "{\"remark\": ${response.body} }";
  //       return HelpDeskLogResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }
  //
  // Future<dynamic> getHelpdeskSubCategory(
  //     HelpdeskSubCategoryRequest request) async {
  //   try {
  //     await init();
  //     var body = jsonEncode({'ID': request.ID});
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_SUB_CATEGORY));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_SUB_CATEGORY),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       ////debugPrint('response received News');
  //       //////debugPrint(response.body);
  //       //String body = "{\"data\": ${response.body} }";
  //       return HelpDeskSubCategoryResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }
  //
  // Future<dynamic> getHelpDeskCategory() async {
  //   try {
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_CATEGORY));
  //     final response = await http.get(
  //       Uri.parse(kidzee_url + LocalStrings.API_GET_HELPDESK_CATEGORY),
  //       headers: getNormalHeader1(),
  //     );
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received EnrollRequest');
  //       ////debugPrint(response.body);
  //       String responseBody = response.body;
  //       responseBody = responseBody.replaceAll('null', "\"\"");
  //       String body = "{\"data\": $responseBody }";
  //       //debugPrint(body);
  //       return HelpDeskCategoryResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null; //LoginResponseModel(token:"",Status:"Invalid/Wrong Login Details");
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }

  // Future<dynamic> getMyLedger(LedgerRequest request) async {
  //   try {
  //     var body = jsonEncode({
  //       'Franchisee_Id': request.Franchisee_Id,
  //       'Status_ID': request.Status_ID,
  //       'From_Date': request.From_Date,
  //       'To_Date': request.To_Date,
  //       'SelectedYearVal': request.SelectedYearVal,
  //       'SelectedMonthVal': request.SelectedMonthVal,
  //       'Type': request.Type,
  //     });
  //
  //     //debugPrint(Uri.parse(kidzee_url + LocalStrings.API_GET_LEDGER));
  //     final response = await http.post(
  //         Uri.parse(kidzee_url + LocalStrings.API_GET_LEDGER),
  //         headers: getNormalHeader1(),
  //         body: body);
  //
  //     //debugPrint('status as code ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       //debugPrint('response received getMyLedger');
  //       ////debugPrint(response.body);
  //       String body = "{\"data\": ${response.body} }";
  //       return LedgerResponse.fromJson(
  //         json.decode(body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     //debugPrint(e.toString());
  //     e.toString();
  //   }
  // }

  Future<dynamic> getMyClassStudentList(
      StudentListRequest requestModel, String token) async {
    try {
      await init();
      var body = jsonEncode({
        'User_ID': requestModel.User_ID,
        'D': requestModel.D,
        'Program_Id': requestModel.Program_Id,
        'AttendanceDate': requestModel.AttendanceDate,
      });
      debugPrint(requestModel.toJson());
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_MYCLASS_GETSTUDENTS));
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_MYCLASS_GETSTUDENTS),
          headers: getHeader(token),
          body: body);

      //debugPrint('response ${response.body}');
      //debugPrint('body ${response.request?.url}');
      //debugPrint('headers ${response.request?.headers.toString()}');
      //debugPrint('status as code ${response.statusCode}');
//       debugPrint('response  ${response.body}');
      if (response.statusCode == 200) {
        try {
          return StudentListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        } catch (e) {
          debugPrint('Error is - $e');
          return 1;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getAnnouncementList(
      GetAnnoucementRequest requestModel, String token) async {
    try {
      await init();
      //debugPrint(Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_MYCLASS_GET_ANNOUCEMENT));
      final response = await http.post(
          Uri.parse(requestModel.isKes
              ? '${kes_url}api/LMS/GetNotification'
              : pentemind_url +
                  LocalStrings.API_GET_PENTEMIND_MYCLASS_GET_ANNOUCEMENT),
          headers: requestModel.isKes
              ? {
                  "content-type": "application/json",
                }
              : getHeader(token),
          body: requestModel.toJson());

//       debugPrint('body ${requestModel.toJson()}');
//       debugPrint('body ${response.request?.url}');
      //debugPrint('headers ${response.request?.headers.toString()}');
      //debugPrint('status as code ${response.statusCode}');
      log('response  ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return requestModel.isKes
            ? GetNotificationResponse.fromJson(
                json.decode(response.body) as Map<String, dynamic>,
              )
            : AnnouncementListResponse.fromJson(
                json.decode(response.body) as Map<String, dynamic>,
              );
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      e.toString();
    }
  }

  Future<dynamic> addNewAnnouncementList(
      NewAnnoucementRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_GET_PENTEMIND_MYCLASS_NEW_ANNOUCEMENT));
      debugPrint(requestModel.toJson());
      final response = await http.post(
        requestModel.isKes
            ? Uri.parse('${kes_url}api/LMS/AddNotification')
            : Uri.parse(pentemind_url +
                LocalStrings.API_GET_PENTEMIND_MYCLASS_NEW_ANNOUCEMENT),
        headers: requestModel.isKes
            ? {
                "content-type": "application/json",
              }
            : getHeader(token),
        body: requestModel.toJson(),
      );

      log('Response from sendAnnouncement api is - ${response.body} - ${requestModel.toJson()} - ${requestModel.isKes} - url is ${response.request!.url.toString()}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      log("send announcement error  $e");
    }
  }

  Future<dynamic> insertAttendance(
      AttandanceRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_GET_PENTEMIND_MYCLASS_INTERT_ATTENDANCE));
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_MYCLASS_INTERT_ATTENDANCE),
          headers: getHeader(token),
          body: requestModel.toJson());
      //debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertOfflineAttendance(String body) async {
    try {
      await init();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token =
          prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_GET_PENTEMIND_MYCLASS_INTERT_ATTENDANCE));
      debugPrint(body);
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_MYCLASS_INTERT_ATTENDANCE),
          headers: getHeader(token),
          body: body);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getAnecdotalChildAdvancement(
      BasePentemindRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_CHILD_ADVANCEMENT));
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_CHILD_ADVANCEMENT),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ChildAdvancementResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> saveAnecdotalChildAdvancement(
      dynamic requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_GET_PENTEMIND_LG_CHILD_INSERTADVANCEMENT));
      debugPrint(requestModel);
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_CHILD_INSERTADVANCEMENT),
          headers: getHeader(token),
          body: requestModel);
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateHomework(
      UpdateHomeWorkRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_UPDATE_PENTEMIND_HOMEWORK_STUDENTLIST));
      debugPrint(requestModel);
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_UPDATE_PENTEMIND_HOMEWORK_STUDENTLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Response body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<UploadImageResponse> uploadImage(
    String userId,
    dynamic file, {
    onClickListener? listener,
    bool isVideoFile = false,
    Function(int bytes, int totalBytes)? progress,
  }) async {
    try {
      print('Fileupload Uploading file: ${file.name}');
      print('Fileupload API endpoint: ${LocalStrings.API_FILE_UPLOAD}');
      final uri = Uri.parse(LocalStrings.API_FILE_UPLOAD);

      var request = httpfile.MultipartRequest('POST', uri);

      /// ✅ Keep headers minimal (IMPORTANT for K8s / Ingress)
      request.headers.addAll({
        'User-Agent': kIsWeb ? 'web' : 'mobile',
        //'Accept': 'application/json',
      });

      /// ✅ Detect MIME type safely
      final mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';
      final typeParts = mimeType.split('/');

      /// ✅ Add file (WITH filename - critical fix)
      if (!kIsWeb) {
        request.files.add(await httpfile.MultipartFile.fromPath(
          'inputFile',
          file.path!,
          filename: file.name, // 🔥 REQUIRED
          contentType: httpfile.MediaType(typeParts[0], typeParts[1]),
        ));
      } else {
        final mimeType =
            lookupMimeType(file.name) ?? 'application/octet-stream';
        debugPrint('Mime type is $mimeType');
        final typeParts = mimeType.split('/');

        //request.files.add(await httpfile.MultipartFile.fromPath('inputFile', file.path!,contentType: MediaType(typeParts[0], typeParts[1]) ));
        request.files.add(httpfile.MultipartFile.fromBytes(
          'inputFile',
          file.runtimeType == XFile
              ? await (file as XFile).readAsBytes()
              : file.bytes!,
          filename: file.name, // 🔥 REQUIRED
          contentType: httpfile.MediaType(typeParts[0], typeParts[1]),
        ));
      }

      /// ✅ Add fields (if backend expects)
      //request.fields['userId'] = userId;
      //request.fields['fileType'] = isVideoFile ? 'video' : 'image';

      print('Fileupload Sending request to: $uri');

      /// ✅ Send request (let http handle boundary automatically)
      var response = await request.send().timeout(
            const Duration(minutes: 5),
          );

      final responseBytes = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseBytes);

      print('Fileupload Status Code: ${response.statusCode}');
      print('Fileupload Response: $responseString');

      /// ✅ Handle response properly
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(responseString);
        final result = UploadImageResponse.fromJson(jsonData);

        listener?.onClick(Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK, result);
        return result;
      } else {
        /// 🔥 Important for debugging 500
        listener?.onClick(
          Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR,
          'Server Error: ${response.statusCode}\n$responseString',
        );

        return UploadImageResponse(
          imageModel: [],
          message: 'Upload failed (${response.statusCode})',
        );
      }
    } on TimeoutException {
      debugPrint('Timeout error');
      listener?.onClick(Utility.ACTION_REJECT, 'Request timeout');

      return UploadImageResponse(imageModel: [], message: 'Timeout');
    } catch (e) {
      debugPrint('Upload error: $e');
      listener?.onClick(Utility.ACTION_REJECT, e.toString());

      return UploadImageResponse(imageModel: [], message: 'Error');
    }
  }

  Future<UploadImageResponse> uploadImage1(String userId, dynamic file,
      {onClickListener? listener,
      bool isVideoFile = false,
      Function(int bytes, int totalBytes)? progress}) async {
    debugPrint('image is 1057 1pi ${file.name}');
    debugPrint('api is ${LocalStrings.API_FILE_UPLOAD}');
    var postUri = Uri.parse(LocalStrings.API_FILE_UPLOAD);
    //debugPrint(postUri);
    var request = httpfile.MultipartRequest('POST', postUri);
    request.headers.addAll({
      //'Accept': 'application/json',
      //'Content-Type': 'multipart/form-data',
      'User-Agent': 'mobile'
    });
    //request.files.add(await http.MultipartFile.fromPath('inputFile', image));

    // Add the file to the request
    if (!kIsWeb) {
      final mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';
      debugPrint('Mime type is $mimeType');
      final typeParts = mimeType.split('/');

      request.files.add(await httpfile.MultipartFile.fromPath(
          'inputFile', file.path!,
          contentType: httpfile.MediaType(typeParts[0], typeParts[1])));
    } else if (file.bytes != null) {
      final mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';
      final typeParts = mimeType.split('/');
      debugPrint(
          'File bytes is - ${file.bytes} - ${httpfile.MediaType(typeParts[0], typeParts[1])} ');

      request.files.add(httpfile.MultipartFile.fromBytes(
          'inputFile', // Field name expected by the API
          file.bytes!,
          filename: file.name,
          contentType: httpfile.MediaType(typeParts[0], typeParts[1])));
    }
    try {
      var response = await request.send().timeout(const Duration(minutes: 2));
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      debugPrint('Response OK ${response.statusCode}');
      debugPrint('Response $responseString');
      listener?.onClick(
          Utility.ACTION_ALERT_OK,
          UploadImageResponse.fromJson(
            json.decode(responseString) as Map<String, dynamic>,
          ));

      return UploadImageResponse.fromJson(
        json.decode(responseString) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint(e);
      debugPrint('error');
      debugPrint(e.toString());
      listener?.onClick(Utility.ACTION_REJECT, e.toString());
      return UploadImageResponse(imageModel: [], message: '');
    }
  }

  Future<UploadImageResponse> uploadImage123(String userId, dynamic image,
      {onClickListener? listener,
      bool isVideoFile = false,
      Function(int bytes, int totalBytes)? progress}) async {
    debugPrint('api is ${LocalStrings.API_FILE_UPLOAD}');
    var postUri = Uri.parse(LocalStrings.API_FILE_UPLOAD);

    var request = httpfile.MultipartRequest('POST', postUri);
    if (!kIsWeb && (image is XFile || image is PlatformFile)) {
      request.files.add(httpfile.MultipartFile.fromBytes('inputFile',
          image is PlatformFile ? image.bytes : await image.readAsBytes(),
          filename: image is PlatformFile ? image.name : image.name));

      // request.files.add(http.MultipartFile(
      //     'inputFile', image.readAsBytes().asStream(), await image.length(),
      //     filename: image.name));
    } else {
      request.files.add(await httpfile.MultipartFile.fromPath(
          'inputFile', image is XFile ? image.path : image));
    }
    var response = await request.send();
    debugPrint('Request for file upload is - ${response.request}');
    try {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
//       debugPrint('Response OK');
      debugPrint(responseString);
      listener?.onClick(
          Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK,
          UploadImageResponse.fromJson(
            json.decode(responseString) as Map<String, dynamic>,
          ));

      return UploadImageResponse.fromJson(
        json.decode(responseString) as Map<String, dynamic>,
      );
    } catch (e) {
//       debugPrint('error');
      debugPrint(e.toString());
      listener?.onClick(
          Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR, e.toString());
      return UploadImageResponse(imageModel: [], message: '');
    }
  }

  Future<dynamic> getWhatWentWell(
      WhatWentWellRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_WWW));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_WWW),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return WhatWentWellResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> saveWhatWentWell(
      SaveWhatWentWellRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_UPDATE_WWW));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_UPDATE_WWW),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertStudentAnecdotal(
      SaveWhatWentWellRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_UPDATE_WWW));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_UPDATE_WWW),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getFacilatorSaysList(
      BasePentemindTermRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_FACILATOR_SAYS));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_FACILATOR_SAYS),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return FacilatorSaysResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getChildInformation(
      BasePentemindRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_CHILD_INFO));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_CHILD_INFO),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return ChildInformationResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getStudentListAnacdotal(
      GetAnecdotalStudentList requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(pentemind_url +
          LocalStrings.API_GET_PENTEMIND_LG_ANECDOTAL_STUDLIST));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_ANECDOTAL_STUDLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return GetAnecdotalStudentResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getAnecdotalGeneralHealthAndHygiene(
      BasePentemindTermRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(Uri.parse(
          pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_HELTHHYGINE));
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_LG_HELTHHYGINE),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('Request body ${requestModel.toJson()}');
//       debugPrint('Response body ${response.body}');
//       debugPrint('Response statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        return GetAnecdotalGeneralHealthAndHygieneResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalDevelopmental(
      DevelopmentalRequest requestModel, String token) async {
    try {
      await init();
      if (requestModel.D == 0) {
        requestModel.D = 1;
      }
      final response = await http.post(
          Uri.parse(
              '$pentemind_url/api/learningGoals/GetLearningGoalDevelopmental'),
          headers: getHeader(token),
          body: requestModel.toDevelopmentalJson());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetLearningGoalDevelopmentalResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalDevelopmentalAdditional(
      DevelopmentalRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(
          '$pentemind_url/api/learningGoals/GetLearningGoalDevelopmentaladdi');
      final response = await http.post(
          Uri.parse(
              '$pentemind_url/api/learningGoals/GetLearningGoalDevelopmentaladdi'),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());

//       debugPrint('Response ${response.body}');
      if (response.statusCode == 200) {
        return GetLearningGoalDevelopmentalResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertDevelopmentalFeedback(
      String requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_INSERT_DEVELOPMENTAL_FEEDBACK),
          headers: getHeader(token),
          body: requestModel);
      debugPrint(requestModel);
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getDay(GetDayRequest requestModel, String token) async {
    try {
      await init();

      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_GETDAY),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return GetDayResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('2317 statusCode ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getCulmination(
      GetCulminationRequest requestModel, String token) async {
    try {
      await init();
      print('Request body ${requestModel.toJson()}');
      print(Uri.parse(pentemind_url + LocalStrings.API_GET_CULMINATIONS));
      print(requestModel.toJson());
      print('Request body ${requestModel.toJson()}');
      print('Header ${getHeader(token)}');

      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_CULMINATIONS),
          headers: getHeader(token),
          body: requestModel.toJson());
      print(response.body.toString());
      if (response.statusCode == 200) {
        print('Response body ${response.body}');
        return CulminationResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        print('statusCode null');
        return null;
      }
    } catch (e) {
      print(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalDevelopmentalStudentList(
      DevelopmentalStudentListRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_DEVELOPMENTAL_STUDENTLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return DevelopmentalStudentListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalDevelopmentalADDLStudentList(
      DevelopmentalStudentListRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_DEVELOPMENTAL_ADDL_STUDENTLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return DevelopmentalStudentListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalAcademicDropdown(
      GetAcademicRequest requestModel, String token) async {
    try {
      await init();
      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_ACADEMIC_DROPDOWN),
          headers: getHeader(token),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        debugPrint(response.body);
        debugPrint(response.request!.url);
        return GetAcademicResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningGoalAcademicStudentList(
      GetAcademicRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LG_ACADEMIC_STUDENT_LIST),
          headers: getHeader(token),
          body: requestModel.getStudentList());
      if (response.statusCode == 200) {
        return GetAcademicStudentListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertAcademicFeedback(
      AcademicFeedbackRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_UPDATE_PENTEMIND_LG_ACADEMIC),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertAcademicFeedbackBg(String body, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_UPDATE_PENTEMIND_LG_ACADEMIC),
          headers: getHeader(token),
          body: body);
//       debugPrint('API_UPDATE_PENTEMIND_LG_ACADEMIC ${response.statusCode}');
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  /*LOGBOOK*/
  Future<dynamic> getFacilitatorLogBook(
      BasePentemindRequest requestModel, String day, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_LOGBOOK),
          headers: getHeader(token),
          body: requestModel.toDayJson(day));
      debugPrint(requestModel.toDayJson(day));
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return LogbookResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertLogbookRemark(String requestModel, String token) async {
    try {
      await init();
      debugPrint(requestModel);
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_INSERT_PENTEMIND_LOGBOOK),
          headers: getHeader(token),
          body: requestModel);
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  /*END LOGBOOK*/
  /*LESSON PLAN*/
  Future<dynamic> getLessonPlan(
      LessonPlanRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_LESSONPLAN),
          headers: getHeader(token),
          body: requestModel.toJson());
//       debugPrint('LessonPlanRequest ${requestModel.toJson()}');
//       debugPrint('LessonPlanRequest ${response.statusCode}');
//       debugPrint('LessonPlanRequest ${response.request!.url}');
      if (response.statusCode == 200) {
        debugPrint(response.body);
        return LessonPlanResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  //GUIDELINE
  Future<dynamic> getGuideline(
      LessonPlanRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_GUIDELINE),
          headers: getHeader(token),
          body: requestModel.toGuidelineJson());
      if (response.statusCode == 200) {
        return LessonPlanResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  /*Daily Activity*/
  Future<dynamic> getDailyActivity(
      BasePentemindRequest requestModel, String day, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_DAILY_ACTIVITY),
          headers: getHeader(token),
          body: requestModel.toDayJson(day));
      debugPrint(requestModel.toDayJson(day));
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return DailyActivityResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getDailyMidTermActivity(
      BasePentemindRequest requestModel, String day, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(LocalStrings.pentemindapi +
              LocalStrings.API_GET_PENTEMIND_DAILY_MIDTERM_ACTIVITY),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return DailyActivityResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getDailyActivityStudentList(
      DailyActivityStudListRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_DAILY_STUDLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return DailyActivityStudListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getDailyMidTermActivityStudentList(
      DailyActivityStudListRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(LocalStrings.pentemindapi +
              LocalStrings.API_GET_PENTEMIND_DAILY_MIDTERM_STUDLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return DailyActivityStudListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateDailyWorkbook(
      UpdateDailyWorkbookRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_UPDATE_PENTEMIND_DAILYACTIVITY_WORKBOOK),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getHomeWork(
      GetHomeworkRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_HOMEWORK),
          headers: getHeader(token),
          body: requestModel.toJson());
      // debugPrint(requestModel.toJson());
      // debugPrint(response.request!.url);
      // debugPrint('${pentemind_url + LocalStrings.API_GET_PENTEMIND_HOMEWORK}');
      if (response.statusCode == 200) {
        return GetHomeworkResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<Either<String, QuestionEntity>> getSurvey(
      {required int surveyId, required String userID}) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_SURVEY),
          headers: getNormalHeader1(),
          body: jsonEncode({'survey_id': surveyId, 'user_id': userID}));

      log('Reponse from getSurvey is - ${response.body}  url is - ${response.request?.url} ${jsonEncode({
            'survey_id': surveyId,
            'user_id': userID
          })}');

      if (response.statusCode == 200) {
        return Right(QuestionEntity.fromJson(json.decode(response.body),
            surveyId: surveyId, user_id: userID));
      } else {
//         debugPrint('statusCode null');
        return Left('Something went wrong');
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left('Something went wrong');
    }
  }

  Future<Either<String, dynamic>> sumbitSurvey(
      {required SubmitSurveyEntity submitSurveyEntity}) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_SUBMIT_SURVEY),
          headers: getNormalHeader1(),
          body: submitSurveyEntity.toMap());

      if (response.statusCode == 200) {
        return Right(json.decode(response.body));
      } else {
//         debugPrint('statusCode null');
        return Left('Something went wrong');
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left('Something went wrong');
    }
  }

  Future<dynamic> getHomeWorkStudentLust(
      GetHomeworkStudentRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_HOMEWORK_STUDENTLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetHomeworkStudentResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateHomeWorkStudentModel(
      UpdateHomeworkStudentRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_UPDATE_PENTEMIND_HOMEWORK_STUDENTLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningMaterialMenu(
      GetLookupRequest requestModel, String token) async {
    try {
      await init();
      SharedPreferences? sharedPref = await SharedPreferences.getInstance();
      KidzeePref mKidzeePref = KidzeePref();
      await mKidzeePref.init();
      var userProfile = await mKidzeePref.getLoginResponse();
      int? currentProgramId =
          sharedPref.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID);
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_LOOKUP),
          headers: getHeader(token),
          body: requestModel.toJson(userProfile!.uid!, currentProgramId!));
//       debugPrint('getLearningMaterialMenu');
      debugPrint(requestModel.toJson(userProfile.uid!, currentProgramId));
      debugPrint(pentemind_url + LocalStrings.API_GET_LOOKUP);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return LookUpResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getLearningMaterials(
      LearningMaterialRequest requestModel, bool isNepal, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_LEAARNING_MATERIAL +
              (isNepal == true ? 'Nepal' : '')),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.statusCode);
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return LearningMaterialResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getReports(
      GetReportRequest requestModel, String token) async {
    try {
      await init();
      final response = await http
          .post(
              Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_REPORTS),
              headers: getHeader(token),
              body: requestModel.toJson())
          .timeout(const Duration(minutes: 2));
      debugPrint(requestModel.toJson());
      debugPrint(response.statusCode);
      if (response.statusCode == 200) {
        // debugPrint(response.body);
        if (requestModel.ReportId ==
            LocalConstant.ACTION_REPORT_LEARNING_GOAL) {
          return GetReportResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        } else if (requestModel.ReportId ==
            LocalConstant.ACTION_REPORT_LOGBOOK) {
          return LogbookReportResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        }
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getElg(ElgRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_ELG),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      //debugPrint(response.body);
      debugPrint(response.request!.url);
      if (response.statusCode == 200) {
        return ElgResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getElgDetails(
      ElgDetailsRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_ELG_DETAILS),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      if (response.statusCode == 200) {
        return ElgDetailsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getArtsy(ArtsyRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_ARTSY),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return ArtsyResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getArtsyStudentList(
      GetParentCornerArtsyStudentListRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_ARTSY_STUDLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetParentCornerArtsyStudentListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getTracker(
      BasePentemindRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_TRACKER),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.getTrackerJson());
      debugPrint(response.request!.url);
      debugPrint(response.body);
      debugPrint(response.statusCode);
      if (response.statusCode == 200) {
        return TrackerResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getApprovalstatus(
      ApprovalRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_APPROVALSTATUS),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return ApprovalResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateApprovalStatus(
      ApprovedRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_APPROVED_STATUS),
          headers: getHeader(token),
          body: requestModel.toJson());
      // debugPrint(requestModel.toJson());
      // debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getParentTracker(
      BasePentemindRequest requestModel, String studentid, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_PARENT_TRACKER),
          headers: getHeader(token),
          body: requestModel.toTrackerJson(studentid));
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return ParentTrackerResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getStudentReports(
      BasePentemindRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_STUDENT_REPORT),
          headers: getHeader(token),
          body: requestModel.toReport());

      String responseBody = response.body;
      responseBody = responseBody.replaceAll('\\"', '"');
      responseBody = responseBody.replaceAll('"[', '[');
      responseBody = responseBody.replaceAll(']"}', ']}');
      debugPrint(responseBody);
      if (response.statusCode == 200) {
        return StudentReportResponse.fromJson(
          json.decode(responseBody) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode else null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
      return null;
    }
  }

  Future<dynamic> getMyHomework(
      BasePentemindRequest requestModel, String studentId, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_GET_PENTEMIND_STUDENT_HOMEWORK),
          headers: getHeader(token),
          body: requestModel.toHomeWork(studentId));
      debugPrint(requestModel.toHomeWork(studentId));
      debugPrint(response.request!.url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return MyHomeworkResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
      return null;
    }
  }

  Future<dynamic> getElgStudentListRequest(
      ELGStudRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_STUDENT_ELG_STUDLIST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return ELGStudResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateParentCorner(
      UpdateElgObservationRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_UPDATE_PARENT_CORNER),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        try {
          return ELGStudResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        } catch (e) {
          return GenericResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        }
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getParentArtsy(
      ArtsyRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_ARTSY_PARENT_CORNER),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return ELGStudResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> updateArtsy(
      UpdateArtsyRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_GET_PENTEMIND_UPDATE_PARENT_CORNER),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return ELGStudResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> addLeaveRequest(
      AddLeaveRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(
              pentemind_url + LocalStrings.API_INSERT_PENTEMIND_LEAVE_REQUEST),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
      return null;
    }
  }

  Future<dynamic> updateStudentProfile(
      UpdateStudentProfileRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              LocalStrings.API_INSERT_PENTEMIND_STUDENT_PROFILE),
          headers: getHeader(token),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> forgotPassword(ForgotPasswordRequest requestModel) async {
    try {
      await setAppUrl();
      debugPrint('forger password for $pentemind_url');
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_FORGET_PASSWORD),
          headers: getHeader(''),
          body: requestModel.toJson());
      // debugPrint(requestModel.toJson());
      // debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> resetPassword(ResetPasswordRequest requestModel) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_RESET_PASSWORD),
          headers: getHeader(''),
          body: requestModel.toJson());
      //debugPrint(requestModel.toJson());
      //debugPrint(response.request!.url);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getTaskDetails(GetTaskDetailsRequest requestModel) async {
    try {
      debugPrint(getHeader(''));
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_TASKDETAILS),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetTaskDetailsResponseModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<GetTaskDetailsResponseModel> getBPMSTaskDetails(
      GetTaskDetailsRequest requestModel) async {
    try {
      debugPrint(getHeader(''));
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_TASKDETAILS),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetTaskDetailsResponseModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return GetTaskDetailsResponseModel(success: 400, taskDetail: []);
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
      return GetTaskDetailsResponseModel(success: 401, taskDetail: []);
    }
  }

  Future<dynamic> updateTaskDetails(UpdateBpmsTaskRequest requestModel) async {
    try {
      debugPrint(getHeader(''));
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_UPDATE_TASKDETAILS),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return UpdateBpmsTaskResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
//       debugPrint('error e');
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getTaskComments(GetTaskCommentRequest requestModel) async {
    try {
      debugPrint(getHeader(''));
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_COMMENTS),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return GetCommentResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> insertTaskAttachment(
      InsertTaskAttachmentRequest requestModel) async {
    try {
      debugPrint(getHeader(''));
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_INSERT_ATTACHMENT),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return InsertTaskAttachmentResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
//       debugPrint('statusCode null error');
      debugPrint(e.toString());
      e.toString();
      return null;
    }
  }

  dynamic getFranDetailInfo(GetFranchiseeDetailsRequest requestModel) async {
    try {
//       debugPrint('getFranDetails ....');
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_FRANCHISEEDETAILS),
          headers: getHeader(''),
          body: requestModel.toJson());
//       debugPrint('resonse received.........');
//       debugPrint('Fran ${requestModel.toJson()}');
//       debugPrint('Fran ${response.request!.url}');
//       debugPrint('Fran ${response.statusCode}');
//       debugPrint('Fran ${response.body}');
      if (response.statusCode == 200) {
        return GetFranchiseeDetailsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return 500;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<dynamic> getFranDetails(
      GetFranchiseeDetailsRequest requestModel) async {
    try {
//       debugPrint('getFranDetails ....');
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_FRANCHISEEDETAILS),
          headers: getHeader(''),
          body: requestModel.toJson());
//       debugPrint('resonse received.........');
//       debugPrint('Fran ${requestModel.toJson()}');
//       debugPrint('Fran ${response.request!.url}');
//       debugPrint('Fran ${response.statusCode}');
//       debugPrint('Fran ${response.body}');
      if (response.statusCode == 200) {
        return GetFranchiseeDetailsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return 500;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  dynamic getCommunication(GetCommunicationRequest requestModel) async {
    try {
//       debugPrint('Header -- ${getHeader('')}');
      final response = await http.post(
          Uri.parse(bpms_url + LocalStrings.API_GET_COMMUNICATION),
          headers: getHeader(''),
          body: requestModel.toJson());
      debugPrint(requestModel.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.statusCode);
//       debugPrint('2914 response ${response.body}');
      if (response.statusCode == 200) {
        return GetCommunicationResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
    return null;
  }

  Future<dynamic> getDayCalendar(GetDayCalenderRequest requestModel) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url +
              (LocalConstant.isCognimind
                  ? LocalStrings.API_GET_DAY_CALENDAR_COGNIMIND
                  : LocalStrings.API_GET_DAY_CALENDAR)),
          headers: getHeader(''),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        debugPrint(requestModel.toJson());
        debugPrint(response.body);
        return DayCalenderResponse.fromJson(
          json.decode(response.body),
        );
      } else {
//         debugPrint('statusCode null');
        return 500;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  static Future<void> subscribeToTopicForWeb(String token, String topic) async {
    // debugPrint('Messaging token is - $token');
    if (kIsWeb) {
      /* Below code subscribes to topic for web as normal way does not works. */
      try {
        Future(
          () async {
            var prefs = await SharedPreferences.getInstance();
            String? offlineToken = prefs.getString(LocalConstant.KEY_FCM_TOKEN);
            /* https://7d7d75ce2c46.ngrok-free.app/subscribe?projectName=kidzee&topicname=kidzee&token=ePR0819hT_S00y2XLkHRT0:APA91bH_07X2_M5LsvsPa9NUVXikbbe-9UT2U7Y3VdEMqTdXL1Oe0ZaItsFQjrLCkDSLF7TywUkxpT5Va1lK9ZT8OEI0gGR0UVYZuQ4zlwmqLxoyIzkHjis */

            if (offlineToken == null || offlineToken.isEmpty) {
              return;
            }
            var response = await http.get(
              Uri.parse(
                  '${LocalStrings.bpms}api/subscription/subscribe?projectName=kidzee&topicname=$topic&token=$offlineToken'),
              headers: await getNormalHeaderStatic(),
            );

            // debugPrint(
            //     'Response from subscribe to topic api is Api Service - ${response.body} and status is - ${response.statusCode} ');
          },
        );
      } catch (e) {
        // debugPrint('Exception while subscribing for web - $e');
      }
    }
  }

  static Future<void> unsubscribeToTopicForWeb(String topic) async {
    var prefs = await SharedPreferences.getInstance();
    String? fcmToken = prefs.getString(LocalConstant.KEY_FCM_TOKEN);

    if (fcmToken != null && fcmToken.isNotEmpty) {
      /* Below code unsubscribes to topic for web as normal way does not works. */
      try {
        var response = await http.get(
          Uri.parse(
              '${LocalStrings.bpms}/api/subscription/unsubscribe?projectName=kidzee&topicname=$topic&token=$fcmToken'),
          headers: await getNormalHeaderStatic(),
        );
        // debugPrint(
        //     'Response from unsubscribe to topic api is - ${response.body} and status is - ${response.statusCode} ');
      } catch (e) {
        // debugPrint('Exception while subscribing for web - $e');
      }
    } else {
      // debugPrint('FcmToken is null');
    }
  }

//   Future<dynamic> updateFCM(UpdateFcmRequest requestModel) async {
//     try {
//       await init();
//       final apiUrl = WebOriginUrl.appEkidzeeApi(LocalStrings.API_UPDATE_FCM);
//       print('UpdateFCM → $apiUrl');
//       final response = await http.post(Uri.parse(apiUrl),
//           headers: kIsWeb ? loginHeader() : getNormalHeader1(),
//           body: requestModel.toJson());
//       print('UpdateFCM Status Code → ${response.statusCode}');
//       print(requestModel.toJson());
//       print('Repsonse body → ${response.body}');
//       if (response.statusCode == 200) {
//         return response.body;
//       } else {
// //         debugPrint('statusCode null');
//         return 500;
//       }
//     } catch (e) {
//       print('Exception while updating FCM - $e');
//       debugPrint(e.toString());
//       e.toString();
//     }
//   }

  Future<dynamic> updateFCM(UpdateFcmRequest requestModel) async {
    try {
      await init();

      final apiUrl = WebOriginUrl.appEkidzeeApi(LocalStrings.API_UPDATE_FCM);

      print('UpdateFCM → $apiUrl');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: kIsWeb ? loginHeader() : getNormalHeader1(),
        body: requestModel.toJson(),
      );

      print('UpdateFCM Status Code → ${response.statusCode}');
      print('Request → ${requestModel.toJson()}');
      print('Response body → ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 500;
      }
    } catch (e, stackTrace) {
      print('Exception while updating FCM - $e');
      debugPrint(stackTrace.toString());

      return 500;
    }
  }

  Future<dynamic> getCelibrationEvents(CelibrationRequest requestModel) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(pentemind_url + LocalStrings.API_GET_CELIBRATION),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      debugPrint(pentemind_url + LocalStrings.API_GET_CELIBRATION);
      // debugPrint(requestModel.toJson());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        //return response.body;
        return ZllResourceResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        return 500;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<TrackerIndent> getTrackerIndent(TrackerRequest trackerRequest) async {
    try {
      debugPrint('Request for tracker indent api is - $trackerRequest');
      final response = await http.post(
          Uri.parse(
              WebOriginUrl.appEkidzeeApi(LocalStrings.API_GET_TRACKERINDENT)),
          headers: getNormalHeader1(),
          body: trackerRequest.toJson());

      debugPrint('Response from Logistic Tracker api is - ${response.body}');

      if (response.statusCode == 200) {
        return TrackerIndent.fromJson(
          json.decode(response.body),
        );
      } else {
        return TrackerIndent.setErrorMessage(
            jsonDecode(response.body)['Message']);
      }
    } catch (e) {
      return TrackerIndent.setErrorMessage(e.toString());
    }
  }

  Future<Indents> getIndentDetails(String indentNo) async {
    try {
      debugPrint('Request for tracker indent api is - $indentNo');
      final response = await http.post(
          Uri.parse(WebOriginUrl.appEkidzeeApi(
              LocalStrings.API_GET_TRACKERINDENTDTLS)),
          headers: getNormalHeader1(),
          body: jsonEncode({"IndentNo": indentNo}));

      debugPrint('Response from Logistic Tracker api is - ${response.body}');

      if (response.statusCode == 200) {
        return Indents.fromJson(
          json.decode(response.body)['root']['subroot'],
        );
      } else {
        return Indents.setErrorMessage(jsonDecode(response.body)['Message']);
      }
    } catch (e) {
      return Indents.setErrorMessage(e.toString());
    }
  }

  Map<String, String> getHeader(token) {
    return {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $token',
      'dbid': '1',
      'User-Agent': userAgent,
      'platform': platform,
      'source': kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'Android'
              : Platform.isIOS
                  ? 'IOS'
                  : 'unknown',
    };
  }

  Map<String, String> getNormalHeader() {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      // Required for CORS support to work
      "Access-Control-Allow-Credentials": "true",
      // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST,GET, OPTIONS",
      'User-Agent': userAgent,
      'platform': platform,
      'source': kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'Android'
              : Platform.isIOS
                  ? 'IOS'
                  : 'unknown',
    };
    return headers;
    /*{
      "Accept": "application/json",
      "Content-Type": "application/json",
      'source': Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown',
    };*/
  }

  Map<String, String> loginHeader() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST,GET, OPTIONS",
      'User-Agent': userAgent,
      'platform': platform,
      'source': kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'Android'
              : Platform.isIOS
                  ? 'IOS'
                  : 'unknown',
    };
    return headers;
    /*{
      "Accept": "application/json",
      "Content-Type": "application/json",
      'source': Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOS' : 'unknown',
    };*/
  }

  Future<GetNotificationResponse> getKesNotification(
      KesSimpleRequest requestModel, String token) async {
    try {
      await init();
      //debugPrint(Uri.parse(pentemind_url + LocalStrings.API_GET_PENTEMIND_MYCLASS_GET_ANNOUCEMENT));
      final response = await http.post(
          Uri.parse('${kes_url}api/LMS/GetNotification'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());

//       debugPrint('body ${requestModel.toJson()}');
//       debugPrint('body ${response.request?.url}');
      //debugPrint('headers ${response.request?.headers.toString()}');
      //debugPrint('status as code ${response.statusCode}');
//       debugPrint('response  ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GetNotificationResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return GetNotificationResponse(data: [], success: 400);
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
      return GetNotificationResponse(data: [], success: 400);
    }
  }

  Future<dynamic> addKESNewAnNotification(
      AddKesNotification requestModel, String token) async {
    try {
      await init();

      debugPrint(requestModel.toJson());
      final response = await http.post(
          Uri.parse('${kes_url}api/LMS/AddNotification'),
          headers: getNormalHeader1(),
          body: requestModel.toJson());
      debugPrint(
          '${response.body}Request is - ${requestModel.toJson()}Url is - ${'${kes_url}api/LMS/AddNotification'}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GeneralResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      e.toString();
    }
  }

  Future<leaveRecordKes.KESLeaveResponse?> getKESLeaveRecords(
      LeaveRecordRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(LocalStrings.API_GET_KES_LEAVERECORD),
          headers: getNormalHeader1(),
          body: requestModel.toKESJson());
//       debugPrint('get getKESLeaveRecords request ${requestModel.toKESJson()}');
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        try {
          return leaveRecordKes.KESLeaveResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>,
          );
        } catch (e) {
          debugPrint('ERror is - ${e.toString()}');
          return leaveRecordKes.KESLeaveResponse(success: 200, data: []);
        }
      } else {
        return null;
      }
    } catch (e) {
      e.toString();
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> updateKESLeaveRecord(
      LeaveApproveRequest requestModel, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(LocalStrings.API_UPDATE_KES_LEAVERECORD),
          headers: getNormalHeader1(),
          body: requestModel.toKESJson());
      log('Response from update leave record api is - ${response.body}');
      log(requestModel.toKESJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return GenericResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      e.toString();
      log(e.toString());
    }
  }

  Future<dynamic> addKESLeaveRequest(
      addLeaveRequestKes.KESLeaveRequest request, String token) async {
    try {
      await init();
      final response = await http.post(
          Uri.parse(LocalStrings.API_INSERT_KES_LEAVE_REQUEST),
          headers: getNormalHeader1(),
          body: request.toJson());
      debugPrint(request.toJson());
      debugPrint(response.request!.url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return AddLeaveResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
//         debugPrint('statusCode null');
        return null;
      }
    } catch (e) {
      log(e.toString());
      e.toString();
      return null;
    }
  }
}
