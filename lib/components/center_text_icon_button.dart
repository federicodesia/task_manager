import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';

class CenterTextIconButton extends StatelessWidget{

  final Color color;
  final EdgeInsets padding;
  final String text;
  final String iconAsset;
  final Function() onPressed;

  const CenterTextIconButton({
    this.color = cCardBackgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    required this.text,
    required this.iconAsset,
    required this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      width: double.infinity,
      color: color,
      child: Padding(
        padding: padding,
        child: NavigationToolbar(
          leading: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.asset(iconAsset)
          ),
          middle: Text(
            text,
            style: cBoldTextStyle.copyWith(fontSize: 13.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ),
      onPressed: onPressed,
    );
  }
}