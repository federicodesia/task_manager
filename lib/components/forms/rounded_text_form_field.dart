import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedTextFormField extends StatelessWidget{

  final String label;
  final String? initialValue;
  final TextInputType textInputType;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onSaved;
  
  RoundedTextFormField({
    required this.label,
    this.initialValue,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,

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