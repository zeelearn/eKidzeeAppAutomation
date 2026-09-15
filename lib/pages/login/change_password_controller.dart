import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/APIService.dart';
import '../../api/request/resetpassword_request.dart';
import '../../api/response/pentemind/GenericResponse.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/utils.dart';
import '../../iface/onClick.dart';

class ChangePasswordController extends GetxController implements onClickListener {
  final RxString userName = ''.obs;
  final RxString userType = ''.obs;
  final RxBool isLoading = false.obs;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool oldPasswordVisibility = true.obs;
  final RxBool newPasswordVisibility = true.obs;
  final RxBool confirmPasswordVisibility = true.obs;

  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString(LocalConstant.KEY_USER_NAME) ?? '';
    userType.value = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? '';
  }

  void toggleOldPasswordVisibility() => oldPasswordVisibility.value = !oldPasswordVisibility.value;
  void toggleNewPasswordVisibility() => newPasswordVisibility.value = !newPasswordVisibility.value;
  void toggleConfirmPasswordVisibility() => confirmPasswordVisibility.value = !confirmPasswordVisibility.value;

  Future<void> resetPassword() async {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      Utility.showMessages(Get.context!, 'Please Enter your current password');
      return;
    }
    if (newPassword.isEmpty) {
      Utility.showMessages(Get.context!, 'Please Enter your new password');
      return;
    }
    if (confirmPassword.isEmpty) {
      Utility.showMessages(Get.context!, 'Please Re-Enter your new password');
      return;
    }
    if (newPassword != confirmPassword) {
      Utility.showMessages(Get.context!, 'New password and Confirm password do not match');
      return;
    }
    if (oldPassword == newPassword) {
      Utility.showMessages(Get.context!, 'The Current password and New password must be different');
      return;
    }

    isLoading.value = true;
    try {
      ResetPasswordRequest request = ResetPasswordRequest(
          userName: userName.value,
          oldPassword: oldPassword,
          newPassword: newPassword,
          userType: userType.value);
      
      APIService apiService = APIService();
      final value = await apiService.resetPassword(request);
      
      if (value != null) {
        GenericResponse response = value as GenericResponse;
        String msg = response.response[0].response.toString();
        if (msg.toLowerCase().contains('invalid') || msg.toLowerCase().contains('cannot')) {
          Utility.alert(Get.context!, 'Alert', msg, this);
        } else {
          Utility.smsSendMessage(Get.context!, 'Success', msg, this);
        }
      } else {
        Utility.showMessages(Get.context!, 'Unable to reset the password. Please try again later.');
      }
    } catch (e) {
      Utility.showMessages(Get.context!, 'Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClick(int action, value) {

      if (action == 1) { // Success case from Utility.smsSendMessage usually
         Get.back();
      }
  }

  // @override
  // void onClick(int id, BuildContext context) {
  //   if (id == 1) { // Success case from Utility.smsSendMessage usually
  //      Get.back();
  //   }
  // }
}
