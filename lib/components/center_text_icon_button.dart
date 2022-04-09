import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/theme/theme.dart';

class CenterTextIconButton extends StatelessWidget{

  final EdgeInsets padding;
  final String text;
  final String iconAsset;
  final Function() onPressed;

  const CenterTextIconButton({
    Key? key, 
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    required this.text,
    required this.iconAsset,
    required this.onPressed
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return RoundedButton(
      color: customTheme.contentBackgroundColor,
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
            style: customTheme.boldTextStyle.copyWith(fontSize: 13.5),
            maxLines: 1,
          ),
        )
      ),
      onPressed: onPressed,
    );
  }
}