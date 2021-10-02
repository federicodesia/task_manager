import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedSnackBar{

  final BuildContext context;
  final String text;
  final SnackBarAction? action;

  RoundedSnackBar({
    required this.context,
    required this.text,
    this.action
  });

  void show(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(cPadding).add(EdgeInsets.only(bottom: cSnackBarBottomMargin)),
        padding: EdgeInsets.fromLTRB(cPadding, 4.0, 6.0, 4.0),
        backgroundColor: cCardBackgroundColor,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cSnackBarBorderRadius))
        ),
        content: Text(
          text,
          style: cTextStyle.copyWith(fontSize: 13.5),
        ),
        action: action
      )
    );
  }
}