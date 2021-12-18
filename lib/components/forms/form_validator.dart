import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class FormValidator extends StatelessWidget{

  final Widget Function(FormFieldState<DateTime>) widget;
  final String? Function(DateTime?)? validator;
  
  FormValidator({
    required this.widget,
    this.validator
  });

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);

    return FormField(
      builder: (FormFieldState<DateTime> state){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget(state),
            
            AnimatedCrossFade(
              duration: cTransitionDuration,
              alignment: Alignment.centerLeft,
              crossFadeState: state.hasError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0
                ),
                child: Text(
                  state.errorText.toString(),
                  style: themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              secondChild: Container()
            )
          ],
        );
      },
      validator: validator,
    );
  }
}