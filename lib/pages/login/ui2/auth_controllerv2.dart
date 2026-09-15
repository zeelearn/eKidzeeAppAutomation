import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthControllerV2 extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotController = TextEditingController();

  var showPassword = false.obs;
  var acceptTerms = false.obs;
  var selectedYear = '2025-2026'.obs;

  final years = ['2024-2025', '2025-2026', '2026-2027'];

  void togglePassword() {
    showPassword.value = !showPassword.value;
  }

  void login() {
    if (!acceptTerms.value) {
      Get.snackbar('Terms Required', 'Please accept terms and conditions');
      return;
    }

    Get.snackbar(
      'Login Success',
      'Welcome ${usernameController.text}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void forgotPassword() {
    Get.snackbar(
      'Password Reset',
      'Reset link sent to ${forgotController.text}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }



  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    forgotController.dispose();
    super.onClose();
  }
}
