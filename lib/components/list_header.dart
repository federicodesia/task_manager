import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class ListHeader extends StatelessWidget{

  final String text;
  ListHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: cDefaultFont,
          fontWeight: FontWeight.w400,
          color: cTextColor
        ),
      ),
    );
  }
}