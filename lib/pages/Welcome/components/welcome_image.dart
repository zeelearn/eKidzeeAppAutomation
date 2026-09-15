import 'package:flutter/material.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "WELCOME TO Kidzee",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding * 3),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 3,
              child: Image(image: AssetImage('assets/icons/app_logo.png')),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 4),
      ],
    );
  }
}