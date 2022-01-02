import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedTextFormField extends StatelessWidget{

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextInputType textInputType;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? errorText;
  final TextStyle? errorStyle;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLength;
  final String? counterText;
  final TextAlign textAlign;
  
  RoundedTextFormField({
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.errorStyle,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLength,
    this.counterText,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,

      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,

      keyboardType: textInputType,
      minLines: minLines,
      maxLines: maxLines,
      style: cLightTextStyle,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLength: maxLength,
      textAlign: textAlign,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: cExtraLightTextStyle,
        labelText: labelText,
        labelStyle: cExtraLightTextStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
          borderSide: BorderSide(style: BorderStyle.none),
        ),
        
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 20.0
        ),
        filled: true,
        fillColor: cCardBackgroundColor,

        suffixIcon: suffixIcon,
        counterText: counterText,

        errorText: errorText,
        errorStyle: errorStyle
      ),
    );
  }
}