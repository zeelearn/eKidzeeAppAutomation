import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RememberMeWeb extends StatelessWidget {
  RememberMeWeb({super.key});

  final rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    // Show only on Web
    if (!kIsWeb) return const SizedBox.shrink();

    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: rememberMe.value,
            onChanged: (value) {
              rememberMe.value = value ?? false;
            },
          ),
          const SizedBox(width: 4),
          const Text(
            'Remember me',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
