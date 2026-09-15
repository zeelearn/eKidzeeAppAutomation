import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class KidzeeWidget {
  static Widget getRoundedText(
      String text, Color background, TextStyle style, int count) {
    return Container(
        padding: EdgeInsets.only(left: 2, right: 5, top: 2, bottom: 2),
        decoration: BoxDecoration(
            border: Border.all(
              color: LightColor.lightGrey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                color: background,
                padding: text.length > 5
                    ? EdgeInsets.all(5)
                    : EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  text,
                  style: style,
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              ' $count',
              style: LightColors.subTextStyle,
            ),
            SizedBox(
              width: 2,
            ),
          ],
        ));

    /*CircleAvatar(
      backgroundColor: background,
      child: Center(
        child: Text(
          text,
          style: style,
        ),
      ),
    );*/
  }
}
