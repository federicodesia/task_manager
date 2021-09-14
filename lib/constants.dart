import 'package:flutter/material.dart';

const double cPadding = 24.0;
const double cBorderRadius = 18.0;

Color cBackgroundColor = Color(0xFF1E1F25);
Color cPrimaryColor = Color(0xFF7E42FF);

const double cButtonPadding = 10.0;
const double cHeaderPadding = 16.0;
const double cListItemPadding = 18.0;
const double cListItemSpace = 12.0;

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
