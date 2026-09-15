import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controllerv2.dart';
import 'glass_container.dart';

class ForgotPasswordScreenV2 extends StatelessWidget {
  const ForgotPasswordScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthControllerV2>();

    return Scaffold(
      body: Center(
        child: GlassContainer(
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your username to receive reset link',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: controller.forgotController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'User Name',
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.forgotPassword,
                    child: const Text('SEND RESET LINK'),
                  ),
                ),

                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back to Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
