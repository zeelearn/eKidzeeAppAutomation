import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';
import 'package:get/get.dart';
class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kIsWeb ? SizedBox(
          width: kIsWeb ? Get.width * 0.3 : 200,
          child: Row(
            children: [
              // const Spacer(),
              Expanded(
                child: Image.asset('assets/icons/$AppFlavor/app_logo.png',width: 200,
                    fit: BoxFit.fitWidth),
              ),
              // const Spacer(),
            ],
          ),
        ) :
        Align(
          child: SizedBox(
            width: 200,
            child: Image.asset('assets/icons/$AppFlavor/app_logo.png',
              width: 100,),
          ),
        ),
        SizedBox(height: 50,)
        // const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
