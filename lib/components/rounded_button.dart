import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedButton extends StatelessWidget{

  final Widget child;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final Function() onPressed;

  const RoundedButton({
    required this.child,
    this.color = cPrimaryColor,
    this.width = cButtonSize,
    this.height = cButtonSize,
    this.borderRadius = cBorderRadius,
    this.padding = const EdgeInsets.all(cButtonPadding),
    required this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
          elevation: 0
        ),
      ),
    );
  }
}