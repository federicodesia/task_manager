import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedButton extends StatelessWidget{

  final Widget child;
  final Color color;
  final double width;
  final Function() onPressed;

  const RoundedButton({
    this.child,
    this.color = cPrimaryColor,
    this.width,
    this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: cButtonSize,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.all(cButtonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
          ),
        ),
      ),
    );
  }
}