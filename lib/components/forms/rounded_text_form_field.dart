import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedTextFormField extends StatefulWidget{

  final TextEditingController? controller;
  final bool? enabled;
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
  final int? maxLength;
  final String? counterText;
  final TextAlign textAlign;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enableObscureTextToggle;
  
  const RoundedTextFormField({
    Key? key, 
    this.controller,
    this.enabled,
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
    this.maxLength,
    this.counterText,
    this.textAlign = TextAlign.start,
    this.prefixIcon,
    this.suffixIcon,
    this.enableObscureTextToggle = false,
  }) : super(key: key);

  @override
  State<RoundedTextFormField> createState() => _RoundedTextFormFieldState();
}

class _RoundedTextFormFieldState extends State<RoundedTextFormField> {
  late bool obscuringText = widget.enableObscureTextToggle;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Material(
      color: customTheme.backgroundColor,
      borderRadius: BorderRadius.circular(cBorderRadius),
      elevation: customTheme.elevation,
      shadowColor: customTheme.shadowColor,
      child: TextFormField(
        enabled: widget.enabled,
        
        controller: widget.controller,
        focusNode: widget.focusNode,

        initialValue: widget.initialValue,
        validator: widget.validator,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,

        keyboardType: widget.textInputType,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        style: customTheme.textStyle,
        textInputAction: widget.textInputAction,

        obscureText: obscuringText,
        enableSuggestions: widget.enableObscureTextToggle ? false : true,
        autocorrect: widget.enableObscureTextToggle ? false : true,

        maxLength: widget.maxLength,
        textAlign: widget.textAlign,

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: customTheme.smallTextStyle,
          labelText: widget.labelText,
          labelStyle: customTheme.smallTextStyle,
          floatingLabelBehavior: FloatingLabelBehavior.never,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
            borderSide: const BorderSide(style: BorderStyle.none),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
            borderSide: const BorderSide(style: BorderStyle.none),
          ),
          
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0
          ),
          filled: true,
          fillColor: customTheme.contentBackgroundColor,

          counterText: widget.counterText,
          errorText: widget.errorText,
          errorStyle: widget.errorStyle,

          prefixIcon: widget.prefixIcon != null ? Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 12.0),
            child: widget.prefixIcon,
          ) : null,
          prefixIconConstraints: const BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: 48.0
          ),

          suffixIcon: widget.enableObscureTextToggle ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: cFastAnimationDuration,
                  child: Icon(
                    obscuringText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    key: Key("ObscureTextIconButtonKeyValue=$obscuringText"),
                  ),
                ),
                splashRadius: 24.0,
                color: customTheme.lightColor,
                onPressed: () => setState(() => obscuringText = !obscuringText)
              ),
            ),
          ) : widget.suffixIcon != null ? Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 18.0),
            child: widget.suffixIcon,
          ) : null,
        ),
      ),
    );
  }
}