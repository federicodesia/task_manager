import 'package:flutter/material.dart';

const double cPadding = 24.0;
Color cBackgroundColor = Color(0xFF1E1F25);

// AppBar
Color cAppBarFirstColor = Color(0xFF252041);
Color cAppBarSecondColor = Color(0xFF1F222A);
double cAppBarBorderRadius = 24.0;

// Text
Color cTextColor = Color(0xFFFBFAFC);
Color cLightTextColor = cTextColor.withOpacity(0.75);

TextStyle cTextStyle = TextStyle(
  fontSize: 14.0,
  fontFamily: "Poppins",
  fontWeight: FontWeight.w400,
  color: cTextColor
);

TextStyle cLightTextStyle = cTextStyle.copyWith(
  fontWeight: FontWeight.w400,
  color: cLightTextColor
);

TextStyle cTitleTextStyle = cTextStyle.copyWith(
  fontWeight: FontWeight.w500,
);

TextStyle cHeaderTextStyle = cTextStyle.copyWith(
  fontSize: 20.0,
  fontWeight: FontWeight.w600
);

// TabIndicator
double cTabIndicatorHeight = 3.0;
double cTabIndicatorPadding = 6.0;
Color cTabIndicatorColor = Color(0xFF434174);