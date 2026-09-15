import 'package:ekidzee/pages/login/new/securelogin.dart';
import 'package:ekidzee/pages/login/ui2/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Responsive.dart';
import '../../../globals.dart';
import '../../../utils/theme/colors/light_colors.dart';
import '../new/logincard.dart';
import 'app_background.dart';
import 'glass_container.dart';

class LoginScreenV2 extends StatelessWidget {
  const LoginScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return BackgroundScaffold(
        body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: false ? Center(
                child: FlipLoginCard(loginController: controller,),) : Responsive.isDesktop(context)
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Center(child: _leftBanner()),
                  // Expanded(
                  //   child: Center(child: KidzeeLoginHeader()),
                  // ),
                  Flexible(flex: 1, child: Container()),
                  Flexible(flex: 10, child: Center(child: KidzeeLoginHeader())),
                  Flexible(flex: 2, child: Container()),
                  //Flexible(flex: 8, child: _loginForm(controller)),
                  Flexible(flex: 8, child: Center(
                    child: FlipLoginCard(loginController: controller,),)
                  ),
                  Flexible(flex: 1, child: Container()),
                  //SizedBox(width: 28,)
                ],
              )
                  : _loginForm(controller),
            ),
          ),
    );
  }

  Widget _leftBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'KIDZEE',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 10),
        Text('Nurturing Gen-Next'),
      ],
    );
  }

  Widget _loginForm(LoginController controller) {
    return GlassContainer(
      child: SizedBox(
        width: 380,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/$AppFlavor/app_logo.png',
                height: 78,

              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Please log in to your account'),
            const SizedBox(height: 25),


            TextField(
              controller: controller.userNameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: 'User Name',
              ),
            ),

            const SizedBox(height: 16),

            Obx(() => TextField(
              controller: controller.userPasswordController,
              obscureText: !controller.showPassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(controller.showPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: controller.togglePassword1,
                ),
              ),
            )),

            const SizedBox(height: 16),

            Obx(() => DropdownButtonFormField(
              value: controller.chosenValue.value,
              items: controller.options
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => controller.chosenValue.value = v!,
              decoration: const InputDecoration(labelText: 'Academic Year'),
            )),

            const SizedBox(height: 10),

            Obx(() => CheckboxListTile(
              value: controller.isChecked.value,
              onChanged: (v) => controller.isChecked.value = v!,
              title: const Text(
                'I have read and accept terms and conditions',
                style: TextStyle(fontSize: 13),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.validate,
                child:  Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('LOGIN',style: LightColors.textHeaderStyleWhite,),
                ),
              ),
            ),

            TextButton(
              //onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
              onPressed: () {
                Get.to(ForgotPasswordScreenV2());
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}


class KidzeeLoginHeader extends StatelessWidget {
  const KidzeeLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,

      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/bg_purple.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: SizedBox(
        height: size.height * .06,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// LOGO
            ///
            const SizedBox(height: 20),
            Image.asset(
              'assets/icons/$AppFlavor/app_logo.png',
              height: 118,

            ),

             //const SizedBox(height: 8),
            //
            // /// TAGLINE
            // const Text(
            //   'NURTURING GEN-NEXT',
            //   style: TextStyle(
            //     letterSpacing: 1.5,
            //     fontSize: 12,
            //     color: Color(0xFF6A3FA0),
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            //
            // const SizedBox(height: 30),

            /// WELCOME TEXT
            const Text(
              'Welcome to Kidzee!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B2C7A),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            /// SUB TEXT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                'Log in to access your account.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6E5A8A),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 18),

            /// ILLUSTRATION
            // Image.asset(
            //   'assets/images/kids_illustration.png',
            //   height: size.height * 0.5,
            //   //maxWidth: 320,
            // ),
          ],
        ),
      ),
    );
  }
}

