// import 'package:ekidzee/api/request/change_password.dart';
// import 'package:ekidzee/firebase/anylatics.dart';
// import 'package:ekidzee/helper/KidzeePref.dart';
// import 'package:ekidzee/helper/LocalConstant.dart';
// import 'package:ekidzee/helper/LocalStrings.dart';
// import 'package:ekidzee/iface/onClick.dart';
// import 'package:ekidzee/pages/home/home_screen.dart';
// import 'package:ekidzee/pages/login/components/password_bloc.dart';
// import 'package:ekidzee/pages/login/components/password_repository.dart';
// import 'package:ekidzee/pages/login/components/password_state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../api/APIService.dart';
// import '../../../api/request/login_model.dart';
// import '../../../api/response/login_fail.dart';
// import '../../../api/response/pentemind/pen_login_response.dart';
// import '../../../app_routes.dart';
// import '../../../constants.dart';
// import '../../../globals.dart';
// import '../../../helper/utils.dart';
// import '../../../model/user_model.dart';
// import '../../../ui/theme.dart';
// import '../../../utils/theme/colors/light_colors.dart';
// import '../../../widget/input_field.dart';
// import '../../bpms/auth/ui/bpms_home.dart' deferred as bpmsHome;
// import '../../feedback/firestore/survey_firestore.dart';
// import '../../intro/pentemind_splash.dart' deferred as pentemindSplash;
// import '../PrivacyPolicyScreen.dart' deferred as privacyPolicyScreen;
// import '../forgot_password_page.dart' deferred as forgotPasswordPage;
// import '../otp.dart' deferred as otpPage;
//
// class LoginForm extends StatefulWidget {
//   Map<String, String> params;
//   LoginForm({required this.params, super.key});
//
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }
//
// enum RECOVERID_BY { USERID, EMAIL }
//
// class _LoginFormState extends State<LoginForm>
//     implements changePasswordInterface, onClickListener {
//   //_LoginFormState({Key? key}) : super(key: key);
//
//   bool _obscureText = true;
//
//   late TextEditingController _currentPasswordController =
//       TextEditingController();
//   late TextEditingController _newPasswordController = TextEditingController();
//   late TextEditingController _repeatPasswordController =
//       TextEditingController();
//
//   bool isChecked = false;
//   bool isApiCallProcess = false;
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController userPasswordController = TextEditingController();
//
//   List<String> options = [
//     'Select',
//     '2025-2026',
//     '2024-2025' /*, '2023-2024' */
//   ];
//   String chosenValue = 'Select';
//
//   @override
//   void initState() {
//     _currentPasswordController = TextEditingController();
//     _newPasswordController = TextEditingController();
//     _repeatPasswordController = TextEditingController();
//     super.initState();
//     reset();
//     if (widget.params.containsKey('username')) {
//       userNameController.text = widget.params['username'].toString();
//       userPasswordController.text = widget.params['password'].toString();
//       isChecked = true;
//       validate(context);
//     }
//   }
//
//   @override
//   void dispose() {
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _repeatPasswordController.dispose();
//     super.dispose();
//   }
//
//   // void setState(Null Function() param0) {}
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         children: [
//           TextFormField(
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.next,
//             cursorColor: kPrimaryColor,
//             onSaved: (email) {},
//             controller: userNameController,
//             decoration: const InputDecoration(
//               hintText: "User Name ",
//               prefixIcon: Padding(
//                 padding: EdgeInsets.all(defaultPadding),
//                 child: Icon(Icons.person),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: defaultPadding),
//             child: TextFormField(
//               inputFormatters: [
//                 FilteringTextInputFormatter.deny(RegExp(r'\s')),
//               ],
//               textInputAction: TextInputAction.done,
//               obscureText: _obscureText,
//               cursorColor: kPrimaryColor,
//               controller: userPasswordController,
//               decoration: InputDecoration(
//                 hintText: "password",
//                 suffixIcon: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _obscureText = !_obscureText;
//                     });
//                   },
//                   child: Icon(
//                       _obscureText ? Icons.visibility : Icons.visibility_off),
//                 ),
//                 prefixIcon: const Padding(
//                   padding: EdgeInsets.all(defaultPadding),
//                   child: Icon(Icons.lock),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//               height: 40,
//               margin: const EdgeInsets.all(2),
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: LightColors.kLightGray,
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//               child: Center(
//                   child: DropdownButtonHideUnderline(
//                 child: DropdownButton(
//                   style: LightColors.textSmallStyle,
//                   isExpanded: true,
//                   isDense: true,
//                   alignment: Alignment.center,
//                   // Reduces the dropdowns height by +/- 50%
//                   //icon: Icon(Icons.keyboard_arrow_down),
//                   value: chosenValue,
//                   items: options.map((item) {
//                     return DropdownMenuItem(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       chosenValue = value as String;
//                       debugPrint(chosenValue);
//                     });
//                   },
//                 ),
//                 //),
//               ))),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Material(
//                 color: Colors.white,
//                 child: Checkbox(
//                   value: isChecked,
//                   onChanged: (value) {
//                     //isChecked = value!;
//                     setState(() {
//                       isChecked = value!;
//                     });
//                   },
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (kIsWeb) {
//                     _launchURL();
//                   } else {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (BuildContext context) => getDeferredWidget(
//                             child: (context) =>
//                                 privacyPolicyScreen.PrivacyPolicyScreen(),
//                             loadLibrary: privacyPolicyScreen.loadLibrary())));
//                   }
//                 },
//                 child: const Text(
//                   'I have read and accept terms \nand conditions',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: defaultPadding),
//           ElevatedButton(
//             onPressed: () {
//               checkAuth();
//             },
//             child: Text(
//               "Login".toUpperCase(),
//               style: LightColors.textHeaderStyle13Selected,
//             ),
//           ),
//           const SizedBox(height: defaultPadding),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (BuildContext context) => getDeferredWidget(
//                             child: (context) =>
//                                 forgotPasswordPage.ForgotPasswordPage(),
//                             loadLibrary: forgotPasswordPage.loadLibrary())));
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     child: const Text(
//                       'Forgot Password?',
//                       style: TextStyle(color: AppColors.lightGray),
//                     ),
//                   )),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   _launchURL() async {
//     const url = 'https://www.kidzee.com/privacy-policy';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   reset() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('uid', '');
//     prefs.setString('userid', '');
//     prefs.setString(LocalConstant.KEY_DISPLAY_NAME, '');
//     prefs.setString(LocalConstant.KEY_USER_NAME, '');
//     prefs.setString(LocalConstant.KEY_USER_ID, '');
//     prefs.setString(LocalConstant.KEY_UID, '');
//     //debugPrint('UID is ${info.UID}');
//     prefs.setString(LocalConstant.KEY_USER_TYPE, '');
//     prefs.setString(LocalConstant.KEY_MOBILENO, '');
//     prefs.setString(LocalConstant.KEY_ACADEMICYEAR, '');
//     prefs.setString(LocalConstant.KEY_GUARDIAN_CONTACT, '');
//     prefs.setString(LocalConstant.KEY_CONE_CODE, '');
//     prefs.setString(LocalConstant.KEY_STATE_ID, '');
//     prefs.setString(LocalConstant.KEY_FRANCHISEE_TYPE, '');
//     prefs.setString(LocalConstant.KEY_IS_EXTERNAL_USER, '');
//     prefs.setString(LocalConstant.KEY_FRANCHISEE_ID, '');
//     prefs.setString(LocalConstant.KEY_USER_TYPE_NAME, '');
//     prefs.setString(LocalConstant.KEY_IS_ILLUM_KIT, '');
//     prefs.setString(LocalConstant.KEY_IS_KG_KIT, '');
//   }
//
// //   void getPentemindToken(bool is24) async {
// //     if (!isChecked) {
// //       Utility.alert(
// //           context, 'Alert', "Please accept the Terms and Conditions", this);
// //     } else if (userNameController.text.toString() != "" &&
// //         userPasswordController.text.toString() != "") {
// //       Utility.showLoaderDialog(context);
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String userName = userNameController.text.toString();
// //       String password = userPasswordController.text.toString();
// //       LoginRequestModel loginRequestModel = LoginRequestModel(
// //         User_Name: userName,
// //         User_Password: password,
// //         Device_id: '',
// //         Otp: '',
// //       );
// // //       debugPrint('--------282 Pentemind login');
// //       APIService apiService = APIService();
// //       apiService.getPentemindLogin(loginRequestModel, is24).then((value) {
// //         String image = '';
// //         if (value != null) {
// //           PentemindLoginResponse pentemindResponseModel =
// //               value as PentemindLoginResponse;
// //           debugPrint(pentemindResponseModel.success);
// //           if (pentemindResponseModel.success == 200) {
// //             if (pentemindResponseModel.token.isNotEmpty) {
// //               KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');
// //               prefs.setString(LocalConstant.KEY_UID,
// //                   pentemindResponseModel.data.UserID.toString());
// //               prefs.setString(LocalConstant.KEY_USER_ID,
// //                   pentemindResponseModel.data.EntityID.toString());
// //               prefs.setString(LocalConstant.KEY_USER_TYPE,
// //                   pentemindResponseModel.data.UserType);
// //               prefs.setString(
// //                   LocalConstant.KEY_APP_TOKEN, pentemindResponseModel.token);
// //               prefs.setString(LocalConstant.KEY_USER_PASSWORD,
// //                   userPasswordController.text.toString());
// //               prefs.setString(LocalConstant.KEY_USER_NAME, userName);
// //               if (pentemindResponseModel.data.EntityID > 0) {
// //                 prefs.setString(LocalConstant.KEY_USER_ID,
// //                     pentemindResponseModel.data.EntityID.toString());
// //               }
// //               if (pentemindResponseModel.data.DisplayName.isNotEmpty) {
// //                 prefs.setString(LocalConstant.KEY_DISPLAY_NAME,
// //                     pentemindResponseModel.data.DisplayName.toString());
// //               }
// //               KidzeePref().setString(LocalConstant.KEY_BUSINESS_ID,
// //                   pentemindResponseModel.data.businesssId.toString());
// //               try {
// //                 if (pentemindResponseModel.data.StudentData.isNotEmpty) {
// //                   prefs.setInt(LocalConstant.KEY_STUDENT_ID,
// //                       pentemindResponseModel.data.StudentData[0].StudentID);
// //                   prefs.setString(
// //                       LocalConstant.KEY_USER_AVTAR,
// //                       pentemindResponseModel
// //                           .data.StudentData[0].studentprofileURL);
// //                   prefs.setString(LocalConstant.KEY_STUDENT_NAME,
// //                       pentemindResponseModel.data.StudentData[0].StudentName);
// //                   prefs.setString(
// //                       LocalConstant.KEY_FRANCHISEE_ID,
// //                       pentemindResponseModel.data.StudentData[0].Franchisee_Id
// //                           .toString());
// //                 } else {
// //                   prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
// //                 }
// //               } catch (e) {
// //                 prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
// //                 debugPrint(e.toString());
// //               }
// //               bool isKes = false;
// //               isKes = false;// checkIsKES(pentemindResponseModel.data.program);
// //               prefs.setBool(LocalConstant.KEY_IS_KES, isKes);
// //               try {
// //                 if (pentemindResponseModel.data.StudentData.isNotEmpty) {
// //                   prefs.setInt(LocalConstant.KEY_STUDENT_ID,
// //                       pentemindResponseModel.data.StudentData[0].StudentID);
// //                   prefs.setString(
// //                       LocalConstant.KEY_USER_AVTAR,
// //                       pentemindResponseModel
// //                           .data.StudentData[0].studentprofileURL);
// //                   image = pentemindResponseModel
// //                       .data.StudentData[0].studentprofileURL;
// // //                   debugPrint('User Avtar -----');
// //                   debugPrint(pentemindResponseModel
// //                       .data.StudentData[0].studentprofileURL);
// //                 } else {
// //                   prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
// //                 }
// //               } catch (e) {
// //                 prefs.setInt(LocalConstant.KEY_STUDENT_ID, 0);
// //                 debugPrint(e.toString());
// //               }
// //               Navigator.of(context, rootNavigator: true).pop('dialog');
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                     builder: (context) =>
// //                         /*CenterSetupProgress(crnNumber: '123', displayName: 'Sudhir Patil',userId:'0',franchiseeid:36492)*/
// //                         MyHomePage(
// //                             profileImage: '',
// //                             title:
// //                                 '') /* getDeferredWidget(
// //                             child: (context) => homeScreen.MyHomePage(
// //                                 profileImage: '', title: ''),
// //                             loadLibrary: homeScreen.loadLibrary()) */
// //                     ),
// //               );
// //             } else {
// //               Navigator.of(context, rootNavigator: true).pop('dialog');
// //               Utility.alert(
// //                   context, 'Alert', 'Invalid User Name and Password', this);
// //             }
// //           } else {
// //             Navigator.of(context, rootNavigator: true).pop('dialog');
// //             Utility.alert(
// //                 context, 'Alert', 'Invalid User Name and Password', this);
// //           }
// //         } else {
// //           Navigator.of(context, rootNavigator: true).pop('dialog');
// //           Utility.alert(
// //               context, 'Alert', 'Invalid User Name and Password', this);
// //         }
// //
// //         ////debugPrint('Captured in Listener value is null' );
// //       });
// //     } else {
// //       userNameController.text = '';
// //       userPasswordController.text = '';
// //       Utility.showMessage(context, "Invalid User Name and Password");
// //     }
// //   }
//   //
//   // bool checkIsKES(List<ClassProgram> programs) {
//   //   for (var classModel in programs) {
//   //     if (classModel.curriculamType.isNotEmpty &&
//   //             classModel.curriculamType.toLowerCase() == 'k12' ||
//   //         classModel.curriculamType.toLowerCase() == 'kes') {
//   //       return true;
//   //       break;
//   //     }
//   //   }
//   //   return false;
//   // }
//
//   Future<void> handleLoginResponse(dynamic value) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // 1️⃣ API BYPASS case
//     if (chosenValue == '2024-2025' && value is String && value == 'API_BYPASS') {
//       FirebaseAnalyticsUtils.captureEvent('API_BYPASS');
//       Utility.hideDialog(context);
//       return;
//     }
//
//     // 2️⃣ Null response
//     if (value == null) {
//       Utility.hideDialog(context);
//       Utility.alert(context, 'Alert', "Something went wrong", this);
//       return;
//     }
//
//     // 3️⃣ FAILURE RESPONSE (401)
//     if (value is SecureLoginFailuarResponse) {
//       Utility.hideDialog(context);
//       Utility.alert(
//         context,
//         'Login Failed',
//         value.data!.msg!.isNotEmpty == true
//             ? value.data!.msg!
//             : "Incorrect username or password",
//         this,
//       );
//       return;
//     }
//
//     // 4️⃣ SUCCESS RESPONSE
//     if (value is SecureLoginResponseModel && value.data != null) {
//       SecureLoginResponseModel model = value;
//       final user = model.data!;
//
//       // Save values in Prefs
//       await prefs.setString(LocalConstant.KEY_APP_TOKEN, value.token ?? "");
//       await prefs.setString(LocalConstant.KEY_UID, user.userId.toString() ?? "0");
//       await prefs.setString(LocalConstant.KEY_USER_NAME, user.userName ?? "");
//       await prefs.setString(LocalConstant.KEY_USER_TYPE, user.userType ?? "");
//       await prefs.setString(LocalConstant.KEY_MOBILENO, user.mobileNo ?? "");
//       await prefs.setString(LocalConstant.KEY_DISPLAY_NAME, user.displayName ?? "");
//       await prefs.setString('contact_person', user.contactPerson ?? "");
//       await prefs.setString(LocalConstant.KEY_EMAILID, user.emailId ?? "");
//       await prefs.setString(LocalConstant.KEY_ZONE, user.zoneCode ?? "");
//       await prefs.setString(LocalConstant.KEY_FRANCHISEE_ID, user.franchiseeId.toString() ?? "0");
//       await prefs.setString(LocalConstant.KEY_TIRETYPE, user.tierType ?? "");
//       await prefs.setString(LocalConstant.KEY_TIRETYPE, user.tierName ?? "");
//       await prefs.setBool('Requested_IllumeKit', user.requestedIllumeKit ?? false);
//       await prefs.setBool('Requested_KGKit', user.requestedKGKit ?? false);
//       await prefs.setString(LocalConstant.KEY_COUNTRY_NAME, user.country ?? "");
//       await prefs.setString(LocalConstant.KEY_USER_PASSWORD, userPasswordController.text);
//
//       // UI updates
//       setState(() => isApiCallProcess = false);
//
//       Utility.hideDialog(context);
//
//       // 5️⃣ If Reset Password required
//       if (user.resetPassword == 1 || user.isReset == true) {
//         _showChangePasswordBottomSheet(context);
//         return;
//       }
//
//       // 6️⃣ OTP flow
//       if (user.isOTP == true) {
//         KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'false');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => getDeferredWidget(
//               child: (context) => otpPage.Otp(
//                 mobileNumber: user.mobileNo ?? '',
//                 userName: user.userName ?? '',
//               ),
//               loadLibrary: otpPage.loadLibrary(),
//             ),
//           ),
//         );
//         return;
//       }
//
//       // 7️⃣ Normal login success
//       KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');
//
//       if (false){ // || user.isCenterSetupInProgress == true) {
//         KidzeePref().setString(LocalConstant.KEY_IS_CENTER_SETUP, 'true');
//         KidzeePref().setString(LocalConstant.KEY_APP_TOKEN, 'true');
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => getDeferredWidget(
//               child: (context) => bpmsHome.BPMSHome(),
//               loadLibrary: bpmsHome.loadLibrary(),
//             ),
//           ),
//         );
//
//       } else {
//         KidzeePref().setString(LocalConstant.KEY_IS_CENTER_SETUP, 'false');
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => getDeferredWidget(
//               child: (context) =>
//                   pentemindSplash.PentemindSplashScreen(isKES: false),
//               loadLibrary: pentemindSplash.loadLibrary(),
//             ),
//           ),
//         );
//       }
//
//       return;
//     }
//
//     // 8️⃣ Any other case (Unknown response)
//     // Navigator.of(context, rootNavigator: true).pop('dialog');
//     Utility.hideDialog(context);
//     Utility.alert(
//       context,
//       'Alert',
//       "Unable to process login. Please try again.",
//       this,
//     );
//   }
//
//
//   void validate(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!isChecked) {
//       if (!mounted) return;
//       Utility.showMessage(context, "Please accept the Terms and Conditions");
//     } else if (userNameController.text.toString().trim() != "" &&
//         userPasswordController.text.toString().trim() != "" &&
//         chosenValue == 'Select') {
//       Utility.alert(context, 'Alert', "Please Select Academic Year", this);
//     } else if (userNameController.text.toString() != "" &&
//         userPasswordController.text.toString() != "") {
//       if (!mounted) return;
//       Utility.showLoaderDialog(context);
//       //Utility.showLoaderDialog(context);
//       LoginRequestModel loginRequestModel = LoginRequestModel(
//         User_Name: userNameController.text.toString(),
//         User_Password: userPasswordController.text.toString(),
//         Device_id: '',
//         Otp: '',
//       );
//       APIService apiService = APIService();
//       apiService
//           .secureLogin(loginRequestModel)
//           .then((value) async {
//         if (value != null) {
//           handleLoginResponse(value);
//         } else {
//           _currentPasswordController.text = '';
//           //Navigator.pop(context);
//           Utility.hideDialog(context);
//           Utility.alert(context, 'Alert', "Invalid User Name and Password", this);
//           //debugPrint("null value");
//         }
//       });
//     } else {
//       userNameController.text = '';
//       userPasswordController.text = '';
//       Utility.alert(context, 'Alert', "Invalid User Name and Password", this);
//     }
//   }
//
//   void validate1(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!isChecked) {
//       if (!mounted) return;
//       Utility.showMessage(context, "Please accept the Terms and Conditions");
//     } else if (userNameController.text.toString().trim() != "" &&
//         userPasswordController.text.toString().trim() != "" &&
//         chosenValue == 'Select') {
//       Utility.alert(context, 'Alert', "Please Select Academic Year", this);
//     } else if (userNameController.text.toString() != "" &&
//         userPasswordController.text.toString() != "") {
//       if (!mounted) return;
//       Utility.showLoaderDialog(context);
//       //Utility.showLoaderDialog(context);
//       LoginRequestModel loginRequestModel = LoginRequestModel(
//         User_Name: userNameController.text.toString(),
//         User_Password: userPasswordController.text.toString(),
//         Device_id: '',
//         Otp: '',
//       );
//       APIService apiService = APIService();
//       apiService
//           .secureLogin(loginRequestModel)
//           .then((value) async {
//         if (value != null) {
//           if (chosenValue == '2024-2025' &&
//               value is String &&
//               value == 'API_BYPASS') {
//             //API NOT WORKING BYPASS APIS
//             FirebaseAnalyticsUtils.captureEvent('API_BYPASS');
//           } else {
//             UserInfo info = value.root?.subroot?.UserDetails as UserInfo;
//             prefs.setString('uid', info.UID);
//             prefs.setString('userid', info.UserId);
//             prefs.setString(LocalConstant.KEY_COUNTRY_NAME, info.countryName);
//             prefs.setString(LocalConstant.KEY_DISPLAY_NAME, info.displayName);
//             prefs.setString(LocalConstant.KEY_USER_NAME, info.USERNAME);
//             prefs.setString(LocalConstant.KEY_USER_ID, info.UserId);
//             prefs.setString(LocalConstant.KEY_UID, info.UID);
//             //debugPrint('UID is ${info.UID}');
//             prefs.setString(LocalConstant.KEY_USER_TYPE, info.UserType);
//             prefs.setString(LocalConstant.KEY_MOBILENO, info.mobileNo);
//             prefs.setString(
//                 LocalConstant.KEY_ACADEMICYEAR, info.CurrentACADYear);
//             prefs.setString(
//                 LocalConstant.KEY_GUARDIAN_CONTACT, info.contactPerson);
//             prefs.setString(LocalConstant.KEY_CONE_CODE, info.ZoneCode);
//             prefs.setString(LocalConstant.KEY_STATE_ID, info.StateId);
//             prefs.setString(
//                 LocalConstant.KEY_FRANCHISEE_TYPE, info.FranchiseeType);
//             prefs.setString(
//                 LocalConstant.KEY_IS_EXTERNAL_USER, info.IsExternalUser);
//             prefs.setString(
//                 LocalConstant.KEY_FRANCHISEE_ID, info.FranchiseeId.toString());
// //             debugPrint('i login -----------FrID ${info.FranchiseeId}');
//             prefs.setString(
//                 LocalConstant.KEY_USER_TYPE_NAME, info.UserTypeName);
//             prefs.setString(
//                 LocalConstant.KEY_IS_ILLUM_KIT, info.RequestedIllumeKit);
//             prefs.setString(LocalConstant.KEY_IS_KG_KIT, info.RequestedKGKit);
//             prefs.setString(LocalConstant.KEY_USER_PASSWORD,
//                 userPasswordController.text.toString());
//
//             String userIds =
//                 prefs.getString(LocalConstant.KEY_DISPLAY_NAME) as String;
//
//             SurveyFirestore.addCompletedSurveyonLogintoOffline();
//             setState(() {
//               isApiCallProcess = false;
//
//               // // Save an integer value to 'counter' key.
//               prefs.setString(
//                   LocalConstant.KEY_USER_NAME, userNameController.text);
//             });
//
//             if (info.Msg == 'ChangePassword') {
//               Navigator.of(context, rootNavigator: true).pop('dialog');
//               _showChangePasswordBottomSheet(context);
//             } else if (info.Msg == 'Login successful') {
//               if (info.IsReset == '1') {
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//                 _showChangePasswordBottomSheet(context);
//               } else {
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//                 if (false && info.IsOTP == '1') {
//                   KidzeePref()
//                       .setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'false');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => getDeferredWidget(
//                           child: (context) => otpPage.Otp(
//                               mobileNumber: info.mobileNo,
//                               userName: info.USERNAME),
//                           loadLibrary: otpPage.loadLibrary()),
//                     ),
//                   );
//                 } else {
//                   KidzeePref()
//                       .setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');
//
//                   if (info.isCenterSetupInProgress == '1') {
//                     //Navigator.of(context, rootNavigator: true).pop('dialog');
//                     KidzeePref()
//                         .setString(LocalConstant.KEY_IS_CENTER_SETUP, 'true');
//                     KidzeePref().setString(LocalConstant.KEY_APP_TOKEN, 'true');
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => getDeferredWidget(
//                             child: (context) => bpmsHome.BPMSHome(),
//                             loadLibrary: bpmsHome.loadLibrary()),
//                       ),
//                     );
//                   } else {
//                     KidzeePref()
//                         .setString(LocalConstant.KEY_IS_CENTER_SETUP, 'false');
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => getDeferredWidget(
//                               child: (context) =>
//                                   pentemindSplash.PentemindSplashScreen(
//                                       isKES: false),
//                               loadLibrary: pentemindSplash.loadLibrary()),
//                         ));
//                   }
//                 }
//               }
//             } else {
//               //debugPrint('data not found');
//               Navigator.of(context, rootNavigator: true).pop('dialog');
//               Utility.alert(
//                   context,
//                   'Alert',
//                   info.Msg.isNotEmpty
//                       ? info.Msg
//                       : "Invalid User Name and Password",
//                   this);
//             }
//           }
//           //Navigator.of(context, rootNavigator: true).pop('dialog');
//         } else {
//           _currentPasswordController.text = '';
//           //Navigator.pop(context);
//           Navigator.of(context, rootNavigator: true).pop('dialog');
//           Utility.alert(
//               context, 'Alert', "Invalid User Name and Password", this);
//           //debugPrint("null value");
//         }
//       });
//     } else {
//       userNameController.text = '';
//       userPasswordController.text = '';
//       Utility.alert(context, 'Alert', "Invalid User Name and Password", this);
//     }
//   }
//
//   void changePassword(BuildContext context) async {
//     debugPrint(_newPasswordController.text.toString());
//     debugPrint(_repeatPasswordController.text.toString());
//     if (_newPasswordController.text.toString().trim().isEmpty ||
//         _repeatPasswordController.text.toString().trim().isEmpty) {
// //       debugPrint('empty password...');
//       _showAlertDialog(context, 'Alert', 'Please Enter the Password');
//     } else if (_newPasswordController.text.toString().trim() ==
//         _repeatPasswordController.text.toString().trim()) {
//       Utility.showLoaderDialog(context);
//       debugPrint('updatig the password...');
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String userType = pref.getString(LocalConstant.KEY_USER_TYPE) as String;
//       String userName = pref.getString(LocalConstant.KEY_USER_NAME) as String;
//       String userPassword =
//           pref.getString(LocalConstant.KEY_USER_PASSWORD) as String;
//       debugPrint('userName ${userName} old ${userPassword} new ${_newPasswordController.text.toString()}');
//       ChangePasswordRequest loginRequestModel = ChangePasswordRequest(
//         Username: userName,
//         OldPassword: userPassword,
//         newPassword: _newPasswordController.text.toString().trim(),
//         userType: userType,
//       );
//       debugPrint(loginRequestModel.toJson());
//       setState(() {
//         isApiCallProcess = true;
//       });
//       APIService apiService = APIService();
//       apiService.changePassword(loginRequestModel).then((value) async {
//         if (value != null) {
//           setState(() {
//             isApiCallProcess = false;
//           });
//           debugPrint("Response");
//           //ChangePasswordResponse response = ChangePasswordResponse.fromJson(jsonDecode(value.MSG));
//           debugPrint(value);
//           Navigator.of(context, rootNavigator: true).pop('dialog');
//           if (value.MSG == 'Password changed successfully') {
//             //_showAlertDialog(context, "SUCCESS", value.MSG);
//             isChecked = true;
//             userPasswordController.text =
//                 _newPasswordController.text.toString();
//             Utility.showMessage(context, value.MSG);
//           } else {
//             _showAlertDialog(context, "Alert", value.MSG);
//           }
//         } else {
//           _showAlertDialog(context, "Alert", 'Unable to update the Password--2');
//           //debugPrint("Value is null");
//         }
//         Navigator.pop(context);
//       });
//     } else {
//       Navigator.pop(context);
//       setState(() {
//         isApiCallProcess = false;
//       });
//       _showAlertDialog(
//           context, "Alert", 'Password and Repete password doesent match');
//     }
//   }
//
//   void _showChangePasswordBottomSheet(BuildContext context) {
//     var passwordBloc = PasswordBloc(passwordRepository: PasswordRepository());
//
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         isDismissible: true,
//         useSafeArea: true, // 👈 This is important
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(34), topRight: Radius.circular(34)),
//         ),
//         builder: (BuildContext context) => Padding(
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: BlocProvider<PasswordBloc>(
//                 create: (context) => passwordBloc,
//                 child: BlocBuilder<PasswordBloc, PasswordState>(
//                     bloc: passwordBloc,
//                     builder: (context, state) {
// //                       debugPrint('state acasklnasldnaskldn');
//                       if (state is PasswordChangedState) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           // close bottom sheet
//                           //Navigator.pop(context);
//                           Navigator.of(context, rootNavigator: true)
//                               .pop('dialog');
//                           _showAlertDialog(context, 'Success',
//                               'Password changed successfully');
//                           userPasswordController.text =
//                               _newPasswordController.text;
//                           validate(context);
//                           clearPasswordFields();
//                         });
//                       } else if (state is ChangePasswordErrorState) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           _showAlertDialog(
//                               context, 'Error', state.errorMessage);
//                         });
//                       }
//
//                       return Container(
//                         // height: 472,
//                         // padding: AppSizes.bottomSheetPadding,
//                         decoration: const BoxDecoration(
//                             color: AppColors.background,
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(34),
//                                 topRight: Radius.circular(34)),
//                             boxShadow: []),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 height: 6,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.lightGray,
//                                   borderRadius: BorderRadius.circular(3),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               const Text(
//                                 'Password Change',
//                                 style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(
//                                 height: 18,
//                               ),
//                               const SizedBox(
//                                 height: 18,
//                               ),
//                               EkidzeeInputField(
//                                 controller: _newPasswordController,
//                                 hint: 'New Password',
//                                 validator: (value) {
//                                   if (value == null) {
//                                     return null;
//                                   } else {
//                                     return 'Enter a valid Password';
//                                   }
//                                 },
//                                 error: state is EmptyNewPasswordState
//                                     ? 'field cannot be empty'
//                                     : state is InvalidNewPasswordState
//                                         ? 'password should be at least 6 characters'
//                                         : '',
//                               ),
//                               const SizedBox(
//                                 height: 18,
//                               ),
//                               EkidzeeInputField(
//                                 controller: _repeatPasswordController,
//                                 hint: 'Repeat New Password',
//                                 validator: (value) {
//                                   if (value == null) {
//                                     return null;
//                                   } else {
//                                     return 'Enter a valid Password';
//                                   }
//                                 },
//                                 error: state is EmptyRepeatPasswordState
//                                     ? 'field cannot be empty'
//                                     : state is PasswordMismatchState
//                                         ? 'password mismatch'
//                                         : '',
//                               ),
//                               const SizedBox(
//                                 height: 18,
//                               ),
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   shape: WidgetStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18.0),
//                                       side: const BorderSide(
//                                         color: Colors.teal,
//                                         width: 2.0,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Submit',
//                                   style: LightColors.textHeaderStyle13Selected,
//                                 ),
//                                 onPressed: () {
//                                    debugPrint('change password...');
//                                   changePassword(context);
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 48,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             ));
//   }
//
//   Future<void> _showAlertDialog(
//       BuildContext context, String title, String content) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(content),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//                 //Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void clearPasswordFields() {
//     _currentPasswordController.text = '';
//     _newPasswordController.text = '';
//     _repeatPasswordController.text = '';
//   }
//
//   @override
//   onChangePassword() {
//     changePassword(context);
//   }
//
//   @override
//   void onClick(int action, value) {
//     // TODO: implement onClick
//   }
//
//   void checkAuth() async {
//     Utility.showLoaderDialog(context);
//     bool isInternet = await Utility.isInternet();
//     Navigator.of(context, rootNavigator: true).pop('dialog');
//     if (isInternet) {
//       validate(context);
//     } else {
//       Utility.showMessageSingleButton(
//           context, 'Please Check Internet Connection', this);
//     }
//   }
// }
//
// class changePasswordInterface {
//   onChangePassword() {}
//   //String flag_image_url(){}
// }
