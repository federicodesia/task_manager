import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class FormInputHeader extends StatelessWidget{

  final String text;
  FormInputHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        bottom: 8.0
      ),
      child: Text(
        text,
        style: cBoldTextStyle
      ),
    );
  }
}