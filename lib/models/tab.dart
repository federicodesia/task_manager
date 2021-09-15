import 'package:flutter/material.dart';

class MyTab{
  final String text;
  final Widget content;
  final String botomSheetTitle;
  final Widget bottomSheet;

  MyTab(
    this.text,
    this.content,
    this.botomSheetTitle,
    this.bottomSheet
  );
}