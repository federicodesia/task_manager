import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

ThemeData _baseThemeData(ThemeData base) {
  return base.copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
  );
}

ThemeData lightThemeData = _baseThemeData(ThemeData.light()).copyWith(
  scaffoldBackgroundColor: Color(0xFFF3F3F7),
);

ThemeData darkThemeData = _baseThemeData(ThemeData.dark()).copyWith(
  scaffoldBackgroundColor: Color(0xFF1F1D2C)
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
    color: textColor
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

  TextStyle get textFieldTextStyle => textStyle.copyWith(fontSize: 13.5);
  TextStyle get smallTextStyle => textStyle.copyWith(fontSize: 13.0, color: lightTextColor);
  
  TextStyle get extraLightTextStyle => lightTextStyle.copyWith(fontWeight: FontWeight.w300);
  TextStyle get smallLightTextStyle => lightTextStyle.copyWith(fontSize: 13.0);
  TextStyle get smallTextButtonStyle => smallLightTextStyle.copyWith(color: cTextButtonColor, fontWeight: FontWeight.w500);
  TextStyle get smallExtraLightTextStyle => lightTextStyle.copyWith(fontSize: 13.0, fontWeight: FontWeight.w300);

  Color get extraLightTextColor => textColor.withOpacity(0.5);

  final Color backgroundColor;
  final Color contentBackgroundColor;
  final Color textColor;
  final Color lightColor;
  final Color extraLightColor;

  const CustomThemeData({
    required this.backgroundColor,
    required this.contentBackgroundColor,
    required this.textColor,
    required this.lightColor,
    required this.extraLightColor
  });

  static CustomThemeData get dark {
    return CustomThemeData(
      backgroundColor: Color(0xFF1F1D2C),
      contentBackgroundColor: Color(0xFF272735),
      textColor: Color(0xFFFBFAFC),
      lightColor: Colors.white.withOpacity(0.5),
      extraLightColor: Colors.white.withOpacity(0.25)
    );
  }

  static CustomThemeData get light {
    return CustomThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      contentBackgroundColor: Color(0xFFF5F5F5),
      textColor: Color(0xFF333649),
      lightColor: Color(0xFF798090),
      extraLightColor: Color(0xFFE3E3E3)
    );
  }
}