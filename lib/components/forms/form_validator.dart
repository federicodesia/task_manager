import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class FormValidator extends StatefulWidget{

  final Widget Function(FormFieldState) widget;
  final String? Function(dynamic)? validator;
  final EdgeInsets errorTextPadding;
  
  FormValidator({
    required this.widget,
    this.validator,
    this.errorTextPadding = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0)
  });

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

        if(errorCurrentState && !state.hasError) animate = false;
        else animate = true;

        errorCurrentState = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.widget(state),
            
            animate ? AnimatedCrossFade(
              duration: cTransitionDuration,
              crossFadeState: state.hasError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: widget.errorTextPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorText ?? "",
                      style: themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
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