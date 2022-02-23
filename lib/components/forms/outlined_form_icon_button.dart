import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class OutlinedFormIconButton extends StatelessWidget{

  final IconData icon;
  final String text;
  final Color? outlineColor;
  final bool expand;
  final Function() onPressed;

  OutlinedFormIconButton({
    required this.icon,
    required this.text,
    this.outlineColor,
    this.expand = false,
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
            size: 22.0,
            color: customTheme.lightColor
          ),
          SizedBox(width: 4.0),

          Expanded(
            flex: expand ? 1 : 0,
            child: Text(
              text,
              style: customTheme.smallTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0
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