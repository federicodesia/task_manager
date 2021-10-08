import 'package:flutter/material.dart';

const double cPadding = 24.0;
const double cBorderRadius = 18.0;

// Colors

Color cBackgroundColor = Color(0xFF1E1F25);
const Color cPrimaryColor = Color(0xFF7E42FF);
Color cRedColor = Color(0xFFD32F2F);

Color cCardBackgroundColor = Color(0xFF2A2E3D);
Color cOutlinedButtonColor = Color(0xFF2B3039);
Color cCheckBoxUnselectedColor = Color(0xFF2C2F39);

// Buttons
const double cButtonSize = 48.0;
const double cButtonPadding = 10.0;

// List Items
const double cListItemPadding = 18.0;
const double cListItemSpace = 12.0;

// Animations
const Duration cTransitionDuration = Duration(milliseconds: 400);
const Duration cAnimationDuration = Duration(milliseconds: 500);
const Duration cAnimatedListDuration = Duration(milliseconds: 600);

// BottomSheet
const double cBottomSheetBorderRadius = 28.0;

// SnackBar
const double cSnackBarBottomMargin = 64.0;
const double cSnackBarBorderRadius = 12.0;

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
  fontSize: 18.0
);

TextStyle cSubtitleTextStyle = cTextStyle.copyWith(
  fontWeight: FontWeight.w500,
);

const double cHeaderPadding = 16.0;

TextStyle cHeaderTextStyle = cTextStyle.copyWith(
  fontSize: 20.0,
  fontWeight: FontWeight.w600
);