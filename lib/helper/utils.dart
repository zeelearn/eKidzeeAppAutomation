import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/pages/home/pentemindhome.dart';
import 'package:file_picker/file_picker.dart'
    show FilePicker, FilePickerResult, FileType;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:literaoctave/octive_config.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/response/pentemind/learninggoals/uploadimage.dart';
import '../app_routes.dart';
import '../constants.dart';
import '../iface/onClick.dart';
import '../iface/onDownload.dart';
import '../pages/bpms/bpms_db.dart';
import '../pages/k12/core/utils.dart';
import '../pages/notification/NotificationService.dart';
import '../utils/theme/colors/light_colors.dart';
import '../widget/image_viewer.dart';
import 'KidzeePref.dart';
import 'LightColor.dart';
import 'LocalConstant.dart';

enum TaskPageStatus {
  all,
  completed,
  active,
  details,
}

class Utility {
  static int ACTION_OK = 100012;
  static int ACTION_CONFIRM = 100018;
  static int ACTION_ALERT_OK = 100019;
  static int ACTION_REJECT = 100014;
  static int ACTION_CANCEL = 100013;
  static int ACTION_IMAGE_UPLOAD_RESPONSE_OK = 100015;
  static int ACTION_IMAGE_UPLOAD_RESPONSE_ERROR = 100016;
  static int ACTION_OBSERVATION = 100017;
  static int ACTION_CULMINATION = 100020;
  static int ACTION_CULMINATION_WEEK = 100021;

