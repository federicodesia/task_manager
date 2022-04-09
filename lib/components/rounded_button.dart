import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedButton extends StatelessWidget{

  final Widget child;
  final Color color;
  final bool expandWidth;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final void Function()? onPressed;

  const RoundedButton({
    Key? key, 
    required this.child,
    this.color = cPrimaryColor,
    this.expandWidth = true,
    this.width,
    this.height = cButtonSize,
    this.borderRadius = cBorderRadius,
    this.padding = const EdgeInsets.all(cButtonPadding),
    required this.onPressed
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return SizedBox(
      width: expandWidth ? double.infinity : width,
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

class RoundedTextButton extends StatelessWidget{

  final String text;
  final EdgeInsets textPadding;
  final bool expandWidth;
  final void Function()? onPressed;

  const RoundedTextButton({
    Key? key, 
    required this.text,
    this.textPadding = EdgeInsets.zero,
    this.expandWidth = true,
    required this.onPressed
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return RoundedButton(
      expandWidth: expandWidth,
      child: Padding(
        padding: textPadding,
        child: Text(
          text,
          style: customTheme.primaryColorButtonTextStyle,
          maxLines: 1,
        ),
      ),
      onPressed: onPressed
    );
  }
}