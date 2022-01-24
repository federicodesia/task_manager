import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class Header extends StatelessWidget{

  final String text;
  final String? rightText;

  Header({
    required this.text,
    this.rightText
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: cPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: customTheme.boldTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            rightText ?? "",
            style: customTheme.lightTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}