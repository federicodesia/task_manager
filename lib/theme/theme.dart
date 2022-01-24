import 'package:flutter/material.dart';

ThemeData _baseThemeData(ThemeData base) {
  return base.copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
  );
}

ThemeData lightThemeData = _baseThemeData(ThemeData.light()).copyWith(
  scaffoldBackgroundColor: Color(0xFFF3F3F7),
);

ThemeData darkThemeData = _baseThemeData(ThemeData.dark()).copyWith(
  scaffoldBackgroundColor: Color(0xFF1E1F25)
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

  Color get lightTextColor => textColor.withOpacity(0.75);
  TextStyle get lightTextStyle => textStyle.copyWith(
    fontWeight: FontWeight.w400,
    color: lightTextColor
  );
  
  TextStyle get extraLightTextStyle => lightTextStyle.copyWith(fontWeight: FontWeight.w300);
  TextStyle get smallLightTextStyle => lightTextStyle.copyWith(fontSize: 13.0);
  TextStyle get smallExtraLightTextStyle => lightTextStyle.copyWith(fontSize: 13.0, fontWeight: FontWeight.w300);

  final Color backgroundColor;
  final Color contentBackgroundColor;
  final Color textColor;

  const CustomThemeData({
    required this.backgroundColor,
    required this.contentBackgroundColor,
    required this.textColor,
  });

  static CustomThemeData get dark {
    return CustomThemeData(
      backgroundColor: Color(0xFF1E1F25),
      contentBackgroundColor: Color(0xFF272735),
      textColor: Color(0xFFFBFAFC)
    );
  }

  static CustomThemeData get light {
    return CustomThemeData(
      backgroundColor: Color(0xFFF3F3F7),
      contentBackgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF252C35)
    );
  }
}