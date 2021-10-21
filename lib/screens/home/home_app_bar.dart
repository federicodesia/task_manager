import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/rounded_button.dart';

class HomeAppBar extends StatelessWidget{

  HomeAppBar();

  @override
  Widget build(BuildContext context) {
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
                    "Hello 👋",
                    style: cHeaderTextStyle,
                  ),

                  Text(
                    "Have a nice day!",
                    style: cLightTextStyle,
                  ),
                ],
              ),

              // Profile
              RoundedButton(
                width: cButtonSize,
                color: Color(0xFF252A34),
                child: Image.asset(
                  "assets/icons/profile.png"
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}