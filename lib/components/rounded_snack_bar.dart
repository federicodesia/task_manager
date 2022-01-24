import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedSnackBar{

  final BuildContext context;
  final String text;
  final SnackBarAction action;

  RoundedSnackBar({
    required this.context,
    required this.text,
    required this.action
  });

  void show(){
    final customTheme = Theme.of(context).customTheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(cPadding),
        padding: EdgeInsets.fromLTRB(cPadding, 4.0, 6.0, 4.0),
        backgroundColor: cSnackBarBackgroundColor,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cSnackBarBorderRadius))
        ),
        content: Text(
          text,
          style: customTheme.textStyle.copyWith(fontSize: 13.5),
        ),
        action: action
      )
    );
  }
}