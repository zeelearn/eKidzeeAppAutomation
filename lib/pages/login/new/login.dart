import 'package:ekidzee/pages/login/new/securelogin.dart';
import 'package:ekidzee/theme/app_theme.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saathi/core/theme/theme.dart';

import '../../../Responsive.dart';
import '../../../theme/app_text_theme.dart';
import '../../Login/components/login_screen_top_image.dart';
import '../../components/background.dart';
import 'forgot.dart';

class KidzeeLogin extends StatelessWidget {
  KidzeeLogin({super.key});

  final controller = Get.put(LoginController());

  Column mobileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SingleChildScrollView(
          child: LoginScreenTopImage(),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: content(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Row desktopScreen() {
    return Row(
      children: [
        Expanded(
          child: LoginScreenTopImage(),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 450,
                child: content(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Form content() {
    return Form(
      child: SingleChildScrollView(
        //padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------------- USERNAME ----------------
            TextFormField(
              controller: controller.userNameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              // decoration: InputDecoration(
              //   labelText: 'Username',
              //   prefix: Icon(Icons.person),
              //   filled: true,
              //   fillColor: Colors.grey.shade200,
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              // ),
              decoration: InputDecoration(
                hintText: "User Name",
                //prefix: Icon(Icons.person),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(1),
                  child: Icon(Icons.person),
                ),
                contentPadding: EdgeInsets.all(10),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
                filled: true,
                //fillColor: lightColors.surface,
                fillColor: Colors.grey.shade200, // textbox background color
                focusColor: Colors.grey.shade200, // textbox background color
                enabledBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 0,
                  ),
                ),
                //focusedBorder: InputBorder.none,
                //errorBorder: InputBorder.none,
                //disabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 0,
                  ),
                ),
                errorStyle:
                    AppTextTheme.bodySmall.copyWith(color: lightColors.error),
                hoverColor: Colors.grey.shade200,
                helperStyle: AppTextTheme.bodySmall
                    .copyWith(color: lightColors.onSurfaceVariant),
                hintStyle: AppTextTheme.bodyMedium
                    .copyWith(color: lightColors.onSurfaceVariant),
                focusedErrorBorder: lightColors.error.getOutlineBorder,
                errorBorder: lightColors.error.getOutlineBorder,
                //focusedBorder: Colors.transparent.getOutlineBorder,
                iconColor: lightColors.onSurfaceVariant,
                //enabledBorder: Colors.transparent.getOutlineBorder,
                //disabledBorder: Colors.transparent.getOutlineBorder,
                errorMaxLines: 1,
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- PASSWORD ----------------
            Obx(
              () => TextFormField(
                controller: controller.userPasswordController,
                obscureText: controller.obscureText.value,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                onFieldSubmitted: (value) {
                  debugPrint('Enter pressed: $value');
                  controller.validate();
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  // prefixIcon: const Padding(
                  //   padding: EdgeInsets.all(16),
                  //   child: Icon(Icons.lock),
                  // ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(1),
                    child: Icon(Icons.person),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  filled: true,
                  //fillColor: lightColors.surface,
                  fillColor: Colors.grey.shade200, // textbox background color
                  focusColor: Colors.grey.shade200, // textbox background color
                  enabledBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  //focusedBorder: InputBorder.none,
                  //errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 0,
                    ),
                  ),
                  errorStyle:
                      AppTextTheme.bodySmall.copyWith(color: lightColors.error),
                  hoverColor: Colors.grey.shade200,
                  helperStyle: AppTextTheme.bodySmall
                      .copyWith(color: lightColors.onSurfaceVariant),
                  hintStyle: AppTextTheme.bodyMedium
                      .copyWith(color: lightColors.onSurfaceVariant),
                  focusedErrorBorder: lightColors.error.getOutlineBorder,
                  errorBorder: lightColors.error.getOutlineBorder,
                  //focusedBorder: Colors.transparent.getOutlineBorder,
                  iconColor: lightColors.onSurfaceVariant,
                  //enabledBorder: Colors.transparent.getOutlineBorder,
                  //disabledBorder: Colors.transparent.getOutlineBorder,
                  errorMaxLines: 1,
                  suffixIcon: GestureDetector(
                    onTap: controller.togglePassword,
                    child: Icon(
                      controller.obscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- DROPDOWN ----------------
            Obx(
              () => Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.chosenValue.value,
                    isExpanded: true,
                    items: controller.options.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.chosenValue.value = value!;
                      controller.setAcademicYear();
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- CHECKBOX ----------------
            Obx(
              () => Row(
                children: [
                  Checkbox(
                    value: controller.isChecked.value,
                    onChanged: (value) {
                      controller.isChecked.value = value!;
                    },
                  ),
                  GestureDetector(
                    onTap: controller.openPrivacyPolicy,
                    child: const Text(
                      'I have read and accept terms and conditions',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const SizedBox(height: 15),
            //     RememberMeWeb(),
            //
            //     // Login button...
            //   ],
            // ),

            const SizedBox(height: 15),
            // ---------------- LOGIN BUTTON ----------------
            ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : controller.checkAuth,
              child: Text(
                "LOGIN",
                style: LightColors.textHeaderStyleWhite,
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- FORGOT PASSWORD ----------------
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  // Navigation to forgot page
                  Navigator.of(Get.context!).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ForgotPasswordPage1() /* getDeferredWidget(
                          child: (context) =>
                              forgotPasswordPage.ForgotPasswordPage(),
                          loadLibrary: forgotPasswordPage.loadLibrary()) */
                      ));
                },
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: mobileScreen(),
          desktop: desktopScreen(),
        ),
      ),
    );
  }
}
