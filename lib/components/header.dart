import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class Header extends StatelessWidget{

  final String text;
  final String rightText;

  Header({
    this.text,
    this.rightText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: cPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: cTitleTextStyle.copyWith(fontSize: 14.0),
            ),
          ),

          Text(
            rightText ?? "",
            style: cLightTextStyle,
          )
        ],
      ),
    );
  }
}