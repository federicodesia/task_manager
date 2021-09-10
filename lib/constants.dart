import 'package:flutter/material.dart';

const double cPadding = 24.0;
Color cBackgroundColor = Color(0xFF181920);

String cDefaultFont = "Poppins";
Color cTextColor = Color(0xFFFBFAFC);

// AppBar
Color cAppBarFirstColor = Color(0xFF252041);
Color cAppBarSecondColor = Color(0xFF1F222A);
double cAppBarBorderRadius = 24.0;

// Header
TextStyle cHeaderTextStyle = TextStyle(
  fontSize: 20.0,
  fontFamily: cDefaultFont,
  fontWeight: FontWeight.w600,
  color: cTextColor
);

TextStyle cLightHeaderTextStyle = TextStyle(
  fontSize: 14.0,
  fontFamily: cDefaultFont,
  fontWeight: FontWeight.w300,
  color: cTextColor.withOpacity(0.75)
);

// TabIndicator
double cTabIndicatorHeight = 3.0;
double cTabIndicatorPadding = 6.0;
Color cTabIndicatorColor = Color(0xFF434174);

// TabLabel
Color cTabLabelColor = cTextColor;
Color cTabUnselectedLabelColor = cTextColor.withOpacity(0.5);
TextStyle cTabLabelStyle = TextStyle(
    fontSize: 14.0,
    fontFamily: cDefaultFont,
    fontWeight: FontWeight.w400,
);
