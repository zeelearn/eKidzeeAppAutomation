import 'package:ekidzee/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../utils/theme/colors/light_colors.dart';
import 'app_text_theme.dart';
import 'extensions/app_colors.dart';
import 'extensions/asset_tile_style.dart';
import 'extensions/chart_style.dart';
import 'extensions/transaction_tile_style.dart';

class ChristmasTheme {
  const ChristmasTheme._();

  /// colors and styles
  static AppColors get darkColors => AppColors(
        brightness: Brightness.dark,
        primary: kPrimaryLightColor,
        onPrimary: const Color(0xFF002231),
        secondary: const Color(0xFF8859FF),
        onSecondary: const Color(0XFFFFFFFF),
        background: const Color(0xFF002231),
        onBackground: const Color(0xFFFFFFFF),
        surface: const Color(0xFF002E42),
        onSurface: const Color(0xFFFFFFFF),
        surfaceVariant: const Color(0xFF406271),
        onSurfaceVariant: const Color(0xFFBFCBD0),
        success: const Color(0xFF27BA62),
        onSuccess: const Color(0xFFFFFFFF),
        error: const Color(0xFFED4460),
        onError: const Color(0xFFFFFFFF),

        /// Custom colors
        tileBackgroundColor: const Color(0XFF002E42),
        defaultText: const Color(0XFFFFFFFF),
        lightText: const Color(0XFFBFCBD0),
        defaultIcon: const Color(0XFFBFCBD0),
        disabledIcon: const Color(0XFF8097A0),
        disabledSurface: const Color(0XFF8097A0),
        onDisabledSurface: const Color(0XFFBFCBD0),
        linearGradient: const LinearGradient(
          colors: [
            Color(0xFFC55F84),
            Color(0xFFC55F84),
            Color(0xFFC55F84),
          ],
        ),
      );

  static AppColors get lightColors => const AppColors(
        brightness: Brightness.dark,
        primary: Colors.white,
        onPrimary: Color(0xFF002231),
        secondary: Color(0xFF8859FF),
        onSecondary: Color(0XFFFFFFFF),
        background: Color(0xFFFFFFFF),
        onBackground: Color(0xFF002E42),
        surface: Color(0xFFF2F5F6),
        onSurface: Color(0xFF002E42),
        surfaceVariant: Color(0xFFF2F5F6),
        onSurfaceVariant: Color(0xFF667C86),
        success: Color(0xFF27BA62),
        onSuccess: Color(0xFFFFFFFF),
        error: Color(0xFFDB1A3A),
        onError: Color(0xFFFFFFFF),

        /// Custom colors
        tileBackgroundColor: Color(0xFFF2F5F6),
        defaultText: Color(0XFF002E42),
        lightText: Color(0XFF667C86),
        defaultIcon: Color(0XFFBFCBD0),
        disabledIcon: Color(0XFF8097A0),
        disabledSurface: Color(0XFFD2DBDE),
        onDisabledSurface: Color(0XFFA0B1B8),
        linearGradient: LinearGradient(
          colors: [
            Color(0xFFC55F84),
            Color(0xFFC55F84),
            Color(0xFFC55F84),
          ],
        ),
      );

