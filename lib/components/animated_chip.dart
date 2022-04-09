import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class AnimatedChip extends StatelessWidget{

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLastItem;
  final Function()? onTap;
  
  const AnimatedChip({
    Key? key, 
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.isLastItem,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return GestureDetector(
      child: AnimatedContainer(
        duration: cFastAnimationDuration,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        margin: EdgeInsets.only(right: isLastItem ? 0.0 : 8.0),

        decoration: BoxDecoration(
          color: backgroundColor ?? customTheme.contentBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
        ),

        child: Text(
          text,
          style: customTheme.smallTextStyle.copyWith(color: textColor),
          maxLines: 1,
        )
      ),
      onTap: onTap,
    );
  }
}