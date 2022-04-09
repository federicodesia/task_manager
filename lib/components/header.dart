import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class Header extends StatelessWidget{

  final String text;
  final String? rightText;

  const Header({
    Key? key, 
    required this.text,
    this.rightText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: customTheme.boldTextStyle,
              maxLines: 1
            ),
          ),

          Text(
            rightText ?? "",
            style: customTheme.lightTextStyle,
            maxLines: 1
          )
        ],
      ),
    );
  }
}