  static TransactionTileStyle get transactionTileStyleDark =>
      TransactionTileStyle(
        backgroundColor: darkColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static TransactionTileStyle get transactionTileStyleLight =>
      TransactionTileStyle(
        backgroundColor: lightColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static AssetTileStyle get assetTileStyleDark => AssetTileStyle(
        backgroundColor: darkColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static AssetTileStyle get assetTileStyleLight => AssetTileStyle(
        backgroundColor: lightColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static FLChartStyle get chartStyleDark => FLChartStyle(
        backgroundColor: darkColors.surface,
        chartColor1: darkColors.linearGradient.colors[0],
        chartColor2: darkColors.linearGradient.colors[1],
        chartColor3: darkColors.linearGradient.colors[2],
        chartBorderColor: darkColors.surfaceVariant,
        toolTipBgColor: darkColors.onSurfaceVariant,
        isShowingMainData: true,
        animationDuration: const Duration(milliseconds: 100),
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
        borderRadius: 12,
      );

  static FLChartStyle get chartStyleLight => FLChartStyle(
        backgroundColor: darkColors.surface,
        chartColor1: darkColors.linearGradient.colors[0],
        chartColor2: darkColors.linearGradient.colors[1],
        chartColor3: darkColors.linearGradient.colors[2],
        chartBorderColor: darkColors.surfaceVariant,
        toolTipBgColor: darkColors.onSurfaceVariant,
        isShowingMainData: false,
        animationDuration: const Duration(milliseconds: 100),
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
        borderRadius: 12,
      );

  /// theme
  static ThemeData get darkTheme {
    return ThemeData(
      unselectedWidgetColor: Colors.black38,

      /// COLOR
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: darkColors.brightness,
        primary: darkColors.primary,
        onPrimary: darkColors.onPrimary,
        secondary: darkColors.secondary,
        onSecondary: darkColors.onSecondary,
        error: darkColors.error,
        onError: darkColors.onError,
        surface: darkColors.surface,
        onSurface: darkColors.onSurface,
        //surfaceContainerHighest: darkColors.surfaceVariant,
        onSurfaceVariant: darkColors.onSurfaceVariant,
      ),

      scaffoldBackgroundColor: darkColors.background,
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.blue),
        fillColor: WidgetStateProperty.all(kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.red),
        side: BorderSide(color: kPrimaryLightColor),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.red),
      ),

      /// TYPOGRAPHY
      textTheme: AppTextTheme.darkTextTheme,
      iconTheme: IconThemeData(
        color: darkColors.defaultIcon,
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkColors.background,
        foregroundColor: darkColors.onBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme.labelMedium.copyWith(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: darkColors.onSurface),
          foregroundColor: darkColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColors.surface,
        errorStyle: AppTextTheme.bodySmall.copyWith(color: darkColors.error),
        helperStyle:
            AppTextTheme.bodySmall.copyWith(color: darkColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: darkColors.onSurfaceVariant),
        focusedErrorBorder: darkColors.error.getOutlineBorder,
        errorBorder: darkColors.error.getOutlineBorder,
        focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: darkColors.onSurfaceVariant,
        enabledBorder: Colors.transparent.getOutlineBorder,
        disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: darkColors.primary,
        unselectedLabelColor: darkColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: darkColors.primary,
              width: 2,
            ),
          ),
        ),
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        darkColors,
        assetTileStyleDark,
        transactionTileStyleDark,
        chartStyleDark,
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      canvasColor: Colors.white,
      unselectedWidgetColor: Colors.black38,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      // brightness: Brightness.light,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextTheme.labelMedium.copyWith(color: darkColors.primary),
      ),

      datePickerTheme: DatePickerThemeData(
        //cancelButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(LightColors.kRed),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)) ),
        //confirmButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)) ),
        //dayBackgroundColor: MaterialStateProperty.all(Colors.white),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kPrimaryLightColor; // Your desired selected day color
          }
          return Colors.white; // Default unselected day color
        }),
        headerBackgroundColor: kPrimaryLightColor,
        headerForegroundColor: Colors.white,
        headerHeadlineStyle: LightColors.textHeaderStyleWhite,
        headerHelpStyle: LightColors.textHeaderStyleWhite,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      cardColor: Color.lerp(Colors.blueAccent, Colors.white, 1),
      cardTheme: CardThemeData(
        shadowColor: LightColors.kLightGray1,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),

      /// TYPOGRAPHY
      textTheme: TextTheme(),
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.white70),
        side: BorderSide(color: kPrimaryLightColor),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(LightColors.kLightGray1),
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: kPrimaryLightColor, // AppBar background
        foregroundColor: Colors.white, // Icon & text color
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimaryLightColor, // Set the status bar background

          statusBarIconBrightness:
              Brightness.light, // Set status bar icon color to white
          statusBarBrightness: Brightness.light, // Only for iOS
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: kPrimaryLightColor,
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Note: use foregroundColor for text color
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        //fillColor: lightColors.surface,
        fillColor: Colors.grey.shade200, // textbox background color
        focusColor: Colors.grey.shade200, // textbox background color

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: AppTextTheme.bodySmall.copyWith(color: lightColors.error),
        hoverColor: Colors.grey.shade200,
        helperStyle: AppTextTheme.bodySmall
            .copyWith(color: lightColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: lightColors.onSurfaceVariant),
        focusedErrorBorder: lightColors.error.getOutlineBorder,
        errorBorder: lightColors.error.getOutlineBorder,
        //focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: lightColors.onSurfaceVariant,
        //enabledBorder: Colors.transparent.getOutlineBorder,
        //disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: lightColors.primary,
        unselectedLabelColor: lightColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightColors.primary,
              width: 2,
            ),
          ),
        ),
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        lightColors,
        assetTileStyleLight,
        transactionTileStyleLight,
        chartStyleLight,
      ],
      // colorScheme: ColorScheme(
      //   brightness: lightColors.brightness,
      //   primary: kPrimaryLightColor.withOpacity(0.5),
      //   onPrimary: kPrimaryLightColor,
      //   secondary: kPrimaryLightColor,
      //   onSecondary: lightColors.onSecondary,
      //   error: lightColors.error,
      //   onError: lightColors.onError,
      //   surface: lightColors.surface,
      //   onSurface: lightColors.onSurface,
      //   //surfaceContainerHighest: lightColors.surfaceVariant,
      //   onSurfaceVariant: lightColors.onSurfaceVariant,
      // ).copyWith(surface: Colors.white).copyWith(surface: Colors.grey),
    );
  }

  static ThemeData get octaveTheme {
    return ThemeData(
      canvasColor: Colors.white,
      unselectedWidgetColor: Colors.black38,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      // brightness: Brightness.light,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextTheme.labelMedium.copyWith(color: darkColors.primary),
      ),
      datePickerTheme: DatePickerThemeData(
        //cancelButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(LightColors.kRed),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)) ),
        //confirmButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)) ),
        //dayBackgroundColor: MaterialStateProperty.all(Colors.white),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kPrimaryLightColor; // Your desired selected day color
          }
          return Colors.white; // Default unselected day color
        }),
        headerBackgroundColor: kPrimaryLightColor,
        headerForegroundColor: Colors.white,
        headerHeadlineStyle: LightColors.textHeaderStyleWhite,
        headerHelpStyle: LightColors.textHeaderStyleWhite,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      cardColor: Color.lerp(Colors.blueAccent, Colors.white, 1),
      cardTheme: CardThemeData(
        shadowColor: LightColors.kLightGray1,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),

      /// TYPOGRAPHY
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          // Header text (like AppBar title)
          color: kPrimaryLightColor, // Change as needed
        ),
        bodySmall: TextStyle(
          // Subtext
          color: kPrimaryLightColor, // Change as needed
          fontSize: 16,
        ),
      ),
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.white70),
        side: BorderSide(color: kPrimaryLightColor),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.red),
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: kPrimaryLightColor, // AppBar background
        foregroundColor: Colors.white, // Icon & text color
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Set the status bar background

          statusBarIconBrightness:
              Brightness.light, // Set status bar icon color to white
          statusBarBrightness: Brightness.light, // Only for iOS
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Note: use foregroundColor for text color
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColors.surface,
        errorStyle: AppTextTheme.bodySmall.copyWith(color: lightColors.error),
        helperStyle: AppTextTheme.bodySmall
            .copyWith(color: lightColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: lightColors.onSurfaceVariant),
        focusedErrorBorder: lightColors.error.getOutlineBorder,
        errorBorder: lightColors.error.getOutlineBorder,
        focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: lightColors.onSurfaceVariant,
        enabledBorder: Colors.transparent.getOutlineBorder,
        disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: lightColors.primary,
        unselectedLabelColor: lightColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightColors.primary,
              width: 2,
            ),
          ),
        ),
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        lightColors,
        assetTileStyleLight,
        transactionTileStyleLight,
        chartStyleLight,
      ],
      // colorScheme: ColorScheme(
      //   brightness: lightColors.brightness,
      //   primary: kPrimaryLightColor.withOpacity(0.5),
      //   onPrimary: kPrimaryLightColor,
      //   secondary: kPrimaryLightColor,
      //   onSecondary: lightColors.onSecondary,
      //   error: lightColors.error,
      //   onError: lightColors.onError,
      //   surface: lightColors.surface,
      //   onSurface: lightColors.onSurface,
      //   //surfaceContainerHighest: lightColors.surfaceVariant,
      //   onSurfaceVariant: lightColors.onSurfaceVariant,
      // ).copyWith(surface: Colors.white).copyWith(surface: Colors.grey),
    );
  }

  static ThemeData get mlzslightTheme {
    return ThemeData(
      colorSchemeSeed: const Color(0xff6750a4),
      useMaterial3: true,
      unselectedWidgetColor: Colors.black38,

      /// COLOR
      ///
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.dark,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextTheme.labelMedium.copyWith(color: darkColors.primary),
      ),
      datePickerTheme: DatePickerThemeData(
        //cancelButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(LightColors.kRed),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)) ),
        //confirmButtonStyle: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)) ),
        dayBackgroundColor: WidgetStateProperty.all(Colors.white),
        headerBackgroundColor: Colors.white70,
        headerHeadlineStyle: LightColors.textHeaderStyleWhite,
        headerHelpStyle: LightColors.textHeaderStyleWhite,

        backgroundColor: Colors.white,
        headerForegroundColor: Colors.black,
        surfaceTintColor: Colors.red,
      ),
      // colorScheme: ColorScheme(
      //   brightness: lightColors.brightness,
      //   primary: lightColors.primary,
      //   onPrimary: lightColors.onPrimary,
      //   secondary: lightColors.secondary,
      //   onSecondary: lightColors.onSecondary,
      //   error: lightColors.error,
      //   onError: lightColors.onError,
      //   surface: lightColors.surface,
      //   onSurface: lightColors.onSurface,
      //   //surfaceContainerHighest: lightColors.surfaceVariant,
      //   onSurfaceVariant: lightColors.onSurfaceVariant,
      // ),
      cardColor: Color.lerp(Colors.white60, Colors.white, 0.2),
      cardTheme: ThemeData.light().cardTheme.copyWith(
            color: Colors.white,
            elevation: 2,
          ),

      /// TYPOGRAPHY
      textTheme: AppTextTheme.textTheme,
      iconTheme: IconThemeData(
        color: lightColors.defaultIcon,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.white70),
        side: BorderSide(color: kPrimaryLightColor),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith((states) => kPrimaryLightColor),
        overlayColor: WidgetStateProperty.all(Colors.red),
      ),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: kPrimaryLightColor,
          textStyle: AppTextTheme.labelMedium.copyWith(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColors.surface,
        errorStyle: AppTextTheme.bodySmall.copyWith(color: lightColors.error),
        helperStyle: AppTextTheme.bodySmall
            .copyWith(color: lightColors.onSurfaceVariant),
        hintStyle: AppTextTheme.bodyMedium
            .copyWith(color: lightColors.onSurfaceVariant),
        focusedErrorBorder: lightColors.error.getOutlineBorder,
        errorBorder: lightColors.error.getOutlineBorder,
        focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: lightColors.onSurfaceVariant,
        enabledBorder: Colors.transparent.getOutlineBorder,
        disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: lightColors.primary,
        unselectedLabelColor: lightColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightColors.primary,
              width: 2,
            ),
          ),
        ),
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        lightColors,
        assetTileStyleLight,
        transactionTileStyleLight,
        chartStyleLight,
      ],
    );
  }
}
