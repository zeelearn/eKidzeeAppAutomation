import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/api/request/login_model.dart';
import 'package:ekidzee/firebase/anylatics.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/request/forgotpassword_request.dart';
import '../../../api/response/pentemind/GenericResponse.dart';
import '../../../helper/LocalStrings.dart';
import '../../../helper/utils.dart';
import '../../../model/user_model.dart';
import '../../../ui/theme.dart';
import '../../../utils/theme/colors/light_colors.dart';
import '../../../widget/input_field.dart';
import '../../bpms/auth/ui/bpms_home.dart' /* deferred as bpmsHome */;
import '../../feedback/firestore/survey_firestore.dart';
import '../../intro/pentemind_splash.dart' /* deferred as pentemindSplash */;
import '../PrivacyPolicyScreen.dart' /* deferred as privacyPolicyScreen */;
import '../otp.dart' /* deferred as otpPage */;

/// Refactored Login Form using GetX Controller
/// - Keeps same UI (mostly) but moves logic into LoginController
/// - Saves user details to SharedPreferences / KidzeePref
/// - Handles legacy and new API response shapes

// class Securelogin extends StatelessWidget {
//   final Map<String, String> params;
//   const Securelogin({required this.params, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(LoginController());
//     return Scaffold(
//       body: GetBuilder<LoginController>(
//         init: LoginController(),
//         initState: (_) {
//           final c = Get.find<LoginController>();
//           c.initFromParams(params);
//         },
//         builder: (controller) {
//           return Form(
//             child: Column(
//               children: [
//                 TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   cursorColor: kPrimaryColor,
//                   controller: controller.userNameController,
//                   decoration: const InputDecoration(
//                     hintText: "User Name ",
//                     prefixIcon: Padding(
//                       padding: EdgeInsets.all(defaultPadding),
//                       child: Icon(Icons.person),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
//                   child: TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                     ],
//                     textInputAction: TextInputAction.done,
//                     obscureText: controller.obscureText.value,
//                     cursorColor: kPrimaryColor,
//                     controller: controller.userPasswordController,
//                     decoration: InputDecoration(
//                       hintText: "password",
//                       suffixIcon: GestureDetector(
//                         onTap: controller.toggleObscure,
//                         child: Obx(() => Icon(controller.obscureText.value
//                             ? Icons.visibility
//                             : Icons.visibility_off)),
//                       ),
//                       prefixIcon: const Padding(
//                         padding: EdgeInsets.all(defaultPadding),
//                         child: Icon(Icons.lock),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                     height: 40,
//                     margin: const EdgeInsets.all(2),
//                     padding: const EdgeInsets.all(10),
//                     decoration: const BoxDecoration(
//                       color: LightColors.kLightGray,
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: Center(
//                         child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         style: LightColors.textSmallStyle,
//                         isExpanded: true,
//                         isDense: true,
//                         alignment: Alignment.center,
//                         value: controller.chosenValue.value,
//                         items: controller.options.map((item) {
//                           return DropdownMenuItem(
//                             value: item,
//                             child: Text(item),
//                           );
//                         }).toList(),
//                         onChanged: controller.setChosenValue,
//                       ),
//                     ))),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Material(
//                       color: Colors.white,
//                       child: Obx(() => Checkbox(
//                             value: controller.isChecked.value,
//                             onChanged: (value) {
//                               controller.setChecked(value ?? false);
//                             },
//                           )),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         if (kIsWeb) {
//                           controller.launchPrivacyPolicy();
//                         } else {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   PrivacyPolicyScreen() /* getDeferredWidget(
//                                       child: (context) => privacyPolicyScreen
//                                           .PrivacyPolicyScreen(),
//                                       loadLibrary:
//                                           privacyPolicyScreen.loadLibrary()) */
//                               ));
//                         }
//                       },
//                       child: const Text(
//                         'I have read and accept terms \nand conditions',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: defaultPadding),
//                 Obx(() => controller.isLoading.value
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: controller.checkAuth,
//                         child: Text(
//                           "Login".toUpperCase(),
//                           style: LightColors.textHeaderStyle13Selected,
//                         ),
//                       )),
//                 const SizedBox(height: defaultPadding),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   ForgotPasswordPage1() /* getDeferredWidget(
//                                       child: (context) => forgotPasswordPage
//                                           .ForgotPasswordPage(),
//                                       loadLibrary:
//                                           forgotPasswordPage.loadLibrary()) */
//                               ));
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           child: const Text(
//                             'Forgot Password?',
//                             style: TextStyle(color: AppColors.lightGray),
//                           ),
//                         )),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class LoginController extends GetxController implements onClickListener {
  final APIService _apiService = APIService();

  // UI controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();

  // reactive state
  var obscureText = true.obs;
  var isChecked = false.obs;
  var rememberMe = false.obs;

  var isLoading = false.obs;
  var chosenValue = '2025-2026'.obs;

  var showPassword = false.obs;
  var acceptTerms = false.obs;
  var selectedYear = '2025-2026'.obs;

  final years = ['2024-2025', '2025-2026', '2026-2027'];

  void togglePassword1() {
    showPassword.value = !showPassword.value;
  }

  final List<String> options = [
    'Select',
    '2026-2027',
    '2025-2026',
    //'2024-2025',
  ];

  // Password change controllers (used in bottom sheet)
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    debugPrint('Api service oninit');
    loadSavedLogin();

    // initialize if needed
  }

  Future<void> loadSavedLogin() async {
    rememberMe.value = await KidzeePref().isRememberMe();
    debugPrint('rememberMe $rememberMe');
    if (rememberMe.value) {
      var prefs = KidzeePref();
      userNameController.text =
          await prefs.getString(LocalConstant.KEY_USER_NAME) ?? '';
      userPasswordController.text =
          await prefs.getString(LocalConstant.KEY_USER_PASSWORD) ?? '';
      debugPrint('userNameController.text $userNameController.text');
      debugPrint('userPasswordController.text $userPasswordController.text');
    }
  }

  setAcademicYear() async {
    debugPrint('selected chosenValue is  $chosenValue');
    if (chosenValue.value == '2024-2025') {
      await KidzeePref().saveAcademicYear(24);
    } else if (chosenValue.value == '2025-2026') {
      await KidzeePref().saveAcademicYear(25);
      debugPrint('set Academic Year 25');
    } else if (chosenValue.value == '2026-2027') {
      debugPrint('set Academic Year 26');
      await KidzeePref().saveAcademicYear(26);
    } else {
      debugPrint('set Academic Year 26 def');
      await KidzeePref().saveAcademicYear(26);
    }
  }

  // Toggle password icon
  void togglePassword() {
    obscureText.value = !obscureText.value;
  }

  // Launch URL
  void openPrivacyPolicy() {
    if (kIsWeb) {
      launchPrivacyPolicy();
    } else {
      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              PrivacyPolicyScreen() /* getDeferredWidget(
                                      child: (context) => privacyPolicyScreen
                                          .PrivacyPolicyScreen(),
                                      loadLibrary:
                                          privacyPolicyScreen.loadLibrary()) */
          ));
    }
  }

  void initFromParams(Map<String, String> params) {
    if (params.containsKey('username')) {
      userNameController.text = params['username'] ?? '';
    }
    if (params.containsKey('password')) {
      userPasswordController.text = params['password'] ?? '';
      isChecked.value = true;
      // directly validate if both present
      Future.microtask(() => validate());
    }
  }

  void toggleObscure() => obscureText.toggle();

  void setChosenValue(String? val) {
    if (val == null) return;
    chosenValue.value = val;
    update();
  }

  void setChecked(bool val) {
    isChecked.value = val;
    update();
  }

  void launchPrivacyPolicy() async {
    const url = 'https://www.kidzee.com/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void recoverPassword() async {
    if (isLoading.value) return;
    if (userNameController.text.isEmpty) {
      Utility.showMessage(Get.context!, "Please Enter UserName");
      return;
    }
    if (chosenValue.value == 'Select') {
      Utility.showMessage(
          Get.context!, "Please accept the Terms and Conditions");
      return;
    }
    if (userNameController.text.isNotEmpty) {
      isLoading.value = true;
      await setAcademicYear();
      debugPrint('updating academic year');
      //Utility.showLoader();
      ForgotPasswordRequest request =
          ForgotPasswordRequest(User_Name: userNameController.text);
      APIService apiService = APIService();

      apiService.forgotPassword(request).then((value) {
        if (value != null) {
          GenericResponse response = value as GenericResponse;
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          if (response.response[0].response.toString().contains('Invalid')) {
            Utility.alert(Get.context!, 'Alert ',
                response.response[0].response.toString(), this);
          } else {
            Utility.smsSendMessage(Get.context!, 'Success ',
                response.response[0].response.toString(), this);
          }
        } else {
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          Utility.showMessages(Get.context!, 'Invalid User Name and Password');
        }
        isLoading.value = false;
        ////debugPrint('Captured in Listener value is null' );
      });
    } else {
      //Navigator.of(context, rootNavigator: true).pop('dialog');
      reset();
      Utility.showMessage(Get.context!, "Please Enter Valid User Name");
      isLoading.value = false;
    }
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', '');
    await prefs.setString('userid', '');
    await prefs.setString(LocalConstant.KEY_DISPLAY_NAME, '');
    await prefs.setString(LocalConstant.KEY_USER_NAME, '');
    await prefs.setString(LocalConstant.KEY_USER_ID, '');
    await prefs.setString(LocalConstant.KEY_UID, '');
    await prefs.setString(LocalConstant.KEY_USER_TYPE, '');
    await prefs.setString(LocalConstant.KEY_MOBILENO, '');
    await prefs.setString(LocalConstant.KEY_ACADEMICYEAR, '');
    await prefs.setString(LocalConstant.KEY_GUARDIAN_CONTACT, '');
    await prefs.setString(LocalConstant.KEY_CONE_CODE, '');
    await prefs.setString(LocalConstant.KEY_STATE_ID, '');
    await prefs.setString(LocalConstant.KEY_FRANCHISEE_TYPE, '');
    await prefs.setString(LocalConstant.KEY_IS_EXTERNAL_USER, '');
    await prefs.setString(LocalConstant.KEY_FRANCHISEE_ID, '');
    await prefs.setString(LocalConstant.KEY_USER_TYPE_NAME, '');
    await prefs.setString(LocalConstant.KEY_IS_ILLUM_KIT, '');
    await prefs.setString(LocalConstant.KEY_IS_KG_KIT, '');
  }

  /// Entry from UI: check connectivity then call validate
  Future<void> checkAuth() async {
    isLoading(true);
    await KidzeePref().clearLoginData();
    setAcademicYear();
    bool isInternet = await Utility.isInternet();
    isLoading(false);
    if (!isInternet) {
      Utility.showMessageSingleButton(
          Get.context!, 'Please Check Internet Connection', this);
      return;
    }
    await validate();
  }

  /// Core login logic moved from Stateful widget
  Future<void> validate() async {
    reset();
    setAcademicYear();
    final context = Get.context!;
    //final prefs = await SharedPreferences.getInstance();

    if (!isChecked.value) {
      Utility.showMessage(context, "Please accept the Terms and Conditions");
      return;
    }

    if (userNameController.text.trim().isEmpty) {
      Utility.alert(context, 'Alert', "Please Enter the User Name", this);
      return;
    }
    if (userPasswordController.text.trim().isEmpty) {
      Utility.alert(context, 'Alert', "Please Enter the Password", this);
      return;
    }

    if (chosenValue.value == 'Select') {
      Utility.alert(context, 'Alert', "Please Select Academic Year", this);
      return;
    }
    await KidzeePref().updateRememberMe(rememberMe.value);
    // debugPrint(await KidzeePref().isRememberMe());

    try {
      Utility.showLoaderDialog(context);
      final loginRequestModel = LoginRequestModel(
        User_Name: userNameController.text.trim(),
        User_Password: userPasswordController.text.trim(),
        Device_id: '',
        Otp: '',
      );
      final apiResult = await _apiService.secureLogin(loginRequestModel);
      if (apiResult != null) {
        handleLoginResponse(apiResult);
      } else {
        Utility.hideDialog(context);
        Utility.alert(context, 'Alert',
            "Something went wrong, please try again later", this);
      }
    } catch (e, st) {
      //if (Get.isDialogOpen ?? false) Navigator.of(Get.context!, rootNavigator: true).pop('dialog');
      Utility.hideDialog(context);
      Utility.alert(Get.context!, 'Alert', 'An error occurred', this);
      debugPrint('Login error: $e\n$st');
    }
  }

  Future<void> handleLoginResponse(dynamic value) async {
    debugPrint('handle response $value');
    final prefs = await SharedPreferences.getInstance();
    Utility.hideDialog(Get.context!);
    // 1️⃣ API BYPASS case
    if (chosenValue == '2024-2025' &&
        value is String &&
        value == 'API_BYPASS') {
      FirebaseAnalyticsUtils.captureEvent('API_BYPASS');
      clean();
      return;
    }

    // 2️⃣ Null response
    if (value == null) {
      debugPrint('null value in 487');
      //Navigator.of(Get.context!, rootNavigator: true).pop('dialog');
      Utility.alert(Get.context!, 'Alert', "Something went wrong", this);
      return;
    }

    // 3️⃣ FAILURE RESPONSE (401)
    if (value is SecureLoginFailuarResponse) {
      debugPrint('SecureLoginFailuarResponse fount $value');
      SecureLoginFailuarResponse loginFailuarResponse = value;
      //Navigator.of(Get.context!, rootNavigator: true).pop('dialog');

      if (loginFailuarResponse.data!.isReset ?? false) {
        await prefs.setString(LocalConstant.KEY_USER_TYPE,
            loginFailuarResponse.data!.userType ?? "");
        await prefs.setString(LocalConstant.KEY_USER_NAME,
            userNameController.text.toString() ?? "");
        showChangePasswordDialog(Get.context!, loginFailuarResponse.data!.msg!);
      } else {
        Utility.alert(
          Get.context!,
          (loginFailuarResponse.data!.isReset ?? false)
              ? 'Change Password'
              : 'Login Failed',
          value.data!.msg!.isNotEmpty == true
              ? value.data!.msg!
              : "Incorrect username or password",
          this,
        );
      }
      return;
    }

    // 4️⃣ SUCCESS RESPONSE
    if (value is SecureLoginResponseModel && value.data != null) {
      SecureLoginResponseModel model = value;
      final user = model.data!;

      await KidzeePref().saveLoginResponse(user);
      await KidzeePref().saveToken(model.token ?? '');

      // Save values in Prefs
      await prefs.setString(LocalConstant.KEY_APP_TOKEN, value.token ?? "");
      await prefs.setString(LocalConstant.KEY_UID, user.uid ?? "0");
      await prefs.setString(LocalConstant.KEY_USER_ID, user.userId ?? "0");
      await prefs.setInt(LocalConstant.KEY_BUSINESS_ID, 1);
      await prefs.setString(LocalConstant.KEY_USER_NAME, user.userName ?? "");
      await prefs.setString(LocalConstant.KEY_USER_TYPE, user.userType ?? "");
      await prefs.setString(
          LocalConstant.KEY_USER_TYPE_NAME, user.userType ?? "");
      await prefs.setString(LocalConstant.KEY_MOBILENO, user.mobileNo ?? "");
      await prefs.setString(
          LocalConstant.KEY_DISPLAY_NAME, user.contactPerson ?? "");
      await prefs.setInt(
          LocalConstant.KEY_ACADEMICYEAR, user.currentACADYear ?? 0);
      await prefs.setString('contact_person', user.contactPerson ?? "");
      await prefs.setString(LocalConstant.KEY_EMAILID, user.emailId ?? "");
      await prefs.setString(LocalConstant.KEY_ZONE, user.zoneCode ?? "");
      await prefs.setString(
          LocalConstant.KEY_FRANCHISEE_ID, user.franchiseeId.toString() ?? "0");
      await prefs.setString(LocalConstant.KEY_TIRETYPE, user.tierType ?? "");
      await prefs.setString(LocalConstant.KEY_TIRETYPE, user.tierName ?? "");
      await prefs.setBool(
          'Requested_IllumeKit', user.requestedIllumeKit ?? false);
      await prefs.setBool('Requested_KGKit', user.requestedKGKit ?? false);
      await prefs.setString(LocalConstant.KEY_COUNTRY_NAME, user.country ?? "");
      await prefs.setString(
          LocalConstant.KEY_USER_PASSWORD, userPasswordController.text);

      if (user.isTempPartner == true) {
        print('IsTemp true, setting franchiseecode to 0');
        FirebaseAnalyticsUtils().setUserProperties(
            userType: user.userType!,
            zoneCode: user.zoneCode!,
            franchiseecode: '0');
      } else {
        print('IsTemp false, setting franchiseecode to ${user.franchiseeCode}');
        await SurveyFirestore.addCompletedSurveyonLogintoOffline();
        FirebaseAnalyticsUtils().setUserProperties(
            userType: user.userType!,
            zoneCode: user.zoneCode!,
            franchiseecode: user.isTempPartner == true
                ? user.userName!
                : user.franchiseeCode.toString());
      }

      //update current class
      try {
        if (user.program!.length == 1) {
          prefs.setString(LocalConstant.KEY_CURRENT_CLASS_NAME,
              user.program![0].className!);
          prefs.setString(LocalConstant.KEY_CURRENT_PROGRAM_NAME,
              user.program![0].programName!);
          prefs.setInt(LocalConstant.KEY_CURRENT_PROGRAM_ID,
              user.program![0].programId!);
          prefs.setInt(
              LocalConstant.KEY_CURRENT_CLASS_ID, user.program![0].classId!);
        }
      } catch (e) {}
      if (user.userType == 'P') {
        await prefs.setString(
            LocalConstant.KEY_DISPLAY_NAME, user.displayName ?? "");
      }
      if (user.userType == 'P') {
        await prefs.setString(
            LocalConstant.KEY_DISPLAY_NAME, user.displayName ?? "");
        prefs.setString(LocalConstant.KEY_STUDENT_NAME, user.displayName ?? "");
        prefs.setInt(LocalConstant.KEY_STUDENT_ID, user.studentId! ?? 0);
        prefs.setString(LocalConstant.KEY_USER_AVTAR, user.profileURL! ?? "");
      }
      // try {
      //   if (pentemindResponseModel.data.StudentData.isNotEmpty) {
      //     prefs.setInt(LocalConstant.KEY_STUDENT_ID, pentemindResponseModel.data.StudentData[0].StudentID);
      //     prefs.setString(LocalConstant.KEY_USER_AVTAR, pentemindResponseModel.data.StudentData[0].studentprofileURL);
      //     prefs.setString(LocalConstant.KEY_STUDENT_NAME, pentemindResponseModel.data.StudentData[0].StudentName);
      //     prefs.setString(LocalConstant.KEY_FRANCHISEE_ID, pentemindResponseModel.data.StudentData[0].Franchisee_Id.toString());
      //   } else {
      //     prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
      //   }
      // } catch (e) {
      //   prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
      //   debugPrint(e.toString());
      // }

      KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');

      // UI updates
      //setState(() => isApiCallProcess = false);

      // 5️⃣ If Reset Password required
      if (user.resetPassword == 1 || user.isReset == true) {
        await prefs.setString(LocalConstant.KEY_USER_TYPE, user.userType ?? "");
        await prefs.setString(LocalConstant.KEY_USER_NAME,
            userNameController.text.toString() ?? "");
        showChangePasswordDialog(Get.context!, user.msg!);
        return;
      }

      // 6️⃣ OTP flow
      if (user.isOTP == true) {
        KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'false');
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => Otp(
              mobileNumber: user.mobileNo ?? '9999999999',
              userName: user.userName ?? '',
            ) /* getDeferredWidget(
              child: (context) => otpPage.Otp(
                mobileNumber: user.mobileNo ?? '9999999999',
                userName: user.userName ?? '',
              ),
              loadLibrary: otpPage.loadLibrary(),
            ) */
            ,
          ),
        );
        return;
      }

      // 7️⃣ Normal login success
      KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');

      if (user.isTempPartner == true) {
        KidzeePref().setString(LocalConstant.KEY_IS_CENTER_SETUP, 'true');
        KidzeePref().setString(LocalConstant.KEY_APP_TOKEN, 'true');
        clean();
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(
            builder: (context) =>
                BPMSHome() /* getDeferredWidget(
              child: (context) => bpmsHome.BPMSHome(),
              loadLibrary: bpmsHome.loadLibrary(),
            ) */
            ,
          ),
          (route) => false,
        );
      } else {
        KidzeePref().setString(LocalConstant.KEY_IS_CENTER_SETUP, 'false');
        bool isKes = checkIsKES(user.program!);
        var localYearID = await KidzeePref().getAcademicYear();
        LocalConstant.isCognimind = localYearID >= 26 && isKes;

        clean();
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(
              builder: (context) => PentemindSplashScreen(
                  isKES:
                      isKes)) /* getDeferredWidget(
              child: (context) =>
                  pentemindSplash.PentemindSplashScreen(isKES: isKes),
              loadLibrary: pentemindSplash.loadLibrary(),
            ),
          ) */
          ,
          (route) => false,
        );
      }

      return;
    }

    // 8️⃣ Any other case (Unknown response)
    //Navigator.of(Get.context!, rootNavigator: true).pop('dialog');
    Utility.alert(
      Get.context!,
      'Alert',
      "Unable to process login. Please try again.",
      this,
    );
  }

  bool checkIsKES(List<ProgramModel> programs) {
    for (var classModel in programs) {
      if (classModel.curriculumType!.isNotEmpty &&
          (classModel.curriculumType!.toLowerCase() == 'k12' ||
              classModel.curriculumType!.toLowerCase() == 'kes')) {
        return true;
      }
    }
    return false;
  }

  /// Change password flow (called from bottom sheet)
  // Future<void> changePassword() async {
  //   debugPrint('changes [asswod');
  //   final context = Get.context!;
  //   debugPrint('context $context');
  //   if (newPasswordController.text.trim().isEmpty || repeatPasswordController.text.trim().isEmpty) {
  //     _showAlertDialog('Alert', 'Please Enter the Password');
  //     return;
  //   }
  //   if (newPasswordController.text.trim() != repeatPasswordController.text.trim()) {
  //     _showAlertDialog('Alert', 'Password and Repeat password does not match');
  //     return;
  //   }
  //   debugPrint('changes [asswod 535' );
  //   //Utility.showLoaderDialog(context);
  //   final pref = await SharedPreferences.getInstance();
  //   final userType = pref.getString(LocalConstant.KEY_USER_TYPE) ?? '';
  //   final userName = pref.getString(LocalConstant.KEY_USER_NAME) ?? userNameController.text;
  //   final userPassword = pref.getString(LocalConstant.KEY_USER_PASSWORD) ?? userPasswordController.text;
  //
  //   final req = ChangePasswordRequest(
  //     Username: userName,
  //     OldPassword: userPassword,
  //     newPassword: newPasswordController.text.trim(),
  //     userType: userType,
  //   );
  //   debugPrint(req.toJson());
  //   debugPrint('_apiService in 551 ${_apiService}');
  //   try {
  //     APIService apiService = APIService();
  //     debugPrint('_apiService in 555 ${apiService}');
  //
  //     var response = await changeUserPassword(req);
  //     if (response!.MSG == 'Password changed successfully') {
  //       isChecked.value = true;
  //       userPasswordController.text = newPasswordController.text;
  //       Utility.showMessage(context, response.MSG);
  //       newPasswordController.clear();
  //       repeatPasswordController.clear();
  //       await validate();
  //       Get.back(); // close bottom sheet
  //     } else {
  //       _showAlertDialog('Alert', response.MSG);
  //     }
  //     // apiService.changePassword(req).then((response) async {
  //     //   if (response != null) {
  //     //     if (response.MSG == 'Password changed successfully') {
  //     //       isChecked.value = true;
  //     //       userPasswordController.text = newPasswordController.text;
  //     //       Utility.showMessage(context, response.MSG);
  //     //       newPasswordController.clear();
  //     //       repeatPasswordController.clear();
  //     //       await validate();
  //     //       Get.back(); // close bottom sheet
  //     //     } else {
  //     //       _showAlertDialog('Alert', response.MSG);
  //     //     }
  //     //   } else {
  //     //     _showAlertDialog("Alert", 'Unable to update the Password');
  //     //     //debugPrint("Value is null");
  //     //   }
  //     //   Navigator.pop(context);
  //     // });
  //
  //   } catch (e) {
  //     //Navigator.of(context, rootNavigator: true).pop('dialog');
  //     _showAlertDialog('Alert', 'Unable to update the Password -2 ${e.toString()}');
  //   }
  // }

  void changeUserPassword() async {
    try {
      if (newPasswordController.text.trim().isEmpty ||
          repeatPasswordController.text.trim().isEmpty) {
        _showAlertDialog('Alert', 'Please Enter the Password');
      } else if (newPasswordController.text.trim() !=
          repeatPasswordController.text.trim()) {
        _showAlertDialog(
            'Alert', 'Password and Repeat password does not match');
        return null;
      } else {
        debugPrint('changes [asswod 53555');
        Utility.showLoaderDialog(Get.context!);
        final pref = await SharedPreferences.getInstance();
        final userType = pref.getString(LocalConstant.KEY_USER_TYPE) ?? '';
        final userName = userNameController.text.isNotEmpty
            ? userNameController.text
            : pref.getString(LocalConstant.KEY_USER_NAME) ??
                userNameController.text;
        debugPrint('userNameController.text ${userNameController.text}');
        debugPrint(
            'pref.getString(LocalConstant.KEY_USER_NAME) ${pref.getString(LocalConstant.KEY_USER_NAME)}');
        debugPrint('userName $userName');
        final userPassword = userPasswordController.text;

        final url = Uri.parse(
            _apiService.pentemind_url + LocalStrings.API_RESET_PASSWORD);

        final headers = {
          'Content-Type': 'application/json',
        };

        final body = jsonEncode({
          "Username": userName,
          "newPassword": newPasswordController.text.toString(),
          "OldPassword": userPassword,
          "userType": userType,
        });

        try {
          final response = await http.post(
            url,
            headers: headers,
            body: body,
          );
          if (response.statusCode == 200 || response.statusCode == 400) {
            // GenericResponse apiresponse = response.body as GenericResponse;
            Utility.hideDialog(Get.context!);
            GenericResponse apiresponse = GenericResponse.fromJson(
              json.decode(response.body),
            );
            if (apiresponse.response[0].response is String &&
                    apiresponse.response[0].response
                        .toString()
                        .contains('Invalid') ||
                apiresponse.response[0].response
                    .toString()
                    .contains('cannot')) {
              Utility.alert(Get.context!, 'Alert ',
                  apiresponse.response[0].response.toString(), this);
            } else {
              //Utility.smsSendMessage(Get.context!, 'Success ',apiresponse.response[0].response.toString(), this);
              Get.back();
              userPasswordController.text =
                  newPasswordController.text.toString();
              showPasswordChanged(
                  "Success", apiresponse.response[0].response.toString());
            }
            // String body = response.body;
            // body = body.replaceAll("[", "");
            // body = body.replaceAll("]", "");
            // debugPrint(body);
            // ChangePasswordResponse changemodel =  ChangePasswordResponse.fromJson(
            //   json.decode(body),
            // );
            // debugPrint('devode ${changemodel.toJson()}');
            // //Password cannot be same as last three password
            // Utility.hideDialog(Get.context!);
            // if(changemodel.MSG.toLowerCase().contains('success')){
            //   userPasswordController.text = newPasswordController.text.toString();
            //   showPasswordChanged("Success", changemodel.MSG);
            //   //_showAlertDialog('Alert', changemodel.MSG);
            // }else if (changemodel.MSG == 'Invalid User') {
            //   _showAlertDialog('Alert', changemodel.MSG);
            //   return null;
            // }else if (changemodel.MSG == 'Password cannot be same as last three password') {
            //   _showAlertDialog('Alert', changemodel.MSG);
            //   return null;
            // }else{
            //   Get.back();
            //   _showAlertDialog('Alert', changemodel.MSG);
            //
            // }
          } else {
            Utility.hideDialog(Get.context!);
            _showAlertDialog('Alert', 'Something went wrong');
          }
        } catch (e) {
          Utility.hideDialog(Get.context!);
          _showAlertDialog('Alert', 'Something went wrong');
          debugPrint("Error: $e");
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
      e.toString();
      return null;
    }
    //return ChangePasswordResponse(MSG: 'INVALID');
    //return null;
  }

  void _showAlertDialog(String title, String content) {
    showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

  void showPasswordChanged(String title, String content) {
    showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Get.back();
                validate();
              },
            ),
          ],
        );
      },
    );
  }

  /// Bottom sheet for change password migrated to GetX controller
  void showChangePasswordBottomSheet() {
    final ctx = Get.context!;
    newPasswordController.text = '';
    repeatPasswordController.text = '';

    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        isDismissible: false,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34), topRight: Radius.circular(34)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 6,
                      width: 40,
                      decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(3))),
                  const SizedBox(height: 16),
                  const Text('Password Change',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  EkidzeeInputField(
                      controller: newPasswordController,
                      hint: 'New Password',
                      validator: (v) => null,
                      error: ''),
                  const SizedBox(height: 18),
                  EkidzeeInputField(
                    controller: repeatPasswordController,
                    hint: 'Repeat New Password',
                    validator: (v) => null,
                    error: '',
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                                color: Colors.teal, width: 2.0)),
                      ),
                    ),
                    child: Text('Submit',
                        style: LightColors.textHeaderStyle13Selected),
                    onPressed: () async {
                      changeUserPassword();
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        });
  }

  void showChangePasswordDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (context) {
        return AlertDialog(
          title: Text("Password Change Required"),
          content: Text(
            message,
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context); // close dialog
            //   },
            //   child: Text("Cancel"),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                _showChangePasswordBottomSheet();
// call your function
              },
              child: Text(
                "OK",
                style: LightColors.textHeaderStyleWhite,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordBottomSheet() => showChangePasswordBottomSheet();

  /// Expose method for UI to open bottom sheet
  void openChangePasswordSheet() => _showChangePasswordBottomSheet();

  @override
  void onClick(int action, value) {
    // implement onClick if needed
  }

  void clean() {
    userNameController.text = '';
    userPasswordController.text = '';
  }
}
