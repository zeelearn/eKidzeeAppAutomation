// IIT-standard (clean architecture, null-safety, separation of concerns)
// Forgot Password Page using GetX
// Material UI/UX | Username-based Reset | Web & Mobile Friendly

import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/APIService.dart';
import '../../../api/request/forgotpassword_request.dart';
import '../../../api/response/pentemind/GenericResponse.dart';
import '../../../helper/KidzeePref.dart';
import '../../../helper/utils.dart';
import '../../../iface/onClick.dart';

// -------------------- Controller --------------------
class ForgotPasswordController extends GetxController
    with SingleGetTickerProviderMixin
    implements onClickListener {
  final usernameController = TextEditingController();

  final selectedYear = '2026'.obs;
  final isLoading = false.obs;

  final years = const ['2026', '2025'];

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));

    animationController.forward();
  }

  @override
  void onClose() {
    usernameController.dispose();
    animationController.dispose();
    super.onClose();
  }

  bool get isUsernameValid {
    return usernameController.text.trim().isNotEmpty;
  }

  void submit() async {
    if (!isUsernameValid) {
      Get.snackbar(
        backgroundColor: LightColors.kLightRed,
        colorText: LightColors.kDarkBlue,
        'Invalid Username',
        'Please enter your registered username',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    recoverPassword();

    // try {
    //   // TODO: Integrate Forgot Password API
    //   // Payload example:
    //   // { username, academicYear }
    //
    //   await Future.delayed(const Duration(seconds: 2));
    //
    //   Get.snackbar(
    //     'Request Sent',
    //     'Password reset instructions have been sent successfully',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //
    //   Get.back(); // Navigate to Login
    // } catch (e) {
    //   Get.snackbar(
    //     'Error',
    //     'Unable to process request. Please try again later.',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void recoverPassword() async {
    if (usernameController.text.isNotEmpty) {
      //Utility.showLoader();
      int shortYear = int.parse(
          selectedYear.value.substring(selectedYear.value.length - 2));
      debugPrint('short Year ${shortYear}');
      KidzeePref().saveAcademicYear(shortYear);
      ForgotPasswordRequest request =
          ForgotPasswordRequest(User_Name: usernameController.text);
      APIService apiService = APIService();
      await apiService.setAppUrl();
      apiService.forgotPassword(request).then((value) {
        if (value != null) {
          isLoading.value = false;
          GenericResponse response = value as GenericResponse;
          if (response.response[0].response.toString().contains('Invalid')) {
            Utility.alert(Get.context!, 'Alert ',
                response.response[0].response.toString(), this);
          } else {
            Utility.smsSendMessage(Get.context!, 'Success ',
                response.response[0].response.toString(), this);
            //goToLogin();
          }
        } else {
          isLoading.value = false;
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          //Utility.showMessages(Get.context!, 'Invalid User Name and Password');
          Get.snackbar(
            backgroundColor: LightColors.kLightRed,
            colorText: LightColors.kDarkBlue,
            'Error',
            'Invalid User Name',
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        ////debugPrint('Captured in Listener value is null' );
      });
    } else {
      isLoading.value = false;
      //Navigator.of(context, rootNavigator: true).pop('dialog');
      usernameController.text = '';
      //Utility.showMessage(Get.context!, "Please Enter Valid User Name");
      Get.snackbar(
        backgroundColor: LightColors.kLightRed,
        colorText: LightColors.kDarkBlue,
        'Error',
        'Please enter your registered username',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void goToLogin() {
    Get.back(); // or Get.offNamed('/login');
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OK) {
      if (value == 'Alert') {
      } else
        goToLogin();
    }
  }
}

// -------------------- UI Page --------------------
class ForgotPasswordPage1 extends StatelessWidget {
  ForgotPasswordPage1({super.key});

  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Forgot Password',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your username and academic year to reset your password.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 28),

                        // Username Field
                        TextField(
                          controller: controller.usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your username',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Academic Year Dropdown
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedYear.value,
                            items: controller.years
                                .map(
                                  (year) => DropdownMenuItem<String>(
                                    value: year,
                                    child: Text('Academic Year $year'),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedYear.value = value;
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Academic Year',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Submit Button
                        Obx(
                          () => FilledButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submit,
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Send Reset Link'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Back to Login
                        TextButton(
                          onPressed: controller.goToLogin,
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
