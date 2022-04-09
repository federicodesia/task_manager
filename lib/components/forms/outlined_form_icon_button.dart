import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class OutlinedFormIconButton extends StatelessWidget{

  final IconData icon;
  final String text;
  final Color? outlineColor;
  final bool expand;
  final Function() onPressed;

  const OutlinedFormIconButton({
    Key? key, 
    required this.icon,
    required this.text,
    this.outlineColor,
    this.expand = false,
    required this.onPressed
  }) : super(key: key);

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
          const SizedBox(width: 4.0),

          Expanded(
            flex: expand ? 1 : 0,
            child: Text(
              text,
              style: customTheme.smallTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1
            ),
          )
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
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