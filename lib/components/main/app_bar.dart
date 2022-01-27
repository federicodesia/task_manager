import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/theme/theme.dart';

import '../../constants.dart';

class MyAppBar extends StatelessWidget {

  final String header;
  final String description;
  final Function() onButtonPressed;
  
  MyAppBar({
    required this.header,
    required this.description,
    required this.onButtonPressed
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(cPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: customTheme.headerTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    description,
                    style: customTheme.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // Profile
              RoundedButton(
                width: cButtonSize,
                color: customTheme.contentBackgroundColor,
                child: Image.asset(
                  "assets/icons/profile.png"
                ),
                onPressed: onButtonPressed,
              ),
            ],
          ),
        )
      ],
    );
  }
}