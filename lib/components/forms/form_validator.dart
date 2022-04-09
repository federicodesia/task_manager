import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class FormValidator extends StatefulWidget{

  final Widget Function(FormFieldState) widget;
  final String? Function(dynamic)? validator;
  final String? errorText;
  final EdgeInsets errorTextPadding;
  
  const FormValidator({
    Key? key, 
    required this.widget,
    this.validator,
    this.errorText,
    this.errorTextPadding = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0)
  }) : super(key: key);

  @override
  State<FormValidator> createState() => _FormValidatorState();
}

class _FormValidatorState extends State<FormValidator> {

  bool errorCurrentState = false;
  bool animate = true;

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);

    return FormField(
      builder: (FormFieldState state){

        bool hasError;
        if(widget.errorText != null) {
          hasError = widget.errorText != null;
        } else {
          hasError = state.hasError;
        }

        if(errorCurrentState && !hasError) {
          animate = false;
        }
        else {
          animate = true;
        }

        errorCurrentState = hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.widget(state),
            
            animate ? AnimatedCrossFade(
              duration: cTransitionDuration,
              crossFadeState: hasError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: widget.errorTextPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (widget.errorText ?? state.errorText) ?? "",
                      style: themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
              secondChild: Container()
            ) : Container()
          ],
        );
      },
      validator: widget.validator,
    );
  }
}