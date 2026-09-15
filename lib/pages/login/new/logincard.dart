import 'dart:math';

import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/login/new/securelogin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Responsive.dart';
import '../../../utils/theme/colors/light_colors.dart';
import '../ui2/glass_container.dart';

class FlipLoginCard extends StatefulWidget {
  final LoginController loginController;
  //const LoginCard({super.key, required this.onForgotTap,required this.loginController});

  const FlipLoginCard({super.key, required this.loginController});

  @override
  State<FlipLoginCard> createState() => _FlipLoginCardState();
}

class _FlipLoginCardState extends State<FlipLoginCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  void toggleCard() {
    debugPrint('toggle card');
    if (_controller.isCompleted) {
      _controller.reverse();
      isLogin = true;
    } else {
      _controller.forward();
      isLogin = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * pi;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle),
          child: angle <= pi / 2
              ? LoginCard(
                  onForgotTap: toggleCard,
                  loginController: widget.loginController,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: ForgotPasswordCard(
                    onBackTap: toggleCard,
                    loginController: widget.loginController,
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LoginCard extends StatelessWidget {
  final VoidCallback onForgotTap;
  final LoginController loginController;
  const LoginCard(
      {super.key, required this.onForgotTap, required this.loginController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        //height: Get.height * 0.7,
        child: _BaseCard(
          child: GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                /*Center(
                    child: Image.asset(
                      'assets/icons/$AppFlavor/app_logo.png',
                      height: 78,

                    ),
                  ),*/
                const SizedBox(height: 12),
                const Text('Please log in to your account'),
                const SizedBox(height: 25),

                TextField(
                  controller: loginController.userNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'User Name',
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() => TextField(
                      controller: loginController.userPasswordController,
                      obscureText: !loginController.showPassword.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(loginController.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: loginController.togglePassword1,
                        ),
                      ),
                    )),

                const SizedBox(height: 16),

                Obx(() => DropdownButtonFormField(
                      value: loginController.chosenValue.value,
                      items: loginController.options
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => loginController.chosenValue.value = v!,
                      decoration:
                          const InputDecoration(labelText: 'Academic Year'),
                    )),

                const SizedBox(height: 10),

                // Obx(() => CheckboxListTile(
                //   value: loginController.isChecked.value,
                //   onChanged: (v) => loginController.isChecked.value = v!,
                //   title:  Text(
                //     'I have read and accept terms and conditions',
                //     style: TextStyle(fontSize: 13),
                //   ),
                //   controlAffinity: ListTileControlAffinity.leading,
                //   contentPadding: EdgeInsets.zero,
                // )),
                // CheckboxListTile(
                //   value: loginController.rememberMe.value,
                //   onChanged: (v) => loginController.rememberMe.value = v!,
                //   title: const Text("Remember Me"),
                //   controlAffinity: ListTileControlAffinity.leading,
                // ),

                Obx(() {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: loginController.isChecked.value,
                            onChanged: (value) {
                              loginController.isChecked.value = value ?? false;
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: 'I have read and accept '),
                                    TextSpan(
                                      text:
                                          'Terms & Conditions and Privacy Policy',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            loginController.openPrivacyPolicy(),
                                    ),
                                    // const TextSpan(text: ' and '),
                                    // TextSpan(
                                    //   text: 'Privacy Policy',
                                    //   style: const TextStyle(
                                    //     color: Colors.blue,
                                    //     fontWeight: FontWeight.w500,
                                    //     decoration: TextDecoration.underline,
                                    //   ),
                                    //   recognizer: TapGestureRecognizer()
                                    //     ..onTap = () => loginController.openPrivacyPolicy(),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (kIsWeb)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: loginController.rememberMe.value,
                              onChanged: (v) =>
                                  loginController.rememberMe.value = v!,
                            ),
                            Text('Remember Me'),
                          ],
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginController.validate,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'LOGIN',
                        style: LightColors.textHeaderStyleWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  //onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                  onPressed: onForgotTap,
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordCard extends StatelessWidget {
  final VoidCallback onBackTap;
  final LoginController loginController;
  const ForgotPasswordCard(
      {super.key, required this.onBackTap, required this.loginController});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Forgot Password",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Enter your username to reset password",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: loginController.userNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: 'User Name',
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => DropdownButtonFormField(
                value: loginController.chosenValue.value,
                items: loginController.options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => loginController.chosenValue.value = v!,
                decoration: const InputDecoration(labelText: 'Academic Year'),
              )),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: loginController.isLoading.value
                      ? LightColors.kLightGray1
                      : kPrimaryLightColor),
              onPressed: loginController.recoverPassword,
              child: Text(
                "SUBMIT",
                style: LightColors.textHeaderStyleWhite,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onBackTap,
            child: const Text("Back to Login"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          Responsive.isDesktop(context) ? Get.size.width / 3 : Get.width * 0.7,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
