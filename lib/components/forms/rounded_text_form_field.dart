import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedTextFormField extends StatelessWidget{

  final String label;
  final TextInputType textInputType;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  RoundedTextFormField(
    this.label,
    {
      this.textInputType = TextInputType.text,
      this.minLines = 1,
      this.maxLines = 1,
      this.textInputAction = TextInputAction.next
    }
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      minLines: minLines,
      maxLines: maxLines,
      style: cLightTextStyle,
      textInputAction: textInputAction,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: cLightTextStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
          borderSide: BorderSide(style: BorderStyle.none),
        ),
        
        contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        filled: true,
        fillColor: Color(0xFF2A2E3D),
      ),
    );
  }
}