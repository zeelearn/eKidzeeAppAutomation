import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocalConstant {
  static const kDefaultSpacing = 20.0;
  static bool isCognimind = true;

  static const String KidzeeDB = "kidzeepref";

  // static const String pentemindcelebrationBaseUrl =
  //     "https://print.pentemind.com/Celebration/";
  // static const String pentemindBaseUrlStudentReportList =
  //     "https://print.pentemind.com/studentreportList/";

  static const String DEF_AVTAR =
      'https://cdn-icons-png.flaticon.com/128/847/847969.png';

  static const String NOTIFICATION_CHANNEL_MLZS = 'mlzs';
  static const String NOTIFICATION_CHANNEL_KIDZEE = 'Kidzee';

  static const String URL_PRINT_PENTEMIND =
      'https://printpentemind.kidzee.com/' /* 'https://printpentemind.com/' */;

  /* Notification status keyword */
  static const String KEY_SHOWNOTIFICATION_COUNT = 'showNotification';
  static const String KEY_NOTIFICATION_COUNT = 'NotificationCount';
  static const String KEY_DEEPLINK_URL = 'DeeplinkUrl';

  static const String KEY_BASE_URL = "baseurl";
  static const String KEY_ISLOGGEDIN = "islogin";
  static const String KEY_APP_TOKEN = "token";
  static const String KEY_LAST_LOGIN = "lastlogin";
  static const String KEY_FCM_TOKEN = "fcmtoken";
  static const String KEY_CLASS_LIST = "classlist";
  static const String KEY_CURRENT_PROGRAM_ID = "currprogramid";
  static const String KEY_CURRENT_CLASS_ID = "currclassid";
  static const String KEY_CURRENT_CLASS_NAME = "currclassname";
  static const String KEY_CURRENT_TERM = "currterm";
  static const String KEY_CURRENT_PROGRAM_NAME = "programname";
  static const String KEY_CURRENT_CURRICULAMTYPE = "curriculamType";
  static const String KEY_CURRENT_USERROLE = "userrole";
  static const String KEY_IS_TOPIC_SUB = "istopcsub";
  static const String KEY_IS_OTP_VERIFIED = "isotpverified";
  static const String KEY_IS_CENTER_SETUP = "iscentersetup";
  static const String KEY_USER_NAME = "uname";
  static const String KEY_USER_PASSWORD = "password";
  static const String KEY_USER_ID = "userid";
  static const String KEY_IS_TOPIC_SUBSCRIBE = "topic_sub";
  static const String KEY_UID = "uid";
  static const String KEY_STUDENT_ID = "studid";
  static const String KEY_STUDENT_NAME = "studentname";
  static const String KEY_EMAILID = "emailid";
  static const String KEY_ZONE = "zone";
  static const String KEY_USER_AVTAR = "avtar";
  static const String KEY_GUARDIAN_CONTACT = "guardianContact";
  static const String KEY_USER_TYPE = "usertype";
  static const String KEY_USER_TYPE_NAME = "usertype_name";
  static const String KEY_ACADEMICYEAR = "acyer";
  static const String KEY_SEL_ACADEMIC_YEAR = "sel_acyr";
  static const String KEY_BRANCH_NAME = "branchname";
  static const String KEY_FRANCHISEE_ID = "franchiseeid";
  static const String KEY_FRANCHISEE_TYPE = "franchiseetype";
  static const String KEY_DISPLAY_NAME = "dname";
  static const String KEY_COUNTRY_NAME = "country";
  static const String KEY_MOBILENO = "mobileno";
  static const String KEY_TIRETYPE = "TierType";
  static const String KEY_TIRENAME = "TierNAME";
  static const String KEY_REMARK = "remark";
  static const String KEY_CONE_CODE = "zone_code";
  static const String KEY_STATE_ID = "state_id";
  static const String KEY_IS_EXTERNAL_USER = "external_user";
  static const String KEY_IS_ILLUM_KIT = "illumkit";
  static const String KEY_IS_KG_KIT = "kgkit";
  static const String KEY_PENTEMIND_URL = "pentemindurl";
  static const String KEY_SYNC_INTERVAL = "syncinterval";
  static const String KEY_BUSINESS_ID = "businessid";

  static const String KEY_AUTH_TOKEN = "authtoken";
  static const String KEY_MODEL_DAY = "daymodel";
  static const String KEY_CRNNO = "crnno";
  static const String KEY_IS_KES = "iskes";

/* Notification Constant for logbook */
  static const String KEY_SCHEDULE_NOTIFICATION = "scheduleNotification";
  static const int LOGBOOK_NOTIFICATION_ID = 121;
  static const int LEARNINGOAL_NOTIFICATION_ID_1 = 121121;
  static const int LEARNINGOAL_NOTIFICATION_ID_2 = 121131;
  static const int FINAL_NOTIFICATION_ID = 1234321;

  static const kPrimaryColor = Color(0xFFE57373);
  static const kBackgroundColor = Color(0xFFFFCDD2);
  static const kTopBackgroundColor = Color(0XFFFCE4EC);

  static const FB_ACTIVITY_PLANNER = "tActivity";
  static const FB_ACTIVITY_RHYMES = "klt_db";
  static const ACTION_PENTEMIND_MODULE = 121212;
  static const ACTION_PENTEMIND_CLASS_SELECTION = 9999;
  static const ACTION_FILE_UPLOAD = 9998;
  static const int ACTION_RESPONSE = 9997;

  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = const Color(0xff5563ff);
  static Color darkAccent = const Color(0xff5563ff);
  static Color lightBG = const Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color? ratingBG = Colors.yellow[600];

  static String TABLE_NOTIFICATION = "notification";
  static String TABLE_PARENT_INFO = "parent_info";
  static String TABLE_DATA_SYNC = "data_sync";

  static int MENU_MYCALSS_ANNOUNANCEMENT = 1001;
  static int MENU_MYCLASS_PARENT_NOTE = 1002;
  static int MENU_MYCLASS_LEAVE_RECORD = 1003;
  static int MENU_LG_CHILD_ADVANCEMENT = 1004;
  static int MENU_LG_WWW = 1005;
  static int MENU_LG_EVEN_BETTER_IF = 1006;
  static int MENU_LG_CHILD_INFORMATION = 1007;
  static int MENU_LG_FACILATOR_SAYS = 1008;
  static int MENU_LG_HELTHHYGINE = 1009;
  static int MENU_LG_DEVELOPMENTAL_STUDLIST = 1010;
  static int MENU_LG_ACEDEMIC = 1011;
  static int MENU_LG_ACEDEMIC_STUDINFO = 1012;
  static int MENU_LOGBOOK = 1013;
  static int MENU_LESSONPLAN = 1014;
  static int MENU_GUIDELINE = 1015;
  static int MENU_DAILY_ACTIVITY = 1016;
  static int MENU_DAILY_ACTIVITY_UPDATE = 1017;
  static int MENU_DAILY_HOMEWORK = 1018;
  static int MENU_MYCLASS_PARENTNOTE = 1019;
  static int MENU_REPORTS = 1020;
  static int MENU_ELG = 1021;
  static int MENU_PARENT_ELG = 1028;
  static int MENU_ARTSY = 1022;
  static int MENU_ARTSY_DETAILS = 1023;
  static int MENU_MYCLASS_APPROVALS = 1024;
  static int MENU_PARENT_ALMANAC = 1025;
  static int MENU_PARENT_PENTEMIND_PROCESS = 1026;
  static int MENU_PARENT_PENTEMIND_PROCESS_TRACKER = 1027;
  static int MENU_PARENT_PENTEMIND_ACTIVITY = 1029;
  static int MENU_PARENT_PENTEMIND_FUN_ACTIVITY = 1030;
  static int MENU_PARENT_PENTEMIND_INTROVIDEOS = 1031;
  static int MENU_PARENT_SUPPORT_DESK = 1032;
  static int MENU_ZLLSARTHI = 1033;
  static int MENU_TRACKER = 1033;
  static int ACTION_DROPDOWN = 1;
  static int ACTION_OPENCLASSDETAILS = 100001;

  static int ACTION_REPORT_LEARNING_GOAL = 4;
  static int ACTION_REPORT_LOGBOOK = 3;
  static int MENU_LEARNING_GOAL_NEPAL = 1034;

  static String MODULE_FACILATORTOOL = 'facilatortool';
  static String MODULE_DAILYACTIVITY = 'dailyactivity';
  static String MODULE_LEARNING_MATERIAL = 'learningmaterials';
  static String MODULE_LEARNING_MATERIAL_NEPAL = 'learningmaterialsnepal';
  static String MODULE_REPORTS = 'reports';
  static String MODULE_PARENT_CORNER = 'parentscorner';
  static String MODULE_PARENT_TRACKER = 'Tracker';
  static String MODULE_PARENT_PARENT_PENTEMIND_PROCESS = 'PéNTEMiND Progress';
  static String MODULE_PARENT_PARENT_HOMEWORK = 'Homework';
  static String MODULE_PARENT_PARENT_ELG = 'ELG';
  static String MODULE_PARENT_PARENT_ARTSY = 'ARTSY';
  static String MODULE_CHAT_WITHUS = 'Chat With Us';
  static String MODULE_PARENT_SUPPORT_DESK = 'Parent Support Desk';
  static String MODULE_CELIBRATION_DAY = 'ZLL Celebrations';
  static String MODULE_PARENT_SAMYUJ = 'PARENT SAMYUJ';
  static String MODULE_ZLLSARTHI = 'ZLLSaathi';
  static String MODULE_K12_LG = 'Assessment';
  static String MODULE_K12_MYCLASS = 'My Class';
  static String MODULE_NEPAL_LEARNING_RESOURCE = 'Nepal Resources';

  static String MODULE_K12_ALMANAC_TOOL = 'P Almanac';
  static String MODULE_K12_HOMELINK_TOOL = 'Home Link';
  static String MODULE_K12_HPCREPORT_TOOL = 'HPC Report';
  static String MODULE_K12_FACILATOR_TOOL = 'Facilator Tool';
  static String MODULE_K12_HOMEWORK_TOOL = 'Homework';
  static String MODULE_K12_LEARNINGRESOURCE_TOOL = 'Learning Resource';
  static String MODULE_LITERANOVA_OCTAVE = 'Learning Pathways';

  static String MODULE_K12_REPORTS = 'Reports';
  static String MODULE_K12_LOGBOOK = 'Logbook';
  static String MODULE_PARENT_ALMANAC = 'Almanac';
  static String MODULE_STUDENT_PROFILE = 'Student Profile';
  static String MODULE_STUDENT_REPORT = 'Student Report';
  static String MODULE_PENTEMIND_ACTIVITY = 'PéNTEMiND Activities';
  static String MODULE_PENTEMIND_FUN_ACTIVITY = 'Fun Activities';
  static String MODULE_PENTEMIND_TRACKER_INDENT = 'Tracker Indent';

  static String TERM_EARLY = 'EARLY';

  static String ACTION_ATTANDANCE = 'attandance';
  static String ACTION_CULMINATION = 'cul';
  static String ACTION_OFFLINE_DEVELOPMENTAL = 'developmental';
  static String ACTION_IMAGE_UPLOAD_PARENTARTSY = 'img_up_partsy';
  static String ACTION_IMAGE_UPLOAD_PARENT_HOMEWORD = 'img_up_parent_hw';
  static String ACTION_IMAGE_UPLOAD_CHILD_ADV = 'img_up_child_adv';
  static String ACTION_BG_ACADEMIC = 'academic';
  static String ACTION_LOGBOOK = 'logbook';
  static String BACKGROUND_FILE_UPLOAD = 'upload';
  static String NO_INTERNET = 'Please check internet connection';
  static String LBL_DEVELOPMENT_REQUEST_SEND =
      'We received your request and process it once Internet connection established..';
  static String LBL_REQUEST_SEND =
      'Application Received the request, we process it in background and will update soon';
  static String LBL_REQUEST_RECEIVED = 'Update!';
  static String ACTION_BACKGROUND_FILE_UPLOAD = 'File Upload';

  static const String ACTION_PDF = 'pdf';
  static const String ACTION_GALLERY = 'Gallery';
  static const String ACTION_CAMERA = 'Camera';
  static const String ACTION_UPDATE_STATUS = 'Update Status';
  static const int ACTION_USER_EVENT = 100;

  // storage keys
  static const authStorageKey = 'auth';
  static const base = 'base';
  static const communicationKey = 'commu';
  static const KesKey = 'kes';
  static const taskKey = 'task';
  static const indent = 'indent';
  static const logbookStatus = 'logbookStatus';
  static const surveyBox = 'survey';
  static const offlineMaterials = 'offlineMaterials';

  static const LOGBOOK_STATUS = 'Logbook';
  static const ATTENDANCE_STATUS = 'Attendance';
  static const ATTENDANCE_DATE = 'Attendance_date';
  static const LOGBOOK_DATE = 'Logbook_date';
  static const ATTENDANCE_LOGBOOK_PROGRAMID = 'Attendance_logbook_programid';

  static final DateFormat formatter =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.sss'Z'");

  static const String LBL_CONFIRMATION = 'Confirmation';
  static const String LBL_UPDATE_ACTIVITY =
      'Are you sure you want to assign the activity? ';
  static const String LBL_UPDATE_LEAVE =
      'Are you sure you want to confirm the Leave Status? ';

  static const String ISREMEMBER = 'isremember';
}
