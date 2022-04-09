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
        margin: const EdgeInsets.all(cPadding),
        padding: const EdgeInsets.fromLTRB(cPadding, 4.0, 6.0, 4.0),
        backgroundColor: customTheme.contentBackgroundColor,
        elevation: 2.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))
        ),
        content: Text(
          text,
          style: customTheme.smallTextStyle.copyWith(height: 1.0),
          maxLines: 1,
        ),
        action: action,
      )
    );
  }
}