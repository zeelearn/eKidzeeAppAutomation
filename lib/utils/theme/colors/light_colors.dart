import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightColors {
  static const Color primaryColor = Color.fromRGBO(86, 215, 188, 1);
  static const Color scaffoldBackgroundColor = Color.fromRGBO(245, 247, 249, 1);

  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color.fromARGB(255, 183, 218, 179);
  static const Color kGreen = Color(0xFF309397);
  static const Color kYallow = Color.fromARGB(255, 96, 219, 180);

  static const Color kDarkBlue = Color(0xFF0D253F);
  static const Color kLightBlue = Color(0xFFE8F5E9);
  static const Color kLightOrange = Color(0xFFFFE0B2);
  static const Color kDarkOrange = Color(0xFFFFCC80);
  static const Color kLightFULLDAY = Color(0xFFF1F8E9);
  static const Color kFULLDAY_BUTTON = Color(0xFFB2EBF2);
  static const Color kAbsent = Color(0xFFFBE9E7);
  static const Color kAbsent_BUTTON = Color(0xFFFFCDD2);
  static const Color kLightRed = Color(0xFFFFEBEE);

  static const Color kLightGray = Color(0xFFF5F5F5);
  static const Color kLightGray1 = Color(0xFFE0E0E0);
  static const Color kHeaderColor = Color.fromRGBO(234, 237, 237, 92);
  static const Color kLightGrayM = Color.fromRGBO(242, 243, 244, 95);
  static const Color kLightRedMaterial = Color.fromRGBO(250, 219, 216, 95);
  static const Color kLightGreenMaterial = Color.fromRGBO(169, 223, 191, 71);
  static const Color kLightBlueMaterial = Color.fromRGBO(52, 152, 219, 53);



  static const Color TextColor = Color.fromARGB(255, 14, 44, 83);
  //static const TextStyle pentemindTextStyle = TextStyle(color: TextColor,fontFamily: 'albertSans', fontSize: 16);
  static TextStyle textHeaderStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 18 : 16.0,
    color: const Color.fromARGB(255, 14, 44, 83),
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
  static TextStyle textHeaderStyleWhite = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 18 : 16.0,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  static TextStyle menuStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 18 : 14.0,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle hintTextStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 18 : 16.0,
    color: const Color(0xFF4B39EF),
    fontWeight: FontWeight.normal,
    backgroundColor: LightColors.kAbsent,
    height: 1.5,
  );

  static TextStyle textHeaderStyle16 = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 18 : 16.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

   static TextStyle textHeaderStyleSatisfy = GoogleFonts.satisfy(
    fontSize: kIsWeb ? 18 : 16.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle textHeaderStyle13 = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 15 : 13.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle textHeaderStyle13Selected = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 15 : 13.0,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  static TextStyle textHeaderStyle13Unselected = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 15 : 13.0,
    color: Colors.white24,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  static TextStyle textbigStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 20 : 18.0,
    color: LightColors.TextColor,
  );
  static TextStyle textSmallStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 16 : 12.0,
    color: LightColors.kDarkBlue,
    fontWeight: FontWeight.normal,
    height: 1,
  );

  static TextStyle textSmallHightliteStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 14 : 12.0,
    color: LightColors.kLightBlueMaterial,
    fontWeight: FontWeight.normal,
    height: 1,
  );
  static TextStyle textvSmallStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 14 : 8.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.normal,
    height: 1,
  );

  static TextStyle textsubtitle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 14 : 12.0,
    color: LightColors.kLightGrayM,
    fontWeight: FontWeight.normal,
    height: 1,
  );
  static TextStyle textStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 17 : 12.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static TextStyle textbuttonStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 20 : 18.0,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  static TextStyle subTextStyle = GoogleFonts.poppins(
    color: LightColors.TextColor,
    fontSize: 12.0,
  ) /*GoogleFonts.albertSans(
    fontSize: 10.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.w600,
    height: 1.5,
  )*/
      ;
  static TextStyle smallTextStyle = GoogleFonts.poppins(
    color: LightColors.TextColor,
    fontSize: kIsWeb ? 12 : 10.0,
  ) /*GoogleFonts.albertSans(
    fontSize: 10.0,
    color: LightColors.TextColor,
    fontWeight: FontWeight.w600,
    height: 1.5,
  )*/
      ;
  static TextStyle absentRoundedStyle = GoogleFonts.albertSans(
    fontSize: kIsWeb ? 14 : 12.0,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  //static const TextStyle pentemindTextStyle = TextStyle(color: TextColor,fontFamily: 'albertSans', fontSize: 16);
  //static const TextStyle pentemindSubTextStyle = TextStyle(color: TextColor,fontFamily: 'albertSans', fontSize: 12);
}
