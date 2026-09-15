import 'package:ekidzee/pages/tracker_indent/FilterUtils.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

const kPrimaryColor = Color(0xFFF44336);

const kAppVersion = "kidzee_2.8.3";
//const kPrimaryLightColor = Color(0xFF0277BD);

final kPrimaryLightColor = AppFlavor == 'kidzee'
    ? HexColor.fromHex('#65318e')
    : HexColor.fromHex('#2E3A90');
const kPrimaryTEXTBGColor = Color(0xFFEEEEEE);

const double defaultPadding = 16.0;

const kDefaultSpacing = 20.0;

const kWebBrand = "kidzee";
/* Notification Constant */

const String no_Notification_Animtion =
    'assets/json/no_notification_animation.json';