  static bool isDialogVisible = false;
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    try {
      final SendPort? send =
          IsolateNameServer.lookupPortByName('downloader_send_port');
      send?.send([id, status, progress]);
    } catch (e) {
      // debugPrint(e);
    }
  }

  static Future<bool> isInternet() async {
    bool isConnected = true;
    try {
      if (kIsWeb) {
        return true;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static int toInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      e.toString();
    }
    return 0;
  }

  static void noInternetConnection(BuildContext context) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: 'Internet connection not available please check and try again later',
      title: 'Connectivity Error',
      lottieBuilder: Lottie.asset(
        'assets/json/no_internet_connection.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context).pop();
            });
          },
          text: 'OK',
          iconData: Icons.done,
          color: LightColors.kRed,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  // static Future<String> getDeviceIdentifier() async {
  //   String? deviceIdentifier = "unknown";
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     //debugPrint("Android device Info");
  //     if(androidInfo==null){
  //       //debugPrint("----NULL");
  //     }
  //     //debugPrint("Android device Info ${androidInfo.androidId}");
  //     deviceIdentifier = androidInfo.androidId;
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     deviceIdentifier = iosInfo.identifierForVendor;
  //   } else if (kIsWeb) {
  //     // The web doesnt have a device UID, so use a combination fingerprint as an example
  //     WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
  //     String? userAgent = webInfo.userAgent;
  //     deviceIdentifier = "${webInfo.vendor} ${userAgent as String}";
  //   } else if (Platform.isLinux) {
  //     LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
  //     deviceIdentifier = linuxInfo.machineId;
  //   }
  //   return deviceIdentifier as String;
  // }

  static SizedBox emptyDataSet(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Lottie.asset('assets/json/ic_empty_box.json', height: 200),
          const Text(
            "No Data Found",
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  static Container emptyData(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /*Image.asset(
            'assets/images/ic_empty_box.png',
            height: 200.0,
          ),*/
          Lottie.asset('assets/json/not_found.json', height: 200),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: LightColor.black,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  static Padding noInternet(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset('assets/json/nointernet.json', height: 150),
            Center(
              child: Text(
                'You are currently not connected to the internet. Please check your network connection and try again.',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: LightColor.black,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }

  static Widget heroFlightBuilder(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: Tween(begin: 0.98, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.bounceIn,
          ),
        ),
        child: toContext.widget,
      ),
    );
  }

  static int getCrossAxisCountHomework(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 3;
    return 2;
  }

  static Container filter(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /*Image.asset(
            'assets/images/ic_empty_box.png',
            height: 200.0,
          ),*/
          Lottie.asset('assets/json/filterjson.json', height: 200),
          Center(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: LightColor.black,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  static Container underDevelopment(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Lottie.asset('assets/json/under_development.json'),
          Center(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: LightColor.black,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  static Future<void> showSyncIntervalDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int currentSelection = prefs.containsKey(LocalConstant.KEY_SYNC_INTERVAL)
        ? prefs.getInt(LocalConstant.KEY_SYNC_INTERVAL) as int
        : 4;
    if (!context.mounted) return;
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          bool isSwitched =
              prefs.getBool(LocalConstant.KEY_SCHEDULE_NOTIFICATION) ?? false;
          var textValue = 'Schedule Notification ';

          return StatefulBuilder(
            builder: (context, setinnerState) => AlertDialog(
              title: const Text("Select Sync Interval"),
              content: SizedBox(
                width: 300.0,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 11,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                              color: currentSelection == index
                                  ? Colors.white54
                                  : Colors.white,
                              child: GestureDetector(
                                onTap: () {
                                  prefs.setInt(
                                      LocalConstant.KEY_SYNC_INTERVAL, index);
                                  // debugPrint(index);
                                  Navigator.pop(context);
                                },
                                child: ListTile(
                                  title: Text('$index Hour'),
                                ),
                              ));
                        },
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        textValue,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Switch(
                        onChanged: (value) async {
                          if (!isSwitched) {
                            await prefs.setBool(
                                LocalConstant.KEY_SCHEDULE_NOTIFICATION, false);
                            setinnerState(() {
                              isSwitched = true;
                              // textValue = 'Switch Button is ON';
                            });
//                             debugPrint('Switch Button is ON');
                          } else {
                            await prefs.setBool(
                                LocalConstant.KEY_SCHEDULE_NOTIFICATION, false);
                            setinnerState(() {
                              isSwitched = false;
                              // textValue = 'Switch Button is OFF';
                            });
//                             debugPrint('Switch Button is OFF');
                          }
                        },
                        value: isSwitched,
                        activeThumbColor: kPrimaryLightColor,
                        activeTrackColor: kPrimaryLightColor,
                        inactiveThumbColor: Colors.grey.shade400,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ])
                  ],
                ),
              ),
            ),
          );
        });
  }

  static int getCrossAxisCount(double width) {
    if (width >= 1600) return 6; // Large Desktop
    if (width >= 1200) return 5; // Desktop
    if (width >= 800) return 3; // Tablet
    if (width >= 500) return 2; // Large Mobile
    return 1; // Small Mobile
  }

  static SliverGridDelegateWithFixedCrossAxisCount getGridViewStyle() {
    return kIsWeb
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(Get.width),
            childAspectRatio: 3 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          )
        : SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
          );
  }

  static SliverGridDelegateWithFixedCrossAxisCount getCalenderGridViewStyle(
      BuildContext context) {
    return Responsive.isDesktop(context) || Responsive.isTablet(context)
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 2,
          )
        : Responsive.isTablet(context)
            ? SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2,
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              );
  }

  static SliverGridDelegateWithFixedCrossAxisCount getResponsiveGridViewStyle(
      BuildContext context) {
    return Responsive.isDesktop(context)
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            // Set the aspect ratio of each card.
            childAspectRatio: 6 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            /*crossAxisCount: 2,
                        childAspectRatio: 2,*/
          )
        : Responsive.isTablet(context)
            ? SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // Set the aspect ratio of each card.
                childAspectRatio: 5 / 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                /*crossAxisCount: 2,
                        childAspectRatio: 2,*/
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5 / 1,
              );
  }

  static SliverGridDelegateWithFixedCrossAxisCount
      getResponsiveFilterGridViewStyle(BuildContext context) {
    return Responsive.isDesktop(context)
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            // Set the aspect ratio of each card.
            childAspectRatio: 6 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            /*crossAxisCount: 2,
                        childAspectRatio: 2,*/
          )
        : Responsive.isTablet(context)
            ? SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // Set the aspect ratio of each card.
                childAspectRatio: 7 / 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                /*crossAxisCount: 2,
                        childAspectRatio: 2,*/
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                childAspectRatio:
                    4.0, // Adjust the aspect ratio if needed````````
              );
  }

  static String resolveDynamicUserPlaceholders(
    String rawUrl, {
    required String userId,
    required String uid,
    required String displayName,
    required String userName,
  }) {
    if (rawUrl.trim().isEmpty) {
      return rawUrl;
    }

    final normalizedUserId = userId.trim();
    final normalizedUid = uid.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedUserName = userName.trim();

    final replacements = {
      'userid': Uri.encodeComponent(normalizedUserId),
      'uid': Uri.encodeComponent(normalizedUid),
      'displayname': Uri.encodeComponent(normalizedDisplayName),
      'username': Uri.encodeComponent(normalizedUserName),
    };

    return rawUrl.replaceAllMapped(
      RegExp(r'<\s*(userid|uid|displayname|username)\s*>',
          caseSensitive: false),
      (match) {
        final key = (match.group(1) ?? '').toLowerCase();
        return replacements[key] ?? match.group(0)!;
      },
    );
  }

  /// Resolves `<uid>`, `<userid>`, `<displayname>`, `<username>` using
  /// the current logged-in session (login cache + SharedPreferences).
  static Future<String> resolveUserPlaceholdersFromSession(
      String rawUrl) async {
    if (rawUrl.trim().isEmpty) {
      return rawUrl;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginData = await KidzeePref().getLoginResponse();

      final userId = (loginData?.userId ??
              prefs.getString(LocalConstant.KEY_USER_ID) ??
              '')
          .trim();
      final uid =
          (loginData?.uid ?? prefs.getString(LocalConstant.KEY_UID) ?? '')
              .trim();
      final displayName = (loginData?.displayName ??
              prefs.getString(LocalConstant.KEY_DISPLAY_NAME) ??
              '')
          .trim();
      final userName = (loginData?.userName ??
              prefs.getString(LocalConstant.KEY_USER_NAME) ??
              '')
          .trim();

      return resolveDynamicUserPlaceholders(
        rawUrl,
        userId: userId,
        uid: uid,
        displayName: displayName,
        userName: userName,
      );
    } catch (_) {
      return rawUrl;
    }
  }

  /// Resolves dynamic user placeholders across common notification payload keys.
  static Future<Map<String, String?>> resolveNotificationPayloadPlaceholders(
    Map<String, String?>? payload,
  ) async {
    if (payload == null || payload.isEmpty) {
      return payload ?? <String, String?>{};
    }

    final resolved = Map<String, String?>.from(payload);
    const keysToResolve = {
      'url',
      'actionUrl',
      'webViewLink',
      'id',
      'imageurl',
      'bigimage',
    };

    for (final key in keysToResolve) {
      final value = resolved[key];
      if (value != null && value.contains('<')) {
        resolved[key] = await resolveUserPlaceholdersFromSession(value);
      }
    }
    return resolved;
  }

  static Future<void> launchURL(url) async {
    final resolvedUrl = url is Uri
        ? Utility.resolveDynamicUserPlaceholders(
            url.toString(),
            userId: '',
            uid: '',
            displayName: '',
            userName: '',
          )
        : Utility.resolveDynamicUserPlaceholders(
            url.toString(),
            userId: '',
            uid: '',
            displayName: '',
            userName: '',
          );
    debugPrint(resolvedUrl);
    if (await canLaunch(resolvedUrl)) {
      await launch(resolvedUrl);
    } else {
      throw 'Could not launch $resolvedUrl';
    }
  }

  static SliverGridDelegateWithFixedCrossAxisCount getGridViewStyle8() {
    return kIsWeb
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kIsWeb ? 8 : 2,
            // Set the aspect ratio of each card.
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            /*crossAxisCount: 2,
                        childAspectRatio: 2,*/
          )
        : SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
          );
  }

  static void showKESDialog(BuildContext context, String title,
      String description, onClickListener response) {
    Dialogs.materialDialog(
      context: context,
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/kes_done.json',
        fit: BoxFit.contain,
      ),
      actionsBuilder: (context) {
        return [
          IconsButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 50)).then((_) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                response.onClick(ACTION_OK, 'SUCCESS');
              });
            },
            text: 'OK',
            iconData: Icons.done,
            color: kPrimaryLightColor,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          )
        ];
      },
    );
  }

  static void getConfirmationMyClassDialog(BuildContext context, String title,
      String description, onClickListener response,
      [onClickListener? listener, String? logbookday, String? programId]) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/kes_done.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      barrierDismissible: false,
      actions: [
        listener != null
            ? Row(
                children: [
                  Expanded(
                    child: IconsButton(
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 50))
                            .then((_) {
                          // Navigator.of(context, rootNavigator: true)
                          //     .pop('dialog');
                          response.onClick(ACTION_OK, 'SUCCESS');
                        });
                      },
                      text: 'OK',
                      iconData: Icons.done,
                      color: kPrimaryLightColor,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  logbookday!.isEmpty
                      ? SizedBox(
                          width: 0,
                        )
                      : Expanded(
                          child: IconsButton(
                            onPressed: () {
                              Future.delayed(const Duration(milliseconds: 50))
                                  .then((_) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                listener.onClick(
                                    LocalConstant.ACTION_PENTEMIND_MODULE,
                                    PentemindItem(
                                        3,
                                        'Facilitator Tools',
                                        LocalConstant.MODULE_FACILATORTOOL,
                                        'assets/icons/ic_facilitatortools.png',
                                        logbookDay: logbookday,
                                        logbookProgramId: programId));
                              });
                            },
                            text: 'Open Logbook',
                            iconData: Icons.open_in_new,
                            color: Colors.blue,
                            textStyle: const TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ),
                ],
              )
            : IconsButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 50)).then((_) {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    response.onClick(ACTION_OK, 'SUCCESS');
                  });
                },
                text: 'OK',
                iconData: Icons.done,
                color: kPrimaryLightColor,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              )
      ],
    );
  }

  static void getConfirmationDialog(BuildContext context, String title,
      String description, onClickListener response,
      [onClickListener? listener, String? logbookday, String? programId]) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/kes_done.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      barrierDismissible: false,
      actions: [
        listener != null
            ? Row(
                children: [
                  Expanded(
                    child: IconsButton(
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 50))
                            .then((_) {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          response.onClick(ACTION_OK, 'SUCCESS');
                        });
                      },
                      text: 'OK',
                      iconData: Icons.done,
                      color: kPrimaryLightColor,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  logbookday!.isEmpty
                      ? SizedBox(
                          width: 0,
                        )
                      : Expanded(
                          child: IconsButton(
                            onPressed: () {
                              Future.delayed(const Duration(milliseconds: 50))
                                  .then((_) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                listener.onClick(
                                    LocalConstant.ACTION_PENTEMIND_MODULE,
                                    PentemindItem(
                                        3,
                                        'Facilitator Tools',
                                        LocalConstant.MODULE_FACILATORTOOL,
                                        'assets/icons/ic_facilitatortools.png',
                                        logbookDay: logbookday,
                                        logbookProgramId: programId));
                              });
                            },
                            text: 'Open Logbook',
                            iconData: Icons.open_in_new,
                            color: Colors.blue,
                            textStyle: const TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ),
                ],
              )
            : IconsButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 50)).then((_) {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    response.onClick(ACTION_OK, 'SUCCESS');
                  });
                },
                text: 'OK',
                iconData: Icons.done,
                color: kPrimaryLightColor,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              )
      ],
    );
  }

  static void getConfirmation(BuildContext context, String title,
      String description, onClickListener response) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      titleStyle: GoogleFonts.roboto(
        fontSize: 16.0,
        height: 1,
      ),
      lottieBuilder: Lottie.asset(
        'assets/json/85594-done.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response.onClick(ACTION_OK, 'SUCCESS');
            });
          },
          text: 'Cancel',
          iconData: Icons.cancel,
          color: LightColors.kRed,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response.onClick(ACTION_CONFIRM, 'SUCCESS');
            });
          },
          text: 'Confirm',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  // static getConfirmation(BuildContext context, String title, String description,
  //     onClickListener response) {
  //   Dialogs.materialDialog(
  //     color: Colors.white,
  //     msg: description,
  //     title: title,
  //     titleStyle: GoogleFonts.roboto(
  //       fontSize: 16.0,
  //       height: 1,
  //     ),
  //     lottieBuilder: Lottie.asset(
  //       'assets/json/85594-done.json',
  //       fit: BoxFit.contain,
  //     ),
  //     dialogWidth: kIsWeb ? 0.3 : null,
  //     context: context,
  //     actions: [
  //       IconsButton(
  //         onPressed: () {
  //           Future.delayed(const Duration(milliseconds: 50)).then((_) {
  //             Navigator.of(context, rootNavigator: true).pop('dialog');
  //             response.onClick(ACTION_OK, 'SUCCESS');
  //           });
  //         },
  //         text: 'Cancel',
  //         iconData: Icons.cancel,
  //         color: LightColors.kRed,
  //         textStyle: const TextStyle(color: Colors.white),
  //         iconColor: Colors.white,
  //       ),
  //       IconsButton(
  //         onPressed: () {
  //           Future.delayed(const Duration(milliseconds: 50)).then((_) {
  //             Navigator.of(context, rootNavigator: true).pop('dialog');
  //             response.onClick(ACTION_CONFIRM, 'SUCCESS');
  //           });
  //         },
  //         text: 'Confirm',
  //         iconData: Icons.done,
  //         color: Colors.blue,
  //         textStyle: const TextStyle(color: Colors.white),
  //         iconColor: Colors.white,
  //       ),
  //     ],
  //   );
  // }

  static void smsSendMessage(BuildContext context, String title,
      String description, onClickListener response) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/reset-password.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response.onClick(ACTION_OK, 'SUCCESS');
            });
          },
          text: 'OK',
          iconData: Icons.done,
          color: kPrimaryLightColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  static void confirm(BuildContext context, String title, String description,
      onClickListener response) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/85594-done.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response.onClick(ACTION_CONFIRM, 'SUCCESS');
            });
          },
          text: 'OK',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  static void alert(BuildContext context, String title, String description,
      onClickListener? response) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/alert.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response?.onClick(ACTION_OK, 'Alert');
            });
          },
          text: 'OK',
          iconData: Icons.done,
          color: kPrimaryLightColor,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  static void confirmalert(BuildContext context, String title,
      String description, onClickListener response) {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: description,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/alert.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              response.onClick(ACTION_CONFIRM, 'Alert');
            });
          },
          text: 'OK',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  static int getPercentage(int value1, int total) {
    return ((value1 / total) * 100).round();
    ////debugPrint('value ${value1} and ${total} ${percentage}');
    /*  if (percentage == 0) {
      return 0;
    } else {
      return percentage;
    } */
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static void showMessages(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message!),
    ));
  }

  static void displaySnackbar(BuildContext context,
      {String msg = "Feature is under development",
      required GlobalKey<ScaffoldState> key}) {
    final snackBar = SnackBar(content: Text(msg));
    /*if (key != null && key.currentState != null) {
      //key.currentState?.hideCurrentSnackBar();
      //key.currentState?.showSnackBar(snackBar);
    } else {
      //Scaffold.of(context).hideCurrentSnackBar();
      //Scaffold.of(context).showSnackBar(snackBar);
    }*/
  }

  static Widget showLoader() {
    return Center(child: Lottie.asset('assets/json/kidzee_loader.json'));
  }

  static Center showKESLoader() {
    return Center(child: Container(child: CircularProgressIndicator()));
  }

  static Center showCommingSoon() {
    return Center(child: Lottie.asset('assets/json/commingsoon.json'));
  }

  static String getFileName(String path) {
    File file = File(path);
    return basename(file.path);
  }

  static void showAdaptiveLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  static void showLoaderDialog(BuildContext context) {
    if (true || !isDialogVisible) {
      AlertDialog alert = AlertDialog(
        content: Lottie.asset('assets/json/kidzee_loader.json'),
        backgroundColor: Colors.white,
        surfaceTintColor: LightColors.kLightGrayM,
        shadowColor: LightColors.kLightGrayM,
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  static void showKESLoaderDialog(BuildContext context) {
    if (true || !isDialogVisible) {
      AlertDialog alert = AlertDialog(
        content: SizedBox(
          width: 48,
          height: 100,
          child: CircularProgressIndicator(),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: LightColors.kLightGrayM,
        shadowColor: LightColors.kLightGrayM,
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Please wait..."),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<void> initFCM() async {
    final messaging = FirebaseMessaging.instance;

    // Step 1: Ask for permission
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
        providesAppNotificationSettings: true);

//     debugPrint('Permission status: ${settings.authorizationStatus}');

    // Step 2: Only get token if permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      try {
        final token = await messaging.getToken(
          vapidKey:
              'BHGE6JChODel_ADUDWd0zGTFL2uwQEZU7i_hdnwYSFa8rbpLpqEL8Ana0gx4DVPtBXeKDsRfQUXlqz5oNcnzvy4',
        );
//         debugPrint('FCM Token: $token');
        if (token != null) {
          var prefs = await SharedPreferences.getInstance();
          var oldoken = prefs.getString(LocalConstant.KEY_FCM_TOKEN);

          if (oldoken == null || oldoken != token) {
            prefs.setString(LocalConstant.KEY_FCM_TOKEN, token);
          }
        }
      } catch (e) {
//         debugPrint('Error getting token: $e');
      }
    } else {
//       debugPrint('User declined or has not accepted permission');
    }
  }

  static void hideDialog(BuildContext context) {
    if (true || isDialogVisible) {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      }
    }
    isDialogVisible = false;
  }

  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12.withValues(alpha: 0.3),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  textStyle: TextStyle(color: kPrimaryLightColor)),
              child: Text(
                'OK',
                style: LightColors.textHeaderStyle13Selected,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showAlertDialogWithTap(
      BuildContext context, String message, Function() onTap) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12.withValues(alpha: 0.3),
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) => onTap());
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Success"),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) => onTap());
                },
                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                style: ElevatedButton.styleFrom(
                    elevation: 10.0,
                    textStyle: TextStyle(color: kPrimaryLightColor)),
                child: Text(
                  'OK',
                  style: LightColors.textHeaderStyle13Selected,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> clearData() async {
    await BpmsDB.clearAll(LocalConstant.authStorageKey);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (!kIsWeb) {
      var appDir = (await getTemporaryDirectory()).path;
      Directory(appDir).delete(recursive: true);
    }
    await Hive.box(LocalConstant.logbookStatus).clear();
    await OctiveConfig().clearAllData();
    // await Future.delayed(const Duration(seconds: 0));

    // if (Platform.isAndroid) {
    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //   });
    // } else if (Platform.isIOS) {
    //   exit(0);
    // }
  }

// static launchOnWeb(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   }
// }

  static void onApproveConfirmationBox(BuildContext context, String title,
      String message, dynamic object, onClickListener response) {
    /*Dialogs.bottomMaterialDialog(
        msg: 'Are you sure? you can\'t undo this action',
        title: 'Delete',
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              response.onClick(ACTION_OK, object);
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {},
            text: 'Delete',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]
    );*/
    Dialogs.bottomMaterialDialog(
      color: Colors.white,
      msg: message,
      title: title,
      lottieBuilder: Lottie.asset(
        'assets/json/75382-question.json',
        fit: BoxFit.contain,
      ),
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              response.onClick(ACTION_OK, object);
              //Navigator.pop(context);
            });
          },
          text: 'Approve',
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              response.onClick(ACTION_REJECT, object);
            });
          },
          text: 'Reject',
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50)).then((_) {
              response.onClick(ACTION_CANCEL, object);
            });
          },
          text: 'Cancel',
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  static void showMessageSingleButton(
      BuildContext context, String message, onClickListener listener) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                listener.onClick(ACTION_OK, '');
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  textStyle: const TextStyle(color: LightColors.kDarkBlue)),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showMessageSingle(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  textStyle: TextStyle(color: kPrimaryLightColor)),
              child: Text('OK', style: LightColors.textHeaderStyle13Selected),
            ),
          ],
        );
      },
    );
  }

  static void showMessageCallback(BuildContext context, String title,
      String message, onClickListener listener) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                listener.onClick(ACTION_OK, '');
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  textStyle: const TextStyle(color: LightColors.kDarkBlue)),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Container footer(String appVersion) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        color: LightColors.kLightGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text('Kidzee$appVersion'),
      ),
    );
  }

  static String parseDate(String value) {
    String date = value;
    DateTime dt = DateTime.now();
    //2022-07-18T00:00:00
    //2023-02-23T18:36:07.240Z
    try {
      dt = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').parse(value);
      date = DateFormat("yyyy-MM-dd").format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String parseServerDate(String value) {
    String date = value;
    if (value.isNotEmpty) {
      DateTime dt = DateTime.now();
      try {
        dt = DateFormat("dd-MMM-yyyy").parse(value);
        date = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').format(dt);
      } catch (e) {
        e.toString();
      }
    } else {
      date =
          DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').format(DateTime.now());
    }
    //debugPrint(date);
    return date;
  }

  static String parseShortDate(String value) {
    String date = value;
    DateTime dt = DateTime.now();
    //debugPrint('value ${value}');
    try {
      dt = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').parse(value);
      //debugPrint('dt ${dt.day}');
      date = DateFormat("dd MMM").format(dt);
      //debugPrint('date ${date}');
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String getServerDate() {
    String date = '';
    DateTime dt = DateTime.now();
    try {
      date = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String parseShortTime(String value) {
    String date = value;
    DateTime dt = DateTime.now();
    //debugPrint('value ${value}');
    try {
      dt = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').parse(value);
      //debugPrint('dt ${dt.day}');
      date = DateFormat("hh:mm a").format(dt);
      //debugPrint('date ${date}');
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String parseFullDate(String value) {
    String date = value;
    DateTime dt = DateTime.now();
    //debugPrint('value ${value}');
    try {
      dt = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').parse(value);
      //debugPrint('dt ${dt.day}');
      date = DateFormat("dd, MMM HH:mm a").format(dt);
      //debugPrint('date ${date}');
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static DateTime parseStringDate(String value) {
    DateTime dt = DateTime.now();
    //debugPrint('value ${value}');
    try {
      dt = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  static Future<bool> isOfflineEligble(
      BuildContext context, String value) async {
    final prefs = await SharedPreferences.getInstance();
    int currentSelection = prefs.containsKey(LocalConstant.KEY_SYNC_INTERVAL)
        ? prefs.getInt(LocalConstant.KEY_SYNC_INTERVAL) as int
        : 4;
//     debugPrint('Current Selection is $currentSelection');
    bool isOfflineEligble = false;
    if (kIsWeb) {
      return false;
    }
    if (currentSelection == 0) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    try {
      DateTime from = parseStringDate(value);
      //from = DateTime(from.year, from.month, from.day);
      int numberOfHour = (DateTime.now().difference(from).inHours).round();
      int numberOfMinutes = (DateTime.now().difference(from).inMinutes).round();
      if (numberOfHour <= currentSelection) {
        isOfflineEligble = true;
      }
//       debugPrint('is Offline $isOfflineEligble');
    } catch (e) {}
    return isOfflineEligble;
  }

  static String formatDate() {
    String date = '';
    DateTime dt = DateTime.now();
    try {
      date = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'').format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String getDate() {
    String date = '';
    DateTime dt = DateTime.now();
    try {
      date = DateFormat('yyyy/MM/dd').format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static String getSimpleDate() {
    String date = '';
    DateTime dt = DateTime.now();
    try {
      date = DateFormat('yyyy-MM-dd').format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static DateTime parseDateSimple(String value) {
    DateTime dt = DateTime.now();
    //debugPrint('value ${value}');
    try {
      dt = DateFormat('yyyy/MM/dd').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static String getDay() {
    String date = '';
    DateTime dt = DateTime.now();
    try {
      date = DateFormat('dd').format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  static bool isKES(String value) {
    debugPrint('isKES $value');
    return value.isNotEmpty && value.toLowerCase() == 'k12' ||
            value.toLowerCase() == 'kes'
        ? true
        : false;
  }

  static Future<FilePickerResult?> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'pdf',
        'doc',
        'png',
        'gif',
        'mp3',
        'mp4',
        'jpeg'
      ],
    );
    return result;
  }

  static Future<FilePickerResult?> uploadHomeworkFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'gif', 'jpeg'],
    );

    return result;
  }

  static bool isLargeFile(FilePickerResult result, BuildContext context) {
    if (result.files.isNotEmpty) {
      final file = result.files.first;
      final fileSizeInBytes = file.size;
      final maxSizeInBytes = 20 * 1024 * 1024; // 20MB

      if (fileSizeInBytes <= maxSizeInBytes) {
        // File is valid
//         debugPrint("File picked: ${file.name}, size: $fileSizeInBytes bytes");
        return false;
      } else {
        // File is too large
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("File too large"),
            content: Text("Maximum file size allowed is 20MB."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          ),
        );
        return true;
      }
    } else {
      return false;
    }
  }

  static Future<FilePickerResult?> uploadPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return result;
  }

  static Row commonAttachmentLoad(BuildContext context,
      {required Function(bool) isLoading,
      required Function(String) onSelectedImage,
      required String? selectedImageUrl,
      required bool showLoader}) {
    return Row(
      children: [
        Text('Attachment:'),
        SizedBox(
          width: 20,
        ),
        showLoader
            ? SizedBox(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: InkWell(
                  onTap: () async {
                    isLoading(true);
                    UploadImageResponse? uploadImageResponse =
                        await Utils.showImagePicker(context);
                    isLoading(false);

                    debugPrint(
                        'Response from upload image is - ${uploadImageResponse?.toJson()}');
                    if (uploadImageResponse != null &&
                        uploadImageResponse.message.contains('Successfully') &&
                        uploadImageResponse.imageModel?.first.location !=
                            null) {
                      onSelectedImage(
                          uploadImageResponse.imageModel!.first.location);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.upload),
                      // Text('File Name'),
                      Expanded(
                        child: Text(
                          selectedImageUrl == null
                              ? 'File Name'
                              : selectedImageUrl.split('/').last ?? '',
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      selectedImageUrl != null
                          ? Image.network(
                              selectedImageUrl,
                              height: 60,
                              width: 60,
                            )
                          : Icon(Icons.image)
                    ],
                  ),
                ),
              )
      ],
    );
  }

  static CachedNetworkImage getImageWidget(String imageUrl, String defImage) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.scaleDown,
            //colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      placeholder: (context, url) =>
          defImage.isNotEmpty ? Image.asset(defImage) : Icon(Icons.camera),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static void showImageDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Stack(children: [
        ImageViewer(imageUrl: url),
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.clear,
                color: Colors.redAccent,
              )),
        )
      ]),
    );
  }

  static String parseDateformat(String value) {
    String date = value;
    DateTime dt = DateTime.now();
    //2022-07-18T00:00:00
    //2023-02-23T18:36:07.240Z
    try {
      dt = DateFormat('dd-MM-yyyy').parse(value);
      date = DateFormat("MMM-dd").format(dt);
    } catch (e) {
      e.toString();
    }
    return date;
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static HttpClient? _httpClient;
  static HttpClient get httpClient => _httpClient ??= HttpClient();

  static Future<dynamic> downloadFile(String url, String filename) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
      return;
    }
    String dir = (await getTemporaryDirectory()).path;
    debugPrint(dir.toString());
    File file = File('$dir/$filename');
    debugPrint(file.path.toString());
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<dynamic> downloadFileIOS(String url, String filename) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
      return;
    }
    Directory directory;

    if (defaultTargetPlatform == TargetPlatform.android) {
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    String? dir = directory.path;
    debugPrint(dir.toString());
    File file = File('$dir/$filename');
    debugPrint(file.path.toString());
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<dynamic> downloadImage(String url, String filename) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    File file = File('/storage/emulated/0/Download/$filename');

    debugPrint(file.path.toString());
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
      NotificationService notificationService = NotificationService();
      notificationService.showNotification(12, 'Download Success',
          'File successfully download', 'File successfully download');
      return file;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<dynamic> downloadContent(String url, String filename) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
      return;
    }
    File file = File(filename);
    debugPrint(filename);
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> viewimage(BuildContext context, String imageUrl) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return goToImageViewer(imageUrl: imageUrl);
    }));
  }

  static Future<void> requestDownload(String url, String name) async {
    //final dir = await getApplicationDocumentsDirectory();
    //final dir = await getExternalStorageDirectory();
    final dir = defaultTargetPlatform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    //From path_provider package
    var localPath = dir!.path + name;
//     debugPrint('local path $localPath');
    final savedDir = Directory(localPath);
    await savedDir.create(recursive: true).then((value) async {
      String? taskid = await FlutterDownloader.enqueue(
        url: url,
        fileName: name,
        savedDir: localPath,
        showNotification: true,
        allowCellular: true,
        openFileFromNotification: true,
      );
//       debugPrint('download complete');
      debugPrint(taskid);
    });
  }

  static Future<void> downloadOffline(BuildContext context, String url,
      String path, onDownload listener) async {
    listener.onDownloadStart();
    final taskId = await FlutterDownloader.enqueue(
      url: 'your download link',
      headers: APIService()
          .getNormalHeader1(), // optional: header send with url (auth token etc)
      savedDir: path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    listener.onDownloadSuccess(path);
  }

  static Future<void> showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title), //"Confirm Update"),
          content: Text(message), //"Are you sure you want to update?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call API if confirmed
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
