import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

ThemeData _baseThemeData(ThemeData base) {
  return base.copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
  );
}

ThemeData lightThemeData = _baseThemeData(ThemeData.light()).copyWith(
  colorScheme: const ColorScheme.light(primary: cPrimaryColor),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
);

ThemeData darkThemeData = _baseThemeData(ThemeData.dark()).copyWith(
  colorScheme: const ColorScheme.dark(primary: cPrimaryColor),
  scaffoldBackgroundColor: const Color(0xFF1F1D2C),
);

extension CustomThemeDataExtension on ThemeData {
  CustomThemeData get customTheme => brightness == Brightness.dark
    ? CustomThemeData.dark
    : CustomThemeData.light;
}

class CustomThemeData {
  
  TextStyle get textStyle => TextStyle(
    fontSize: 14.0,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: textColor,
    overflow: TextOverflow.ellipsis,
  );

  TextStyle get headerTextStyle => textStyle.copyWith(fontSize: 20.0, fontWeight: FontWeight.w600);
  TextStyle get titleTextStyle => textStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 18.0);
  TextStyle get subtitleTextStyle => titleTextStyle.copyWith(fontSize: 16.0);
  TextStyle get boldTextStyle => textStyle.copyWith(fontWeight: FontWeight.w500);
  TextStyle get primaryColorButtonTextStyle => boldTextStyle.copyWith(color: Colors.white);

  Color get lightTextColor => textColor.withOpacity(0.75);
  TextStyle get lightTextStyle => textStyle.copyWith(
    color: lightTextColor
  );

  TextStyle get smallTextStyle => textStyle.copyWith(fontSize: 13.5);
  
  TextStyle get extraLightTextStyle => lightTextStyle.copyWith(fontWeight: FontWeight.w300);
  TextStyle get smallLightTextStyle => lightTextStyle.copyWith(fontSize: 13.0);
  TextStyle get smallTextButtonStyle => smallLightTextStyle.copyWith(color: cTextButtonColor, fontWeight: FontWeight.w400);

  Color get extraLightTextColor => textColor.withOpacity(0.5);

  final bool isDark;
  final Color backgroundColor;
  final Color contentBackgroundColor;
  final Color textColor;
  final Color lightColor;
  final Color mediumLightColor;
  final Color extraLightColor;
  final Color shimmerColor;
  final double elevation;
  final Color shadowColor;
  final Color unselectedCheckboxColor;

  const CustomThemeData({
    required this.isDark,
    required this.backgroundColor,
    required this.contentBackgroundColor,
    required this.textColor,
    required this.lightColor,
    required this.mediumLightColor,
    required this.extraLightColor,
    required this.shimmerColor,
    required this.elevation,
    required this.shadowColor,
    required this.unselectedCheckboxColor
  });

  static CustomThemeData get dark {
    return CustomThemeData(
      isDark: true,
      backgroundColor: const Color(0xFF1F1D2C),
      contentBackgroundColor: const Color(0xFF272735),
      textColor: const Color(0xFFFBFAFC),
      lightColor: Colors.white.withOpacity(0.5),
      mediumLightColor: Colors.white.withOpacity(0.25),
      extraLightColor: Colors.white.withOpacity(0.05),
      shimmerColor: Colors.white.withOpacity(0.03),
      elevation: 0.0,
      shadowColor: Colors.transparent,
      unselectedCheckboxColor: const Color(0xFF2C2F39)
    );
  }

  static CustomThemeData get light {
    return CustomThemeData(
      isDark: false,
      backgroundColor: const Color(0xFFF0F2F5),
      contentBackgroundColor: const Color(0xFFFFFFFF),
      textColor: const Color(0xFF333649),
      lightColor: const Color(0xFF798090),
      mediumLightColor: const Color(0xFFE3E3E3),
      extraLightColor: const Color(0xFFE3E3E3),
      shimmerColor: Colors.black.withOpacity(0.04),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.08),
      unselectedCheckboxColor: const Color(0xFF798090)
    );
  }
}