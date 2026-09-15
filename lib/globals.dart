library;

import 'package:ekidzee/Environment.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

EnvironmentType? environmentType;

String? AppFlavor = "kidzee";
String? appVersion;

footer() {
  return Container(
    color: LightColors.kLightGrayM,
    child: Text(
      kIsWeb
          ? 'Powered By ZeeLearn Ltd v$kAppVersion'
          : 'app version : $appVersion',
      style: LightColors.textvSmallStyle,
      textAlign: TextAlign.center,
    ),
  );
}

footerTrans() {
  return Container(
    child: Text(
      kIsWeb
          ? 'Powered By ZeeLearn Ltd v$kAppVersion'
          : 'app version : $appVersion',
      style: LightColors.textvSmallStyle,
      textAlign: TextAlign.center,
    ),
  );
}

footerPEN() {
  return Container(
    color: LightColors.kLightGreen,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget()
              .richText('P = Progressing', LightColors.textvSmallStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget()
              .richText('E = Needs Encouragement', LightColors.textvSmallStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget().richText(
              'N = Not Assessing at this time', LightColors.textvSmallStyle),
        ),
      ],
    ),
  );
}

footerKESLG() {
  return Container(
    color: LightColors.kLightGreen,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child:
              MyWidget().richText('BG = Beginner', LightColors.textvSmallStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget()
              .richText('PG = Progressive', LightColors.textvSmallStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget()
              .richText('PF = Proficient', LightColors.textvSmallStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MyWidget()
              .richText('NA = Not Applicable', LightColors.textvSmallStyle),
        ),
      ],
    ),
  );
}

convertStringJson(json, key) {
  return json.containsKey(key) && json[key] != null ? json[key] ?? '' : '';
}

convertintJson(json, key) {
  return json.containsKey(key) && json[key] != null ? json[key] ?? 0 : 0;
}

convertBoolJson(json, key) {
  return json.containsKey(key) && json[key] != null
      ? json[key] ?? false
      : false;
}
