import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class AnimatedChip extends StatelessWidget{

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLastItem;
  final Function()? onTap;
  
  AnimatedChip({
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.isLastItem,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: AnimatedContainer(
        duration: cFastAnimationDuration,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        margin: EdgeInsets.only(right: isLastItem ? 0.0 : 8.0),

        decoration: BoxDecoration(
          color: backgroundColor ?? cCardBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
        ),

        child: Text(
          text,
          style: cLightTextStyle.copyWith(color: textColor)
        )
      ),
      onTap: onTap,
    );
  }
}