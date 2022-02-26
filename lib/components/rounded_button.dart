import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedButton extends StatelessWidget{

  final Widget child;
  final Color color;
  final double width;
  final double height;
  final bool autoWidth;
  final double borderRadius;
  final EdgeInsets padding;
  final void Function()? onPressed;

  const RoundedButton({
    required this.child,
    this.color = cPrimaryColor,
    this.width = cButtonSize,
    this.height = cButtonSize,
    this.autoWidth = false,
    this.borderRadius = cBorderRadius,
    this.padding = const EdgeInsets.all(cButtonPadding),
    required this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Container(
      width: !autoWidth ? width : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: customTheme.elevation,
          shadowColor: customTheme.shadowColor,
        ),
      ),
    );
  }
}