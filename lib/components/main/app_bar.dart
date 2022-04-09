import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';

import '../../constants.dart';

class MyAppBar extends StatelessWidget {

  final String header;
  final String description;
  
  const MyAppBar({
    Key? key, 
    required this.header,
    required this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(cPadding),
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
                    maxLines: 1
                  ),

                  Text(
                    description,
                    style: customTheme.textStyle,
                    maxLines: 1
                  ),
                ],
              ),

              // Profile
              RoundedButton(
                expandWidth: false,
                width: cButtonSize,
                color: customTheme.contentBackgroundColor,
                child: Image.asset(
                  "assets/icons/profile.png"
                ),
                onPressed: () => AutoRouter.of(context).navigate(const ProfileRoute()),
              ),
            ],
          ),
        )
      ],
    );
  }
}