import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class OutlinedFormIconButton extends StatelessWidget{

  final IconData icon;
  final String text;
  final Color? outlineColor;
  final Function() onPressed;

  OutlinedFormIconButton({
    required this.icon,
    required this.text,
    this.outlineColor,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: customTheme.lightColor
          ),

          Expanded(
            child: Text(
              text,
              style: customTheme.lightTextStyle.copyWith(fontSize: 13.5),
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0
        ),
        side: BorderSide(
          width: 1.5,
          color: outlineColor ?? customTheme.extraLightColor
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
        ),
      ),
    );
  }
}